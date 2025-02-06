/*
 * Copyright (c) 2017-2019 Igor Popov <ipopovi@gmail.com>
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

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION pg_sendmail" to load this file. \quit


CREATE OR REPLACE FUNCTION mail(mailfrom text, rcptto text, subject text, msg_body text, headers text)
    RETURNS boolean AS
    '$libdir/pg_sendmail', 'mail'
    LANGUAGE C VOLATILE STRICT;

CREATE OR REPLACE FUNCTION sendmail(
    text,
    text,
    text,
    text)
  RETURNS boolean AS
  $BODY$declare
  mailfrom alias for $1;
  rcptto alias for $2;
  subject alias for $3;
  msg_body alias for $4;
  str_part_subj text;
  subject_enc text := null;
  begin
  	for str_part_subj in (select substring(subject from n for 20) from generate_series(1, length(subject), 20) n) loop
		  if subject_enc is not null then
			  subject_enc := subject_enc || E'\n ' || '=?utf-8?B?' || encode(convert_from(convert_to(str_part_subj , 'utf-8'), 'latin-1')::bytea, 'base64')::text || '?=';
		  else 
			  subject_enc := '=?utf-8?B?' || encode(convert_from(convert_to(str_part_subj, 'utf-8'), 'latin-1')::bytea, 'base64')::text || '?=';
		  end if;
	  end loop;
  
  
    return mail(  mailfrom,
                  rcptto,
                  subject_enc,
                  convert_from(convert_to(msg_body, 'utf-8'), 'latin-1')::text,
                  E'MIME-Version: 1.0\nContent-Type: text/plain; charset=\"utf-8\"\nContent-Transfer-Encoding: 8bit');
  end;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  ALTER FUNCTION sendmail(text, text, text, text) OWNER TO postgres;
