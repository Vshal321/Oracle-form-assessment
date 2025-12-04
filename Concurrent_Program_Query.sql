select parent_request_id,argument2,to_char(round((sysdate-ACTUAL_START_DATE)*1440,0))||' Mins '||to_char(round(mod((sysdate-ACTUAL_START_DATE)*86400,60),2))||' Secs' running_duration, to_char(round((ACTUAL_COMPLETION_DATE-ACTUAL_START_DATE)*1440,0))||' Mins '||to_char(round(mod((ACTUAL_COMPLETION_DATE-ACTUAL_START_DATE)*86400,60),2))||' Secs' duration,concurrent_program_id,
a.* from apps.fnd_concurrent_requests a
where request_id IN (1647177911);   ----1646927470   --1642330104

select argument2,to_char(round((ACTUAL_COMPLETION_DATE-ACTUAL_START_DATE)*1440,0))||' Mins '||to_char(round(mod((ACTUAL_COMPLETION_DATE-ACTUAL_START_DATE)*86400,60),2))||' Secs' duration,resubmit_interval,resubmit_interval_unit_code,a.* 
from apps.fnd_concurrent_requests a
where concurrent_program_id = 33921
--and argument5 = 'BOA'
--and argument3 = 'o10999631'
--and printer  = 'WILPR026'
--and  requested_by IN (261765)
--and status_code = 'E'
--and argument_text = '1619, , 0, , , 4'
order by a.request_id desc;

select email_address,a.* From apps.fnd_user a
--where user_name like 'KRISHNA.%';
where user_id = 62232;

select * from apps.fnd_concurrent_programs_tl 
where concurrent_program_id IN (33921)
and language = 'US';

select * from apps.fnd_concurrent_programs_tl
where upper(user_concurrent_program_name) like upper('%OCC%')
and language = 'US';

select * from apps.fnd_concurrent_programs_tl
where upper(user_concurrent_program_name) like upper('%Terex OCC Product Feed Program')
and language = 'US';

select execution_file_name, a . * from apps.FND_EXECUTABLES_FORM_V a
where executable_id  in (select executable_id from apps.FND_CONCURRENT_PROGRAMS_VL a  
where concurrent_program_id = 692610);

select  * from apps.FND_CONCURRENT_PROGRAMS_VL a  
where executable_id = 12606;

select execution_file_name, a . * from apps.FND_EXECUTABLES_FORM_V a
where execution_file_name like '%TREX_RESP_APPRWF_PKG%';

select concurrent_program_id,a.* from apps.FND_CONCURRENT_PROGRAMS_VL a  
where concurrent_program_id = 20428;

select * from apps.fnd_user
where user_id = 275901;

select * From apps.TREX_CONCURRENT_REQUESTS_HIST
where concurrent_program_id = 32291
order by requested_start_Date desc;

select distinct requested_by, user_name, email_address
from apps.fnd_concurrent_requests a, apps.fnd_user b
where a.requested_by = b.user_id
and a.concurrent_program_id = 532583;
order by a.request_id desc;