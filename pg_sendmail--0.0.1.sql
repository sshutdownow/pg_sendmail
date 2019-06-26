
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
  result boolean;
  begin
       result = (select mail(  mailfrom,
                            rcptto,
                            '=?UTF-8?B?' || encode(convert_from(convert_to(subject, 'utf-8'), 'latin-1')::bytea, 'base64')::text || '?=',
                            convert_from(convert_to(msg_body, 'utf-8'), 'latin-1')::text,
                            E'MIME-Version: 1.0\nContent-Type: text/plain; charset=\"utf-8\"\nContent-Transfer-Encoding: 8bit'));
	return result;
  end;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  ALTER FUNCTION sendmail(text, text, text, text) OWNER TO postgres;
