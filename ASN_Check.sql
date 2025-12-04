Select *
From apps.Wsh_New_Deliveries A
where delivery_id IN (969160563,
969150019,
969160682,
969162069);
--where a.ORGANIZATION_ID = 21417
--and a.CUSTOMER_ID = 3622101
where a.ASN_DATE_SENT is not null;
--order by a.ASN_DATE_SENT desc;



select * from apps.WSH_DSNO_DELIVERIES_V
where tp_test_flag ! = 'T'
and organization_id = 21417
and time_stamp_date between sysdate-10 and sysdate
order by time_stamp_date desc;

select * from apps.WSH_DSNO_DELIVERIES_V
where tp_test_flag ! = 'T'
and organization_id = 21417
and time_stamp_date between sysdate-10 and sysdate
order by time_stamp_date desc;
where delivery_id IN (968936528,968882808);


select * from apps.WSH_DSNO_DELIVERIES_V
where delivery_id IN (969101313,
969092923,
969118875);