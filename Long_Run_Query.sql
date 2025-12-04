SELECT ses.SID, ses.serial#,SUBSTR (ses.username, 1, 12) user_name, sq.sql_text--, ses.*
FROM v$sql sq, v$session ses, apps.fnd_concurrent_requests cr
WHERE cr.oracle_session_id = ses.audsid
AND sq.hash_value = ses.sql_hash_value
AND cr.request_id = 1665537720;


SELECT ses.SID, ses.serial#,SUBSTR (ses.username, 1, 12) user_name --sq.sql_text--, ses.*
FROM /*apps.v$sql sq*/ V$SESSION_LONGOPS ses, apps.fnd_concurrent_requests cr
WHERE cr.oracle_session_id = ses.sid
--AND sq.hash_value = ses.sql_hash_value
AND cr.request_id = 1648409147;

select oracle_session_id from apps.fnd_concurrent_requests
where request_id = 1648409147;

