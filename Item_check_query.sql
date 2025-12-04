 select customer_id ,inactive_flag,a .* from apps.mtl_customer_items a where customer_item_number in ('LFNDEU-0075Z');
--and customer_id=110711

select customer_id ,customer_item_number,inactive_flag,a .* from apps.mtl_customer_items a where customer_item_id in ('22403');
--3718051);

select inventory_item_id , a.* from apps.mtl_customer_item_xrefs a 
where customer_item_id IN (19197829);
--where inventory_item_id in (3155956)
--and customer_id=25683
--and preference_number=1;

select inventory_item_id , a.* from apps.mtl_customer_item_xrefs a where inventory_item_id IN ('21121604');

select item_type,inventory_item_status_code,inventory_item_id,segment1,organization_id,last_update_date,segment1,enabled_flag,customer_order_enabled_flag,customer_order_flag,PURCHASING_ITEM_FLAG,primary_uom_code,primary_unit_of_measure,a.*
from apps.mtl_system_items_b a 
--where segment1 like ('CR062-003-001');
where inventory_item_id in (56367904);
--and enabled_flag  = 'N'
and organization_id in (16117);


--To find ORG_ID and OUR
select * from apps.org_organization_definitions where organization_code in ('728')order by operating_unit asc;

select * from apps.org_organization_definitions where organization_id IN (31890);

---Inventory Item---
select inventory_item_status_code,a.organization_id,segment1,enabled_flag,customer_order_enabled_flag,
customer_order_flag,PURCHASING_ITEM_FLAG,primary_uom_code,primary_unit_of_measure,a.* 
from apps.mtl_system_items  a, apps.org_organization_definitions b
where a.organization_id=b.organization_id
--and INVENTORY_ITEM_ID = 19258450;
and a.segment1 IN ('1321088GT')
and b.organization_code IN (728,733);
and a.organization_id = 21417;

SELECT
    msib.segment1                       "Part Number",
    msib.inventory_item_status_code    "inventory_status",
    ood.organization_code "Org_Code"
FROM
    apps.mtl_system_items_b              msib,
    apps.org_organization_definitions    ood
WHERE
    msib.organization_id = ood.organization_id
    AND msib.segment1 IN ('1297917GT','107931GT')
    --AND msib.inventory_item_id = 16465242
    AND ood.organization_code IN ('592','735')
    order by 1;

select * from apps.PER_ALL_PEOPLE_F where person_id = 856490; --839969

SELECT
    msib.segment1                       "Part Number",
    msib.inventory_item_status_code    "592 inventory_status",
    msib1.inventory_item_status_code    "735 inventory_status"
FROM
    apps.mtl_system_items_b              msib,
    apps.mtl_system_items_b              msib1,
    apps.org_organization_definitions    ood,
    apps.org_organization_definitions    ood1
WHERE
    msib.organization_id = ood.organization_id
    AND msib.inventory_item_id = msib1.inventory_item_id
    AND msib1.organization_id = ood1.organization_id
    AND msib.segment1 IN ('1297917GT',
'107931GT')
    AND ood.organization_code = '592'
    AND ood1.organization_code = '735';
    
select *
--into l_dumm
from MTL_SECONDARY_INVENTORIES_FK_V 
where organization_id = 35270
and SECONDARY_INVENTORY_NAME = 'SEF1';

select * from apps.fnd_user
where user_id = 281412;