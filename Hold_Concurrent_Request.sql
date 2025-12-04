select distinct c.user_concurrent_program_name,
      round(((sysdate-a.actual_start_date)*24*60*60/60),2) as process_time,
    a.request_id,
    a.parent_request_id,
    a.request_date,
    a.actual_start_date,
    a.actual_completion_date,
    a.last_update_date,
    e.user_name "Last Updated By",
      (a.actual_completion_date-a.request_date)*24*60*60 as end_to_end,
      d.user_name,
      a.phase_code,
      a.status_code "Program Status",
      a.hold_flag "Hold Flag",
      a.argument_text "Program Paramters"
from     apps.fnd_concurrent_requests a,
    apps.fnd_concurrent_programs b ,
    apps.fnd_concurrent_programs_tl c,
    apps.fnd_user d,
    apps.fnd_user e
where   a.concurrent_program_id=b.concurrent_program_id and
    b.concurrent_program_id=c.concurrent_program_id and
    a.requested_by=d.user_id
    and a.LAST_UPDATED_BY = e.user_id
--and  a.requested_start_date > SYSDATE
--and a.request_id = 1646934040
--and a.requested_start_date between sysdate-1 and sysdate
and  a.hold_flag = 'Y'
and c.language = 'US'
order by process_time desc