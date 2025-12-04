--po_or_trf_unit_price--
select ABS (rate_or_amount),accounting_line_type,a.* From apps.mtl_transaction_accounts a
where transaction_id = 1844835786
and accounting_line_type IN (5,9,2,16,31)
and organization_id = 12654;

select  base_transaction_value, rate_or_amount, (SIGN (base_transaction_value)* ABS (rate_or_amount)) ppv_per_unit,accounting_line_type,organization_id,reference_account,a.* From mtl_transaction_accounts a
where transaction_id = 1851696188
--and accounting_line_type IN (5,2, 16, 31)
and organization_id = 12654;
and reference_account = 259337;

select * From gl_code_combinations_kfv
where code_combination_id = 259337;


---transaction_unit_cost---
SELECT ABS (rate_or_amount)
                        FROM mtl_transaction_accounts
                       WHERE     accounting_line_type = 14
                             AND transaction_id = 1844835785 --mta.transaction_id
                             AND organization_id = 12654; --mta.organization_id

select SIGN (base_transaction_value) * ABS (rate_or_amount) from mtl_transaction_accounts
where transaction_id = 1844835785
AND organization_id = 12654;

select rcv_transaction_id,primary_quantity,organization_id,a.* From mtl_material_transactions a
where transaction_id = 1844835786;

select * from rcv_transactions
where transaction_id = 1844835786;

select * from gl_code_combinations_kfv
where code_combination_id = 259333;

select * from apps.po_requisition_headers_all
where segment1 = '249531';

select * from po_requisition_lines_all
where requisition_header_id = 16943291;

select * from rcv_transactions
where requisition_line_id = 33253872;

select distribution_account_id,a.* From mtl_material_transactions
where source_line_id = 156931252;

select decode(transaction_id,1844521958,'SubInventory',1844835786,'Internal') Transaction_Type, costed_flag,distribution_account_id,a.* 
From apps.mtl_material_transactions a
where transaction_id IN (1844521958,1844835786);

SELECT                                                                                                                                      b.inventory_item_id,b.segment1,c.organization_code,
 x.usage_rate_or_amount cost,d.cost_type,a.based_on_rollup_flag,a.inventory_asset_flag, 
        y.cost_element,z.resource_code,
     (select meaning
         from  mfg_lookups lu
         where lu.lookup_type = 'cst_basis'
   and   lu.lookup_code = basis_type) basis
 FROM apps.cst_cost_types d, 
      apps.cst_item_costs a, 
   apps.cst_item_cost_details x,
      apps.mtl_system_items_b b, 
      apps.org_organization_definitions c ,
   cst_cost_elements y,
   bom_resources z
 WHERE y.cost_element_id   = x.cost_element_id
 and   z.resource_id       = x.resource_id
 and   x.organization_id   = a.organization_id 
 and   x.inventory_item_id = a.inventory_item_id 
 and   x.cost_type_id      = a.cost_type_id 
 and   c.organization_id   = b.organization_id 
 and   c.organization_id   = a.organization_id 
 and   b.inventory_item_id = a.inventory_item_id 
 and   d.cost_type_id      = a.cost_type_id 
 --and   d.cost_type         = :p_cost_type -- can be taken as Frozen or Pending as needed
 and   a.organization_id = 10923 --:p_organization_id;
 and   b.inventory_item_id = 20530671;
 
 select decode(transaction_id,1844521958,'SubInventory',1844835786,'Internal') Transaction_Type, distribution_account_id,a.* From apps.mtl_material_transactions a
where transaction_id IN (1844521958,1844835786);