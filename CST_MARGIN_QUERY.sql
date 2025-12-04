SELECT  tsm.inventory_item_id,
        tsm.ship_from_org_id,
  tsm.trx_source_line_id,
  tsm.organization_code,
  tsm.subinventory,
  tsm.transaction_number,
  tsm.transaction_date,
  tsm.transaction_type,
  tsm.credit_reason,
  tsm.salesperson,
  tsm.customer,
  tsm.serial_number,
  tsm.order_number,
  tsm.incoterm,
  tsm.order_type,
  tsm.item_number,
  tsm.item_description,
  tsm.product_category,
  tsm.country,
  tsm.payment_terms,
  DECODE(tsm.sales_value,0,DECODE(tsm.model,NULL,'Y','N'),'Y') filter_column,
  DECODE(tsm.invoice_type,'INV',NVL((SELECT --YS IM138051 split lines should use ship quantity SUM(cms.order_line_quantity)
SUM(cms.ship_quantity)
              FROM
              cst_margin_summary cms
              WHERE 1=1
              AND cms.header_id=tsm.header_id
              AND cms.parent_rowid=tsm.parent_rowid),
            (SELECT NVL(ool.invoiced_quantity,0)
             FROM
             oe_order_lines_all ool         
             WHERE 1=1
             AND ool.line_id=tsm.trx_source_line_id)),
         'CM',tsm.quantity) quantity,
  tsm.currency,
  tsm.list_sales_value,
  tsm.sales_value,
  tsm.pc_discount_from_list,
  tsm.cost_of_sales,
  tsm.margin,
  tsm.exchange_rate,
  tsm.accounted_sales_value,
  tsm.accounted_cost_of_sales,
  tsm.accounted_margin,
  tsm.pc_accounted_margin,
  tsm.model,
  usd_conversion_rate, --Added by Vikas Agarwal via IM154153
  sales_value_in_usd, --Added by Vikas Agarwal via IM154153
  operating_unit_name, --Added by Vikas Agarwal via IM154153
  tsm.sales_account--Added sales_account for INC0182273 by HariPrasand Arumugam
  ,tsm.transaction_id --Added by Naveen
,tsm.cust_po_number
,nvl(TREX_GST_FETCH_VALUES_PKG.TREX_FETCH_TAX_INV_NUM(tsm.customer_trx_id,NULL),TREX_GST_FETCH_VALUES_PKG.TREX_FETCH_TAX_INV_NUM(tsm.delivery_id,'D'))TAX_INVOICE_NUMBER
  FROM
  trex_sales_margin_disc_rp_v tsm
  WHERE 1=1;
  
  
SELECT --YS IM138051 split lines should use ship quantity SUM(cms.order_line_quantity)
                                        cms.ship_quantity,cms.ORDER_LINE_QUANTITY,cms.INVOICE_LINE_QUANTITY,cms.INVOICE_QUANTITY, cms.*
                                          FROM
                                          apps.cst_margin_summary cms
                                          WHERE 1=1
                                          AND cms.header_id= 15332973-- having qty 0
                                          AND cms.parent_rowid = 'AACKbkABtAAHFj5AAN';
                                          
                                          -- good case --
SELECT --YS IM138051 split lines should use ship quantity SUM(cms.order_line_quantity)
                                        cms.ship_quantity,cms.ORDER_LINE_QUANTITY,cms.INVOICE_LINE_QUANTITY,cms.INVOICE_QUANTITY, cms.*
                                          FROM
                                          apps.cst_margin_summary cms
                                          WHERE 1=1
                                          AND cms.header_id= 13504785 -- good case with qty
                                          AND cms.parent_rowid = 'AACKbkABPAAGkBSAAM';