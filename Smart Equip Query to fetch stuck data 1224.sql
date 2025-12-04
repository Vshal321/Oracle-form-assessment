 select distinct segment1 from apps.mtl_system_items_b where inventory_item_id in (21613149,19653207,19652187,31891,6835089)
 /
  select * from apps.mtl_system_items_b where inventory_item_id=21613149
/
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/



SELECT DISTINCT ohia.creation_date,
  (SELECT name
  FROM apps.oe_order_sources
  WHERE order_source_id= ohia.order_source_id
  AND enabled_flag     = 'Y'
  ) source_name,
  ooh.flow_status_code,
  ooh.order_number,
  olia.line_number,
  ot.name,
  msi.segment1 item_num,
  ood.organization_code,
  olia.ordered_quantity,
  olia.order_quantity_uom,
  NULL attachments,
  olia.error_flag,
  ooh.header_id stg_header_ref,
  olia.orig_sys_line_ref stg_line_ref,
  ohia.orig_sys_document_ref interface_header_ref,
  olia.orig_sys_line_ref interface_lines_ref,
  ooh.header_id tms_header_id,
  ooh.orig_sys_document_ref tms_header_ref,
  (SELECT ool.orig_sys_line_ref
  FROM apps.oe_order_lines_all ool
  WHERE ooh.header_id            = ool.header_id(+)
  AND ohia.orig_sys_document_ref = ool.orig_sys_document_ref(+)
  AND olia.line_number           = ool.line_number(+)
  ) tms_line_ref,
  (SELECT ool.line_number
  FROM apps.oe_order_lines_all ool
  WHERE ooh.header_id            = ool.header_id(+)
  AND ohia.orig_sys_document_ref = ool.orig_sys_document_ref(+)
  AND olia.line_number           = ool.line_number(+)
  ) tms_lines_number,
  requests.request_id,
  requests.parameters,
  ooh.creation_date,
  (SELECT hp.party_name
  FROM ar.hz_cust_accounts hz,
    ar.hz_parties hp
  WHERE hz.party_id  =hp.party_id
  AND cust_account_id=ohia.sold_to_org_id
  ) customer_name,
  (SELECT name FROM jtf.jtf_rs_salesreps WHERE salesrep_id=ohia.salesrep_id
  ) Salesrep
FROM apps.oe_headers_iface_all ohia,
  apps.oe_lines_iface_all olia,
  apps.oe_order_headers_v ooh,
  apps.oe_transaction_types_tl ot,
  apps.mtl_system_items_b msi,
  apps.org_organization_definitions ood,
  (SELECT fcr.request_id,
    fcpt.user_concurrent_program_name,
    fcr.argument_text,
    CAST (fcr.actual_start_date AS      TIMESTAMP) act_str_date,
    CAST (fcr.actual_completion_date AS TIMESTAMP) act_com_stt,
    CAST (fcr.requested_start_date AS   TIMESTAMP) Req_time,
    CAST (fcr.last_update_date AS       TIMESTAMP) upt_date,
    DECODE(fcr.status_code, 'C', 'Normal', 'E', 'Error', 'G', 'Warning', 'X', 'Terminated', fcr.status_code) status,
    fcr.argument_text parameters,
    fcr.argument1 p_header_id,
    fcr.argument2 p_customer_number,
    fcr.argument3 p_ship_to_company,
    fcr.argument4 p_carreier_account_number,
    fcr.argument5 p_first_name,
    fcr.argument6 p_last_name,
    fcr.argument7 p_telephone,
    fcr.argument8 p_email,
    fcr.argument9 p_payment_terms,
    fcr.argument10 p_frieght_terms,
    fcr.argument11 p_hold_flag,
    fcr.argument12 p_fright_billing_name,
    fcr.argument13 p_frieght_billing_address,
    fcr.argument14 p_frieght_billing_city,
    fcr.argument15 p_frieght_billing_state,
    fcr.argument16 p_frieght_billing_postal,
    fcr.argument17 p_frieght_billing_country,
    fcr.argument18 p_shipset_flag
  FROM apps.fnd_concurrent_requests fcr,
    apps.fnd_concurrent_programs_tl fcpt
  WHERE fcpt.concurrent_program_id = fcr.concurrent_program_id
  AND fcpt.language                = 'US'
  ) requests
WHERE --ohia.orig_sys_document_ref ='o450071'
  olia.inventory_item_id       = msi.inventory_item_id(+)
AND olia.ship_from_org_id      = msi.organization_id(+)
AND ohia.orig_sys_document_ref = olia.orig_sys_document_ref(+)
AND ohia.orig_sys_document_ref = ooh.orig_sys_document_ref(+)
AND ooh.order_type_id          = ot.transaction_type_id(+)
AND ood.organization_id (+)       =olia.ship_from_org_id-- modified by Sanjana for INC0631069
AND requests.request_id  (+)      =ohia.request_id -- modified by hariprasand for INC0489124
AND ohia.org_id                =ohia.org_id
AND NOT EXISTS
  (SELECT 1
  FROM apps.oe_order_lines_all ool
  WHERE ooh.header_id            = ool.header_id
  AND ohia.orig_sys_document_ref = ool.orig_sys_document_ref
  AND olia.orig_sys_line_ref     = ool.orig_sys_line_ref
  )
--AND NVL(olia.ship_from_org_id, 1) =NVL(:P_SHIP_FROM_ORG_ID,NVL(olia.ship_from_org_id,1))-- modified by Sanjana for INC0631069
AND ohia.order_source_id =NVL(:P_SOURCE_ID,ohia.order_source_id)
  --AND ohia.error_flag=NVL(:P_ERROR_FLAG,ohia.error_flag)
--AND NVL(olia.error_flag,'N')=NVL(:P_ERROR_FLAG,NVL(olia.error_flag,'N'))--modified by hariprasand for INC0493532
--AND ohia.creation_date     >= sysdate-30--removed by hariprasand for INC0489124
AND ohia.creation_date >= sysdate-15 
AND ot.language (+)         = USERENV('LANG')
UNION
SELECT DISTINCT ohia.creation_date,
  (SELECT name
  FROM apps.oe_order_sources
  WHERE order_source_id= ohia.order_source_id
  AND enabled_flag     = 'Y'
  ) source_name,
  ooh.flow_status_code,
  ooh.order_number,
  NULL,
  ot.name,
  NULL item_num,
  ood.organization_code,
  NULL,
  NULL,
  NULL attachments,
  ohia.error_flag,
  ooh.header_id stg_header_ref,
  NULL,
  ohia.orig_sys_document_ref interface_header_ref,
  NULL interface_lines_ref,
  ooh.header_id tms_header_id,
  ooh.orig_sys_document_ref tms_header_ref,
  NULL tms_line_ref,
  NULL tms_lines_number,
  requests.request_id,
  requests.parameters,
  ooh.creation_date,
  (SELECT hp.party_name
  FROM ar.hz_cust_accounts hz,
    ar.hz_parties hp
  WHERE hz.party_id  =hp.party_id
  AND cust_account_id=ohia.sold_to_org_id
  ) customer_name,
  (SELECT name FROM jtf.jtf_rs_salesreps WHERE salesrep_id=ohia.salesrep_id
  ) Salesrep
FROM apps.oe_headers_iface_all ohia,
  apps.oe_order_headers_v ooh,
  apps.oe_transaction_types_tl ot,
  apps.org_organization_definitions ood,
  (SELECT fcr.request_id,
    fcpt.user_concurrent_program_name,
    fcr.argument_text,
    CAST (fcr.actual_start_date AS      TIMESTAMP) act_str_date,
    CAST (fcr.actual_completion_date AS TIMESTAMP) act_com_stt,
    CAST (fcr.requested_start_date AS   TIMESTAMP) Req_time,
    CAST (fcr.last_update_date AS       TIMESTAMP) upt_date,
    DECODE(fcr.status_code, 'C', 'Normal', 'E', 'Error', 'G', 'Warning', 'X', 'Terminated', fcr.status_code) status,
    fcr.argument_text parameters,
    fcr.argument1 p_header_id,
    fcr.argument2 p_customer_number,
    fcr.argument3 p_ship_to_company,
    fcr.argument4 p_carreier_account_number,
    fcr.argument5 p_first_name,
    fcr.argument6 p_last_name,
    fcr.argument7 p_telephone,
    fcr.argument8 p_email,
    fcr.argument9 p_payment_terms,
    fcr.argument10 p_frieght_terms,
    fcr.argument11 p_hold_flag,
    fcr.argument12 p_fright_billing_name,
    fcr.argument13 p_frieght_billing_address,
    fcr.argument14 p_frieght_billing_city,
    fcr.argument15 p_frieght_billing_state,
    fcr.argument16 p_frieght_billing_postal,
    fcr.argument17 p_frieght_billing_country,
    fcr.argument18 p_shipset_flag
  FROM apps.fnd_concurrent_requests fcr,
    apps.fnd_concurrent_programs_tl fcpt
  WHERE fcpt.concurrent_program_id = fcr.concurrent_program_id
  AND fcpt.language                = 'US'
  ) requests
WHERE --ohia.orig_sys_document_ref ='o450071'
  ohia.orig_sys_document_ref = ooh.orig_sys_document_ref(+)
AND ooh.order_type_id        = ot.transaction_type_id(+)
AND ood.organization_id (+)     =ohia.ship_from_org_id-- modified by Sanjana for INC0631069
AND requests.request_id (+)     =ohia.request_id-- modified by hariprasand for INC0489124
AND ohia.org_id              =ohia.org_id
AND NOT EXISTS
  (SELECT 1
  FROM apps.oe_order_lines_all ooh1
  WHERE ohia.orig_sys_document_ref = ooh1.orig_sys_document_ref
  )
--AND NVL(ohia.ship_from_org_id, 1) =NVL(:P_SHIP_FROM_ORG_ID,NVL(ohia.ship_from_org_id,1))-- modified by Sanjana for INC0631069
AND ohia.order_source_id    =NVL(:P_SOURCE_ID,ohia.order_source_id)
--AND NVL(ohia.error_flag,'N')=NVL(:P_ERROR_FLAG,ohia.error_flag)
  --AND NVL(olia.error_flag,'N')=NVL(:P_ERROR_FLAG,'N')
AND ohia.creation_date >= sysdate-15 -- removed by hariprasand for INC0489124
AND ot.language (+)     = USERENV('LANG');

/
 --1393   1353

-- Staging table for Smart Equip Orders
apps.trex_process_order_line_stg