SELECT msi.segment1 "ITEM_NAME",
  msi.inventory_item_id,
  cic.item_cost ,
  mp.organization_code,
  mp.organization_id,
  cct.cost_type,
  cct.description,
  cic.tl_material,
  cic.tl_material_overhead,
  cic.material_cost,
  cic.material_overhead_cost,
  cic.tl_item_cost,
  cic.unburdened_cost,
  cic.burden_cost
FROM apps.cst_cost_types cct,
  apps.cst_item_costs cic,
  apps.mtl_system_items_b msi,
  apps.mtl_parameters mp
WHERE cct.cost_type_id    = cic.cost_type_id
AND cic.inventory_item_id = msi.inventory_item_id
AND cic.organization_id   = msi.organization_id
AND msi.organization_id   = mp.organization_id
AND msi.segment1          = '1305894GT'
AND mp.organization_code  = 750;
AND cct.cost_type         = 'Frozen';