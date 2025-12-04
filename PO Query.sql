--po_headers_all--
select agent_id,note_to_vendor,po_header_id, type_lookup_code ,
org_id,segment1, edi_processed_flag,vendor_id,vendor_site_id,
printed_date,print_count,bill_to_location_id,ship_to_location_id,
revision_num,closed_code,cancel_flag,approved_date,approved_flag, creation_date,last_update_date,last_updated_by,end_date,a.*
from apps.po_headers_all a
--where org_id = 11023
where segment1 in ('16058458')
--where po_header_id = 1367357
order by a.creation_date desc;

---po_headers_archive_all--
select agent_id,note_to_vendor,po_header_id, type_lookup_code ,
org_id,segment1, edi_processed_flag,vendor_id,vendor_site_id,
printed_date,print_count,bill_to_location_id,ship_to_location_id, agent_id,
revision_num,closed_code,cancel_flag,approved_date,approved_flag,creation_date,last_update_date,last_updated_by,wf_item_key,a.*
from apps.po_headers_archive_all a
where segment1 in ('10178888');

-- PO Lines All--
select cancel_flag,note_to_vendor,vendor_product_num,last_update_date,last_updated_by,closed_code,closed_by,a.* 
from apps.po_lines_all a
where po_header_id in (1367357)
--and item_id = 16585678;
and po_line_id IN (4498416);

--PO Lines Locations---
select ship_via_lookup_code,freight_terms_lookup_code,ship_to_organization_id,drop_ship_flag,attribute6,NEED_BY_DATE,a.* from apps.po_line_locations_all a
where po_header_id in (1367357)
--and po_line_id = 11277650;
--where line_location_id IN (32752801, 32747203);
and po_release_id IN (23059024);

--PO Releases--
select closed_code,wf_item_type,wf_item_key,edi_processed_flag,a.* 
from apps.po_releases_all a 
where po_header_id in (1367357)
and po_release_id IN (23059024);
and release_num IN (828);

--PO Release Arch---
select wf_item_type,wf_item_key,closed_code,edi_processed_flag,revision_num,a.* 
from apps.po_releases_archive_all a
where po_header_id in (1367357)
and po_release_id IN (23059024);
and release_num IN (108);


--Drop Ship Check--
select * from apps.OE_DROP_SHIP_SOURCES
--where header_id = 15463790;
where po_release_id IN (22905227);
where REQUISITION_HEADER_ID = 16646442;


select * from apps.po_requisition_headers_all
--where segment1 = '100032'
order by creation_Date desc;

select * from apps.po_requisition_lines_all
where REQUISITION_HEADER_ID = 16913304;


select * from apps.fnd_user
--where user_id = 63629;
where employee_id = 48443;

select * from apps.po_agents
where agent_id IN (48443);

select * From apps.per_people_f
where person_id IN (48443);

select revision_num,a.* from apps.po_headers_all a
where segment1 in ('10175529');

select revision_num,a.* from apps.po_headers_archive_all a
where segment1 in ('10175529');


select a.segment1, a.po_header_id , a.revision_num, b.revision_num
from po_headers_all a, po_headers_archive_all b
where a.po_header_id = b.po_header_id
--AND a.revision_num = b.revision_num
and a.segment1 in ('10175529');