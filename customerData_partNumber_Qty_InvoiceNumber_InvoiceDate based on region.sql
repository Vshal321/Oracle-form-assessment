select 
distinct
    hp.party_name       "SHIP_TO_CUSTOMER",
    rcta.trx_number     "INVOICE_NUMBER",
    hca.account_number  "CUSTOMER_ACCOUNT_NUMBER",
    hl.address1         "SHIP_TO_ADDRESS1",
    hl.address2         "SHIP_TO_ADDRESS2",
    hl.address3         "SHIP_TO_ADDRESS3",
    hl.address4         "SHIP_TO_ADDRESS4",
    hl.city             "SHIP_TO_CITY",
    hl.state            "SHIP_TO_STATE",
    ooh.order_number,
    ool.line_id,
    msib.segment1,
    msib.description,
    (ool.ordered_quantity * ool.unit_selling_price) "LINE_TOTAL_USD",
    rctla.EXTENDED_AMOUNT "INVOICED_AMOUNT_USD",
    rcta.trx_date "INVOICE_DATE",
    rcta.trx_number "INVOICE_NUMBER" 
from
apps.hz_cust_acct_sites_all         hcasa,
apps.hz_cust_site_uses_all          hcsua,
apps.hz_cust_accounts_all           hca,
apps.hz_party_sites                 hps,
apps.hz_parties                     hp,
apps.hz_locations                   hl,
apps.oe_order_headers_all           ooh,
apps.oe_order_lines_all             ool,
apps.mtl_system_items_b             msib,
apps.RA_CUSTOMER_trx_all            rcta,
apps.RA_CUSTOMER_TRX_LINES_ALL      rctla,
apps.org_organization_definitions   ood
where 1 = 1
AND hcasa.cust_account_id = hca.cust_account_id
AND hcasa.cust_acct_site_id = hcsua.cust_acct_site_id
AND hcasa.party_site_id = hps.party_site_id
AND hp.party_id = hps.party_id
AND hps.location_id = hl.location_id
AND hcsua.site_use_code = 'SHIP_TO'
and hcsua.site_use_id = ooh.SHIP_TO_ORG_ID
AND hca.cust_account_id= ooh.SOLD_TO_ORG_ID
and msib.inventory_item_id = ool.inventory_item_id
and rcta.INTERFACE_HEADER_ATTRIBUTE1 = to_char(ooh.order_number)
and rcta.customer_trx_id = rctla.customer_trx_id
and rctla.INTERFACE_LINE_ATTRIBUTE6 = to_char(ool.line_id)
and ool.header_id = ooh.header_id
and msib.organization_id = ood.organization_id
and ooh.org_id = ood.operating_unit
and ood.organization_code in (728,733,592)--Enter organization
and  rcta.trx_date BETWEEN TO_DATE ('2022/02/01', 'yyyy/mm/dd') -- Enter date range 
AND TO_DATE ('2022/03/01', 'yyyy/mm/dd');