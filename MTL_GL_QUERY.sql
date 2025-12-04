SELECT   xld.source_distribution_type,
         xld.accounting_line_code,
         xld.accounting_line_type_code,
         mta.accounting_line_type,
         mta.rate_or_amount,
         xld.line_definition_code,
         xld.event_class_code,
         xld.event_type_code,
         xld.rounding_class_code,
         xld.unrounded_entered_cr,
         xld.unrounded_entered_dr,
         xld.unrounded_accounted_cr,
         xld.unrounded_accounted_dr,
         ael.gl_sl_link_id,
         ael.gl_sl_link_table,
         GJB.NAME BATCH_NAME,
         gL.period_name,
         gl.accounted_cr,
         gl.accounted_dr,
         gl.entered_cr,
         gl.entered_dr,
         gh.je_source,
         gh.je_category,
         gh.posted_date,
         mta.inv_sub_ledger_id,
         mta.base_transaction_value,
         mta.currency_conversion_rate,

         mta.currency_code,
         mmt.subinventory_code,
         TRUNC (mmt.transaction_date) transaction_date,
         mmt.transaction_quantity,
         mmt.transaction_uom,
         mmt.primary_quantity,
         mmt.actual_cost,
         mmt.source_code,
         mmt.source_line_id,
         mmt.rcv_transaction_id,
         msi.concatenated_segments item,
         gcc.concatenated_segments GL_ACCOUNT_STRING,
         ood.organization_code,
         ood.organization_name,
         mmt.transaction_id,
         ael.ae_header_id,
         ael.ae_line_num,
         gl.je_header_id,
         gl.je_line_num,
         gcc.code_combination_id,
         msi.inventory_item_id,
         msi.organization_id,
         gjb.je_batch_id
  FROM   xla_transaction_entities_upg ent,
         xla_events e,
         xla_distribution_links xld,
         mtl_transaction_accounts mta,
         mtl_material_transactions mmt,
         xla_ae_headers ah,
         xla_ae_lines ael,
         gl_import_references gir,
         gl_je_lines gl,
         gl_code_combinations_kfv gcc,
         gl_je_headers gh,
         GL_JE_BATCHES GJB,
         mtl_system_items_kfv msi,
         org_organization_definitions ood
 WHERE       mmt.transaction_id = NVL (ent.source_id_int_1, -99)
         AND ent.entity_code = 'MTL_ACCOUNTING_EVENTS'
         AND ent.application_id = 707
         AND ent.entity_id = e.entity_id
         AND e.application_id = 707
         AND e.event_id = xld.event_id
         AND ah.application_id = 707
         AND ah.entity_id = ent.entity_id
         AND ah.event_id = e.event_id
         AND ah.ledger_id = ent.ledger_id
         AND ah.ae_header_id = ael.ae_header_id
         AND ael.application_id = 707
         AND ael.ledger_id = ah.ledger_id
         AND ael.AE_HEADER_ID = xld.AE_HEADER_ID
         AND ael.AE_LINE_NUM = xld.AE_LINE_NUM
         AND xld.application_id = 707
         AND xld.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
         AND xld.source_distribution_id_num_1 = mta.inv_sub_ledger_id
         AND mta.transaction_id = mmt.transaction_id
         AND ael.gl_sl_link_id = gir.gl_sl_link_id
         AND ael.gl_sl_link_table = gir.gl_sl_link_table
         AND gir.je_header_id = gl.je_header_id
         AND gir.je_line_num = gl.je_line_num
         AND gl.code_combination_id = gcc.code_Combination_id
         AND gl.je_header_id = gh.je_header_id
         AND GH.JE_BATCH_ID = GJB.JE_BATCH_ID
         AND mta.transaction_id = mmt.transaction_id
         AND mmt.inventory_item_id = msi.inventory_item_id
         AND mmt.organization_id = msi.organization_id
         AND msi.organization_id = ood.organization_id
         and mta.transaction_id=1844835786; --1844835786 ;