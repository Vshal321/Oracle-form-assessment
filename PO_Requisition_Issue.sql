

select * from apps.po_requisitions_interface_all
where item_id = 19158509;
where requisition_line_id IN (32845304,
32845139,
32845371,
32845443,
32845131,
32845176);

select * From apps.PO_INTERFACE_ERRORS
where INTERFACE_TRANSACTION_ID IN (22162187);
22564379,
22564228,
22564446,
22564518,
22564265);

select pria.ITEM_ID,pria.ITEM_SEGMENT1,pria.SOURCE_ORGANIZATION_ID,pria.SOURCE_ORGANIZATION_CODE,pria.DESTINATION_ORGANIZATION_ID,pria.DESTINATION_ORGANIZATION_CODE,pria.ITEM_DESCRIPTION,pie.ERROR_MESSAGE
from apps.po_requisitions_interface_all pria, apps.PO_INTERFACE_ERRORS pie
where pria.TRANSACTION_ID = pie.INTERFACE_TRANSACTION_ID
and requisition_line_id IN (32845304,
32845139,
32845371,
32845443,
32845131,
32845176);

select * from apps.po_requisition_lines_all;
where requisition_line_id = '32845304';



select * from apps.TREX_REQ_IMPORT_STG
--where item_id = 415217;
order by creation_date desc;