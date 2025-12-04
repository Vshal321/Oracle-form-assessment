
SELECT * FROM apps.RCV_HEADERS_INTERFACE
where shipment_num = '243909861'
order by creation_Date desc;

SELECT shipment_header_id,shipment_line_id,DOCUMENT_SHIPMENT_LINE_NUM,a.* FROM RCV_TRANSACTIONS_INTERFACE a
where HEADER_INTERFACE_ID IN (34822310);
--where INTERFACE_TRANSACTION_ID = 97969854
order by creation_Date desc;

select * From apps.rcv_shipment_headers
--order by creation_date desc;
where shipment_num IN ('243780300');

select a.* from apps.rcv_shipment_lines a
--w-ere creation_date between sysdate-1 and sysdate
--order by creation_Date desc;
where shipment_header_id IN (55450569);


select * From apps.rcv_transactions
where shipment_header_id IN (55450569);


select * From org_organization_definitions
where organization_id = 31890;

select * From po_interface_errors
--order by creation_Date desc;--97969854
where interface_header_id = 34822306;


SELECT * FROM apps.RCV_HEADERS_INTERFACE
where shipment_num = '243909861'
order by creation_Date desc;

select pha.segment1, pra.release_num
from po_headers_all pha,
po_releases_all pra
where pha.po_header_id = pra.po_header_id
and pha.segment1 = '16179466'
and pra.release_num = 319;