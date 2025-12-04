SELECT
    papf.full_name                                                          "Full Name - HR",
    ppt.user_person_type                                                    "User Type",
    CASE
        WHEN sysdate BETWEEN pos.date_start AND nvl(pos.actual_termination_date, sysdate + 1) THEN
            'Active'
        ELSE
            'Terminated'
    END                                                                     AS "Employment",
    nvl(paaf.ass_attribute1, 'Unidentified Card Title')                   AS "Business Card Title",
    nvl(org.name, 'Unidentified Organization')                            AS "HR Organization Name",
    nvl(nvl(bu_p.name, bu.name), 'Unidentified Business Unit')          AS "Business Unit",
    nvl(nvl(seg_p.name, seg.name), 'Unidentified Segment')              AS "Segment Name",
    nvl(hla2.location_code, 'Unidentified Work Location')                 AS "Work Location",
    nvl(hla.derived_locale, 'Unidentified Physical Location')             AS "Physical Location",
    nvl(papf_s.full_name, 'Unidentified Hiring Manager')                  AS "Hiring Manager - 1st Level",
    nvl(papf_s.email_address, 'Unidentified Hiring Manager email')        AS "Email Address - 1st Level",
    nvl(papf_s2.full_name, 'Unidentified Group Manager')                  AS "Hiring Manager - 2nd Level",
    nvl(papf_s2.email_address, 'Unidentified Group Manager email')        AS "Email Address - 2nd Level"
FROM
         apps.per_people_f papf
    JOIN apps.per_assignments_f          paaf ON ( paaf.person_id = papf.person_id )
    LEFT OUTER JOIN (
             apps.per_person_type_usages_x ptu
        JOIN hr.per_person_types             ppt ON ( ppt.person_type_id = ptu.person_type_id
                                          AND ppt.active_flag = 'Y'
                                          AND trunc(sysdate) BETWEEN ptu.effective_start_date AND ptu.effective_end_date )
    ) ON ( ptu.person_id = papf.person_id )
    LEFT OUTER JOIN hr.hr_locations_all             hla ON ( hla.location_id = paaf.location_id )
    LEFT OUTER JOIN hr.per_periods_of_service       pos ON ( pos.person_id = paaf.person_id
                                                       AND pos.period_of_service_id = paaf.period_of_service_id )
         /* Assignment Organizations Set */
    LEFT OUTER JOIN hr.hr_all_organization_units    org ON org.organization_id = paaf.organization_id
    LEFT OUTER JOIN hr.hr_all_organization_units    bu ON to_char(bu.organization_id) = org.attribute6
    LEFT OUTER JOIN hr.hr_all_organization_units    seg ON to_char(seg.organization_id) = org.attribute7
    LEFT OUTER JOIN hr.hr_locations_all             hla2 ON ( hla2.location_id = org.location_id )
         /* People Group Record */
    LEFT OUTER JOIN hr.pay_people_groups            pg ON pg.people_group_id = paaf.people_group_id
         /* People Group Organizations Set */
    LEFT OUTER JOIN hr.hr_all_organization_units    bu_p ON to_char(bu_p.organization_id) = pg.segment1
    LEFT OUTER JOIN hr.hr_all_organization_units    seg_p ON to_char(seg_p.organization_id) = bu_p.attribute7
         /*  The Employee's Supervisor  */
    LEFT OUTER JOIN apps.per_people_f               papf_s ON ( papf_s.person_id = paaf.supervisor_id
                                                  AND trunc(sysdate) BETWEEN papf_s.effective_start_date AND papf_s.effective_end_date )
         /*  The Employee's Supervisor's Supervisor  */
    LEFT OUTER JOIN apps.per_assignments_f          paaf_s ON ( paaf_s.person_id = papf_s.person_id
                                                       AND trunc(sysdate) BETWEEN paaf_s.effective_start_date AND paaf_s.effective_end_date )
    LEFT OUTER JOIN apps.per_people_f               papf_s2 ON ( papf_s2.person_id = paaf_s.supervisor_id
                                                   AND trunc(sysdate) BETWEEN papf_s2.effective_start_date AND papf_s2.effective_end_date )
WHERE
        1 = 1
    AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date
    AND trunc(sysdate) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
    AND upper(papf.full_name) LIKE upper('%Amna%')
    --AND upper(papf.full_name) LIKE upper('%Thorsen, Ms. Carmen L (Carmen)%')
    --AND papf_s.full_name like '%Klingelhoefer%'
    --AND papf_s.full_name like '%Thorsen%'
     /* Ad Hoc Filters */
     --   AND hla.location_code != hla2.location_code
ORDER BY
    papf.full_name;


---Access provisioning header line table

SELECT
    dtl.item_key,hdr.*,dtl.*
FROM
    bolinf.trex_fnd_user_resp_hdr_tbl    hdr,
    bolinf.trex_fnd_user_resp_det_tbl    dtl
WHERE
        hdr.request_id IN ('SEC21179') --SEC20704   --SEC20641
        --and dtl.request_status ! = 'Closed'
    AND hdr.header_id = dtl.header_id  ;
/

SELECT
    dtl.item_key,hdr.*,dtl.*
FROM
    bolinf.trex_fnd_user_resp_hdr_tbl    hdr,
    bolinf.trex_fnd_user_resp_det_tbl    dtl
WHERE
        hdr.CREATED_FOR_USER_NAME IN ('RICK.HANDLEY')
        --and responsibility_name = 'CH230 Counter Supervisor Charlotte AWP'
    AND hdr.header_id = dtl.header_id  
    order by hdr.creation_Date desc;

select * from apps.wf_notifications
where item_key = '34450';
and notification_id = 155813332;
---Profile


select name, notification_preference,a.*
from apps.wf_users a
where status = 'ACTIVE'
and name like 'JOSEPH%RAFF%';
and name like 'GARY%MASS%';
notification_preference = 'DISABLED'
/

SELECT
    p.user_profile_option_name,
    '3 - User',
    u.user_name,
    v.level_value,
    v.profile_option_value
FROM
    apps.fnd_profile_option_values    v,
    apps.fnd_profile_options_vl       p,
    apps.fnd_user                     u
WHERE
        v.profile_option_id = p.profile_option_id
    AND ( v.level_id = 10004
          AND u.user_id = v.level_value )
    AND u.user_name = 'TARANDEEP.SINGH'
ORDER BY
    1,
    2,
    3;



---QUERY FOR LOV
----------------------
select distinct nvl(papf.full_name,fu.user_name) employee_name,fu.user_id,fu.user_name,
spapf.full_name supervisor_name
from per_all_people_f papf,
per_assignments_x paaf,
per_people_x spapf,
fnd_user fu,
fnd_user sfu,
fnd_profile_option_values fpov
where
papf.person_id = paaf.person_id
AND paaf.supervisor_id = spapf.person_id
AND spapf.person_id = sfu.employee_id
and sysdate between nvl(sfu.start_date,sysdate) and nvl(fu.end_date,sysdate)
and papf.person_id = fu.employee_id
and fu.user_id = fpov.level_value
and sysdate between papf.effective_start_date and papf.effective_end_date
and sysdate between paaf.effective_start_date and paaf.effective_end_date
and sysdate between spapf.effective_start_date and spapf.effective_end_date
and sysdate between nvl(fu.start_date,sysdate) and nvl(fu.end_date,sysdate)
and fpov.level_id=10004
AND fpov.profile_option_id=12111
and fpov.profile_option_value not in
(
select flv.meaning from fnd_lookup_values flv where flv.lookup_type = 'TREX_SOD_EXCLUDE_USER_TYPE'
and flv.language = 'US'
);

SELECT
    *
FROM
    bolinf.trex_fnd_user_resp_hdr_tbl    hdr,
    bolinf.trex_fnd_user_resp_det_tbl    dtl
WHERE
        hdr.request_id = 'SEC20013'
    AND hdr.header_id = dtl.header_id  ;