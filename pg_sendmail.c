/*
 * Copyright (c) 2017 Igor Popov <ipopovi@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */

#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"

#include <stdio.h>
#include <sysexits.h>
#include <stdbool.h>

#define SENDMAIL_PATH	"/usr/sbin/sendmail"

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

PG_FUNCTION_INFO_V1(mail);

/*
bool mail (VarChar * from, VarChar * to,VarChar * subject, VarChar * message, VarChar * headers)
*/
Datum mail(PG_FUNCTION_ARGS)
{
	int ret;
	char *from = NULL, *rcpto = NULL, *subject = NULL, *body_message =
	    NULL, *headers = NULL;
	FILE *sendmail;
	char sendmail_cmd[1024];

	/*  Get arguments.  If we declare our function as STRICT, then
	   this check is superfluous. */
	if (PG_NARGS() != 5) {
		PG_RETURN_NULL();
	}

	if (PG_ARGISNULL(0)) {
		elog(ERROR, "mail: Sender name must be specified");
		PG_RETURN_NULL();
	} else {
		from = text_to_cstring(PG_GETARG_TEXT_PP(0));
	}

	if (PG_ARGISNULL(1)) {
		elog(ERROR, "mail: Recipient names must be specified");
		PG_RETURN_NULL();
	} else {
		rcpto = text_to_cstring(PG_GETARG_TEXT_PP(1));
	}

	if (PG_ARGISNULL(2)) {
		elog(NOTICE, "mail: No subject specified");
	} else {
		subject = text_to_cstring(PG_GETARG_TEXT_PP(2));
	}

	if (PG_ARGISNULL(3)) {
		elog(ERROR, "mail: No message body specified");
		PG_RETURN_NULL();
	} else {
		body_message = text_to_cstring(PG_GETARG_TEXT_PP(3));
	}

	if (PG_ARGISNULL(4)) {
		elog(NOTICE, "mail: no headers");
	} else {
		headers = text_to_cstring(PG_GETARG_TEXT_PP(4));
	}

	if (snprintf
	    (sendmail_cmd, sizeof(sendmail_cmd), SENDMAIL_PATH " -f%s %s", from,
	     rcpto) < 0) {
		elog(ERROR, "mail: snprintf failed");
		PG_RETURN_NULL();
	}

	sendmail = popen(sendmail_cmd, "w");
	if (!sendmail) {
		elog(ERROR, "mail: Could not execute mail delivery program");
		PG_RETURN_BOOL(FALSE);
	}

	fprintf(sendmail, "To: %s\n", rcpto);
	fprintf(sendmail, "From: %s\n", from);
	if (subject) {
		fprintf(sendmail, "Subject: %s\n", subject);
	} else {
		fprintf(sendmail, "Subject: [no subject]\n");
	}
	if (headers) {
		fprintf(sendmail, "%s\n", headers);
	}
	fprintf(sendmail, "\n%s\n", body_message);

	fflush(sendmail);

	ret = pclose(sendmail);

	if (from)
		pfree(from);

	if (rcpto)
		pfree(rcpto);

	if (subject)
		pfree(subject);

	if (body_message)
		pfree(body_message);

	if (headers)
		pfree(headers);

	if ((ret != EX_OK) && (ret != EX_TEMPFAIL)) {
		elog(ERROR, "mail: sendmail failed");
		PG_RETURN_BOOL(FALSE);
	}

	PG_RETURN_BOOL(TRUE);
}
