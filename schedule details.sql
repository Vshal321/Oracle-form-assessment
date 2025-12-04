select r.request_id,
       p.user_concurrent_program_name || case
         when p.user_concurrent_program_name = 'Report Set' then
          (select ' - ' || s.user_request_set_name
             from apps.fnd_request_sets_tl s
            where s.application_id = r.argument1
              and s.request_set_id = r.argument2
              and language = 'US')
         when p.user_concurrent_program_name = 'Check Periodic Alert' then
          (select ' - ' || a.alert_name
             from apps.alr_alerts a
            where a.application_id = r.argument1
              and a.alert_id = r.argument2
              and language = 'US')
       end concurrent_program_name,
       case
         when p.user_concurrent_program_name != 'Report Set' and
              p.user_concurrent_program_name != 'Check Periodic Alert' then
          r.argument_text
       end argument_text,
       r.requested_start_date next_run,
       r.hold_flag on_hold,
       decode(c.class_type,
              'P',
              'Periodic',
              'S',
              'On Specific Days',
              'X',
              'Advanced',
              c.class_type) schedule_type,
       case
         when c.class_type = 'P' then
          'Repeat every ' ||
          substr(c.class_info, 1, instr(c.class_info, ':') - 1) ||
          decode(substr(c.class_info, instr(c.class_info, ':', 1, 1) + 1, 1),
                 'N',
                 ' minutes',
                 'M',
                 ' months',
                 'H',
                 ' hours',
                 'D',
                 ' days') ||
          decode(substr(c.class_info, instr(c.class_info, ':', 1, 2) + 1, 1),
                 'S',
                 ' from the start of the prior run',
                 'C',
                 ' from the completion of the prior run')
         when c.class_type = 'S' then
          nvl2(dates.dates, 'Dates: ' || dates.dates || '. ', null) ||
          decode(substr(c.class_info, 32, 1), '1', 'Last day of month ') ||
          decode(sign(to_number(substr(c.class_info, 33))),
                 '1',
                 'Days of week: ' ||
                 decode(substr(c.class_info, 33, 1), '1', 'Su ') ||
                 decode(substr(c.class_info, 34, 1), '1', 'Mo ') ||
                 decode(substr(c.class_info, 35, 1), '1', 'Tu ') ||
                 decode(substr(c.class_info, 36, 1), '1', 'We ') ||
                 decode(substr(c.class_info, 37, 1), '1', 'Th ') ||
                 decode(substr(c.class_info, 38, 1), '1', 'Fr ') ||
                 decode(substr(c.class_info, 39, 1), '1', 'Sa '))
       end schedule,
       c.date1 start_date,
       c.date2 end_date,
       c.class_info,
       r.increment_dates ,
       r.recalc_parameters
  from apps.fnd_concurrent_requests r,
       apps.fnd_conc_release_classes c,
       apps.fnd_concurrent_programs_tl p,
       (SELECT release_class_id,
               substr(max(SYS_CONNECT_BY_PATH(s, ' ')), 2) dates
          FROM (select release_class_id,
                       rank() over(partition by release_class_id order by s) a,
                       s
                  from (select c.class_info,
                               l,
                               c.release_class_id,
                               decode(substr(c.class_info, l, 1),
                                      '1',
                                      to_char(l)) s
                          from (select level l from dual connect by level <= 31),
                               apps.fnd_conc_release_classes c
                         where c.class_type = 'S')
                 where s is not null)
        CONNECT BY PRIOR
                    (a || release_class_id) = (a - 1) || release_class_id
         START WITH a = 1
         group by release_class_id) dates
 where 
-- r.phase_code = 'P'
-- r.request_id = 1647267572
r.requested_by = 87970
and r.status_code = 'Q'
   and c.application_id = r.release_class_app_id
   and c.release_class_id = r.release_class_id
   and nvl(c.date2, sysdate + 1) > sysdate
   and c.class_type is not null
   and p.concurrent_program_id = r.concurrent_program_id
   and p.application_id = r.program_application_id
   and p.language = 'US'
   and dates.release_class_id(+) = r.release_class_id
 order by on_hold, next_run;