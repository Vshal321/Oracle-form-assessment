
select creation_date,a.* from apps.ece_stage a
where transaction_type = 'ASNI'
and creation_date between sysdate-7 and sysdate
order by a.creation_date desc;


select shipment_num,transaction_date,WAYBILL_AIRBILL_NUM,a.* From apps.RCV_HEADERS_INTERFACE a
--where creation_date is not null
--where asn_type = 'ASN'
where shipment_num IN ('265417536')
order by creation_date desc;


select ITEM_NUM,org_id,operating_unit,ITEM_NUM,a.* from apps.rcv_transactions_interface a  --16862321   --16585678   ---16862321
where HEADER_INTERFACE_ID IN (35992556)
order by creation_date desc;

select * from apps.po_interface_errors;

select SHIP_TO_ORG_ID,shipment_num,WAYBILL_AIRBILL_NUM,a.* from apps.rcv_shipment_headers a
--where VENDOR_ID = 5728
--order by creation_date desc;
where shipment_num IN ('265417536');
where shipment_header_id IN (56179422);

select * from apps.rcv_shipment_lines a
--order by creation_date desc;
where SHIPMENT_HEADER_ID IN (56243059);
--WHERE PO_HEADER_ID = 1367357
--AND PO_RELEASE_ID = 22940581
--AND PO_LINE_ID = 11277644;
--AND PO_LINE_LOCATION_ID = 33892722;

select * From apps.org_organization_definitions
where organization_id = 31890;


--Group ID from RCV_HEADER_INTERFACE match with batch id--
--HEADER_INTERFACE_ID from RCV_HEADER match with interface_header_id--
SELECT rhi.HEADER_INTERFACE_ID,rhi.shipment_num, rhi.creation_date, rhi.PROCESSING_STATUS_CODE,rhi.RECEIPT_SOURCE_CODE, rhi.AUTO_TRANSACT_CODE, rhi.VENDOR_NUM,
aps.vendor_name, pie.INTERFACE_TYPE, pie.TABLE_NAME,
pie.COLUMN_NAME,pie.ERROR_MESSAGE_NAME,pie.error_message
FROM apps.RCV_HEADERS_INTERFACE rhi, /*apps.RCV_TRANSACTIONS_INTERFACE rti,*/ apps.po_interface_errors pie, apps.ap_suppliers aps
where rhi.HEADER_INTERFACE_ID = pie.interface_header_id
--and rhi.HEADER_INTERFACE_ID = rti.HEADER_INTERFACE_ID
and rhi.processing_status_code = 'ERROR'
and asn_type = 'ASN'
and rhi.vendor_num = aps.segment1
--and rhi.vendor_id = aps.vendor_id
and rhi.creation_date between sysdate-7 and sysdate
order by rhi.creation_date desc;