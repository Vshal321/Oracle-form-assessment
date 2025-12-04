select distinct rcta.trx_number,  hl.location_id, rcrla.customer_trx_line_id, rcrla.customer_trx_id, rcta.customer_trx_id,ood.organization_id,c1.cust_account_id,c1.cust_acct_site_id
from
ra_customer_trx_all rcta,
                  hz_cust_accounts_all bhca,      --Table changed from hz_cust_accounts to hz_cust_accounts_all~ for place of supply changes
                  ra_cust_trx_types_all rctta,
                  hz_parties bhp,
                  ra_customer_trx_lines_all rcrla,
                  hz_cust_site_uses_all bhcsua,
                  hr_locations hl,
                  hr_organization_units_v hou,
                  hz_cust_acct_sites_all bhcasa,
                  hz_locations bhl,   
                  hz_party_sites bhps,
                  /*added new start~Place of supply changes*/
                  hz_cust_site_uses_all b1,
                  hz_cust_acct_sites_all c1,
                  hz_locations hl1,
                  hz_party_sites hps1,
                  org_organization_definitions ood,
                  jai_party_regs_v jihou
               --   jai_tax_lines_v jrct
                    WHERE                                                                      --rcta.customer_trx_id     = apsa.customer_trx_id AND
                 rcrla.customer_trx_id = rcta.customer_trx_id
              AND rcta.org_id = rctta.org_id
              AND rcta.org_id = rcrla.org_id
              AND rcrla.line_type = 'LINE'
              AND rcta.cust_trx_type_id = rctta.cust_trx_type_id
              AND rcta.ship_to_site_use_id = bhcsua.site_use_id(+)
              -- AND bhcsua.site_use_code(+) = 'SHIP_TO' --Commented for place of supply changes
              AND bhcsua.cust_acct_site_id = bhcasa.cust_acct_site_id(+)
              AND bhcasa.party_site_id = bhps.party_site_id(+)
              AND bhps.location_id = bhl.location_id(+)
              /*added new start~Place of supply changes*/
              AND rcta.bill_to_site_use_id = b1.site_use_id
              AND b1.cust_acct_site_id = c1.cust_acct_site_id
              AND c1.party_site_id = hps1.party_site_id
              AND hps1.location_id = hl1.location_id
              AND rcta.Interface_Header_Attribute10 = ood.organization_id      --Added by Vignesh for INC0968787 - Performance Issue
              --AND hou.location_id = hl.location_id  
              /*added new end~Place of supply changes*/
              AND hps1.party_id = bhp.party_id(+)
              AND c1.cust_account_id = bhca.cust_account_id(+)
              AND hl.location_id(+) = jihou.party_site_id
              AND jihou.party_id = ood.organization_id
              --AND NVL (jrct.location_id, 186614) = jihou.party_site_id
               --AND rcta.customer_trx_id = jrct.trx_id (+)
               --AND rcrla.customer_trx_line_id = jrct.trx_line_id (+)
               ---AND rcrla.customer_trx_id = jrct.trx_id (+)
               AND trunc(rcta.creation_date) >= '14-AUG-2018'  --Added by Ashok Avala to fetch the records after 14-AUG-2018
              --AND rcta.trx_date BETWEEN (l_from_date) AND (l_to_date)
              AND hl.loc_information16 = 'Tamil Nadu' --p_state
               AND rcta.org_id = 8222 
              AND RCTA.TRX_NUMBER = '103819';