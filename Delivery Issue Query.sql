--To find Delivery_id from SO(Sales Order)

SELECT cust_po_number,header_id,order_number,price_list_id,org_id,order_source_id,cust_po_number,flow_status_code,ship_from_org_id,sold_to_org_id,creation_date,last_update_date,
Request_Date, Ordered_Date,Last_Updated_By,Cancelled_Flag From apps.Oe_Order_Headers_All
 Where Order_Number = '538292';
 
 select * from apps.Oe_Order_headers_all where order_number IN ('1050315970','1050316075');
 
 select line_category_code,flow_status_code,a.* from apps.oe_order_lines_all a where header_id = 13930340;
 
 select line_category_code,a.* from oe_order_lines_all a where line_id in (26085686,26085687,26085689,26085692);
 
 
 --Get Header_id from oe_order_headers_all and pass it into source_header_id 
 
Select ship_from_location_id,released_status, creation_date,last_update_date,a.* from apps.Wsh_Delivery_Details a
where source_header_id in (15660054,
15660197);
--and  source_line_id IN (30165401)-- 28201363    18108952
 
select organization_id,inventory_item_id,serial_number,requested_quantity_uom,SOLD_TO_CONTACT_ID,creation_date,last_update_date,last_updated_by,a.* from apps.wsh_delivery_details a
 where delivery_detail_id in (82899157);
 
 Select * From  apps.Wsh_Delivery_Assignments Where Delivery_Detail_Id In (82860852);
 
 Select * From  apps.Wsh_Delivery_Assignments Where Delivery_ID in (966158399); --and parent_delivery_detail_id is not null

--ASN(DSNO) Extraction
   -- Use delivery id and get pick_up_stop_id
select * from apps.wsh_delivery_legs-- where pick_up_stop_id=11396319;
where delivery_id in (966157390);
--where pick_up_stop_id=19972873;
 
 -- get pick_up_stop_id and pass as stop_id 
select * from apps.wsh_srs_trip_stops_v 
where stop_id in (62748745);
--where trip_id();

select * from apps.wsh_srs_trip_stops_v where trip_id = 57008602;

select * from apps.wsh_delivery_legs-- where pick_up_stop_id=11396319;
where pick_up_stop_id in (16560745);

 -- Look for ASN sent date.(Which is the Date the ASN sent)
Select ultimate_dropoff_location_id,initial_pickup_location_id,source_header_id,ship_method_code,number_of_lpn,name,additional_shipment_info,creation_date,last_update_date,last_updated_by,delivery_id,organization_id,Asn_Date_Sent,customer_id,waybill,A . * 
From apps.Wsh_New_Deliveries A
where delivery_id IN (971482567);
--and asn_date_sent like sysdate

--- To find the PO number for the delivery ID.
select a.cust_po_number,a.order_number,a.* from 
apps.oe_order_headers_all a 
where 
--cust_po_number=''
header_id in (    
select source_header_id  from apps.wsh_delivery_details where delivery_detail_id in (
select delivery_detail_id from apps.wsh_delivery_assignments where delivery_id in(
select delivery_id from apps.wsh_new_deliveries where delivery_id IN (73415496))));

select distinct delivery_id from apps.Wsh_Delivery_Assignments
where delivery_detail_id in 
(select delivery_detail_id from apps.Wsh_Delivery_Details where source_header_id in 
(select header_id from apps.oe_order_headers_all where cust_po_number in ('1006764867')));

--To get the Trip ID and the Stop Description for the ASN Re Extraction 
Select  apps.org_organization_definitions.operating_unit, apps.Wsh_New_Deliveries.ORGANIZATION_ID ,
apps.wsh_delivery_legs.pick_up_stop_id,apps.wsh_srs_trip_stops_v.STOP_DESCRIPTION,apps.wsh_srs_trip_stops_v.TRIP_ID From apps.Wsh_New_Deliveries ,
apps.wsh_delivery_legs,apps.wsh_srs_trip_stops_v,apps.org_organization_definitions
where apps.Wsh_New_Deliveries .delivery_id IN (Select delivery_id from apps.Wsh_New_Deliveries where delivery_id = '72736905') and
apps.Wsh_New_Deliveries.delivery_id=apps.wsh_delivery_legs.delivery_id and
apps.Wsh_New_Deliveries.organization_id=apps.org_organization_definitions.organization_id
and apps.wsh_srs_trip_stops_v.stop_id=apps.wsh_delivery_legs.PICK_UP_STOP_ID ;