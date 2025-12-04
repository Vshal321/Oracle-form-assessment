SELECT qpa.product_attr_value inventory_item_id,
       msi.segment1            Item_Number,
       spl.list_header_id     price_list_id,
       qplt.name              price_list_name,
       spll.start_date_active start_date_active,
       spll.end_date_active   end_date_active,
       spll.creation_date     creation_date,
       spll.last_update_date  last_update_date,
       spll.operand           list_price
  FROM apps.qp_list_lines         spll,
       apps.qp_pricing_attributes qpa,
       apps.qp_list_headers_b     spl,
       apps.qp_list_headers_tl    qplt,
       apps.mtl_system_items_b    msi
 WHERE     spll.list_header_id = spl.list_header_id
       AND spl.list_header_id = qplt.list_header_id
       AND spll.list_line_id = qpa.list_line_id
       AND msi.inventory_item_id = TO_CHAR (qpa.product_attr_value)
       AND qplt.language = USERENV ('lang')
       --AND qplt.name like ('USD_MPS_CDR_COST_INTERCO')
       AND qplt.list_header_id = 55651474   --55651474
       AND msi.segment1 = '4589080090'
       --AND qpa.product_attr_value = 371999
       and msi.organization_id = 16117;--:p_item