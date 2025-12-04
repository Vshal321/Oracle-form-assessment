SELECT
    *
FROM
    apps.oe_lookups flv
WHERE
        lookup_type = 'FREIGHT_TERMS'
    AND lookup_code LIKE 'FCA%'
    AND sysdate BETWEEN flv.start_date_active AND nvl(flv.end_date_active, sysdate);


SELECT
    flv.attribute1,
    flv.*
                            --          INTO l_inco_term
FROM
    apps.fnd_lookup_values flv
WHERE
        flv.lookup_type = 'TEREX_ECOM_USER_TYPE'
    --AND flv.lookup_code = 'AWPNA' --p_user_type
    AND flv.language (+) = userenv('LANG')
    AND flv.enabled_flag = 'Y'
    AND sysdate BETWEEN flv.start_date_active AND nvl(flv.end_date_active,sysdate);



SELECT
    *
FROM
    bolinf.trex_process_order_line_stg
WHERE
        error_flag = 'E'
    AND error_message LIKE '%FREIGHT_TERMS%';

SELECT
    *
FROM
    bolinf.trex_process_order_line_stg
WHERE
    order_id = 'AWP_ORDERS_SE225800';

---9218315
select count(distinct order_id) from bolinf.TREX_PROCESS_ORDER_LINE_STG
where ERROR_MESSAGE like '%must be a value defined in lookup type FREIGHT_TERMS%'
order by creation_date desc;


select customer_type,a.* from bolinf.TREX_PROCESS_ORDER_LINE_STG a
where ERROR_MESSAGE like '%must be a value defined in lookup type FREIGHT_TERMS%'
order by last_update_Date desc;

select * from bolinf.TREX_PROCESS_ORDER_LINE_STG
where order_id = 'AWP_ORDERS_SE226146';
where error_flag = 'E'
--and creation_date between sysdate-6 and sysdate
order by last_update_date desc;

select * from bolinf.TREX_AWP_SE_ORDR_STR_NUM_STG
where ORIG_SYS_DOCUMENT_REF like 'AWP_ORDERS_SE2261%';

select * from apps.oe_order_headers_all
where orig_sys_document_ref = 'AWP_ORDERS_SE217780';