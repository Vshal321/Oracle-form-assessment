SELECT distinct rcta.status_trx status_trx,
                  rcta.trx_number inv_trx_number,
                  ood.organization_id,
                  hl.location_id,
                  rcta.trx_date inv_trx_date,
                  rcta.org_id org_id,
                  rcta.bill_to_customer_id sold_to_customer_id,
                  bhp.party_name ship_to_cust_name,
                  bhcsua.location ship_to_cust_location,
                  bhca.account_number ship_to_cust_number,
                  rcta.customer_trx_id customer_trx_id,
                  -- apsa.gl_date                   c_gl_date,
                  rcta.trx_date c_gl_date,
                  -- apsa.class                     inv_class,
                  rcta.invoice_currency_code invoice_currency_code,
                  rcta.exchange_date exchange_date,
                  rcta.exchange_rate_type exchange_rate_type,
                  rcta.exchange_rate txn_hdr_exchange_rate,
                    --  NVL (jrct.total_amount, 0) total_amount,  Commented by Ashok Avala for R12UPG-GST Changes
                  (select nvl(sum(extended_amount),0)
                 from ra_customer_trx_lines_all
                 where customer_trx_id=rcta.customer_trx_id
                 ) total_amount,    --Added by Ashok Avala for R12UPG-GST Changes
                      /*     (SELECT NVL (SUM (jrtt.tax_amount), 0)
                     FROM  jai_ar_trx_lines jrtl,                    --Added by Babu for R12UPG-India Localization Reports
					       --apps.ja_in_ra_customer_trx_lines jrtl,  Commented by Babu for R12UPG-India Localization Reports
					 --ja_in_ra_cust_trx_tax_lines jrtt,             Commented by Babu for R12UPG-India Localization Reports
					 jai_ar_trx_tax_lines jrtt,                      --Added by Babu for R12UPG-India Localization Reports
					 --ja_in_tax_codes jtc                           Commented by Babu for R12UPG-India Localization Reports
					 jai_cmn_taxes_all jtc                          --Added by Babu for R12UPG-India Localization Reports
                    WHERE jrtl.customer_trx_id = jrct.trx_id
                      AND jrtt.link_to_cust_trx_line_id = jrtl.customer_trx_line_id
                      AND jtc.tax_id = jrtt.tax_id
                      AND jtc.tax_type IN ('IGST', 'CGST', 'SGST', 'GST CESS'))
                     func_tax_amount,*/
					   (SELECT NVL (SUM (jrtl.rounded_tax_amt_fun_curr), 0)
                     FROM  jai_tax_lines_v jrtl
                    WHERE jrtl.trx_line_id= rcrla.customer_trx_line_id
					 AND jrtl.TRX_ID = rcrla.customer_trx_id   -----------------Added by Sathiyavathy N for INC0602807
                      AND jrtl.tax_type_code IN ('IGST', 'CGST', 'SGST', 'GST CESS'))
                     func_tax_amount,   --Added by Ashok Avala for R12UPG-GST Changes
                  --  jrct.line_amount inv_item_amount,
                  ROUND (NVL (rcta.exchange_rate, 1) * jrct.line_amt, 2) inv_item_amount,
                  rcrla.customer_trx_line_id customer_trx_line_id,
                   -- jinrcttl.total_amount line_tot_amount,  Commented by Ashok Avala for R12UPG-GST Changes
                 (select nvl(sum(extended_amount),0)
                 from ra_customer_trx_lines_all
                 where customer_trx_id=rcta.customer_trx_id
                 AND line_type = 'LINE') line_tot_amount,   --Added by Ashok Avala for R12UPG-GST Changes
                  rcrla.extended_amount line_item_trxn_curr_amount,
                   --jinrcttl.inventory_item_id inventory_item_id,  Commented by Ashok Avala for R12UPG-GST Changes
                 rcrla.inventory_item_id inventory_item_id,     --Added by Ashok Avala for R12UPG-GST Changes
                  rcta.batch_source_id batch_source_id,
                  --jihou.organization_id organization_id,  Commented by Ashok Avala for R12UPG-GST Changes
                  jihou.party_id organization_id,  --Added by Ashok Avala for R12UPG-GST Changes
                  rctta.TYPE inv_class,
                  rcta.interface_header_attribute10,
                  rcta.purchase_order purchase_order,
                  rcta.ship_to_site_use_id ship_to_site_use_id,
                    --  jihou.cst_reg_no cst_reg_no,  Commented by Ashok Avala for R12UPG-GST Changes
             /*jprl.registration_number*/ (select jprl.registration_number
					from jai_party_regs_v jpr,
						 jai_party_reg_lines_v jprl,
                         hr_organization_units_v hou
					where jpr.party_reg_id = jprl.party_reg_id
					AND party_id = hou.organization_id
					AND party_site_id = hl.location_id
                    AND hou.location_id = hl.location_id
					AND (jprl.EFFECTIVE_TO IS NULL OR jprl.EFFECTIVE_TO > SYSDATE)
					AND jprl.regime_code ='GST')cst_reg_no,  --Added by Ashok Avala for R12UPG-GST Changes
               --   TRIM (UPPER (jihou.st_reg_no)) ship_from_terex_gstin,  Commented by Ashok Avala for R12UPG-GST Changes
             /*jprl.registration_number*/ (select jprl.registration_number
					from jai_party_regs_v jpr,
						 jai_party_reg_lines_v jprl,
                         hr_organization_units_v hou
					where jpr.party_reg_id = jprl.party_reg_id
					AND party_id = hou.organization_id
					AND party_site_id = hl.location_id
                    AND hou.location_id = hl.location_id
					AND (jprl.EFFECTIVE_TO IS NULL OR jprl.EFFECTIVE_TO > SYSDATE)
					AND jprl.regime_code ='GST')ship_from_terex_gstin,   --Added by Ashok Avala for R12UPG-GST Changes
                  --jihou.location_id ship_from_location_id,  Commented by Ashok Avala for R12UPG-GST Changes
                   jihou.party_site_id ship_from_location_id,  --Added by Ashok Avala for R12UPG-GST Changes
                  hl.location_code ship_from_loc_code,
                  --  ood.organization_name ship_from_org_code,           --Commented As Part of Revised GSTR1 Format on 30-Jun-2017, By Infosys
                  ood.organization_code ship_from_org_code,               --Added As Part of Revised GSTR1 Format on 30-Jun-2017, By Infosys
                  ood.organization_id ship_from_org_id,
                  hl.loc_information16 ship_from_loc_state,
                  bhl.state ship_to_cust_state,
                  hl1.state bill_to_cust_state,                                                    --added newly for place of supply changes
                  b1.location bill_to_cust_location,                                               --added newly for place of supply changes
                  NVL (bhl.country, 'IN') ship_to_cust_country_code,
                  (SELECT territory_short_name
                     FROM fnd_territories_tl ftt
                    WHERE ftt.territory_code = NVL (bhl.country, 'IN')
                      AND language = 'US')
                     ship_to_cust_country,
                  NVL (hl1.country, 'IN') bill_to_cust_country_code,
                  (SELECT territory_short_name
                     FROM fnd_territories_tl ftt
                    WHERE ftt.territory_code = NVL (hl1.country, 'IN')
                      AND language = 'US')
                     bill_to_cust_country,
                  rcrla.interface_line_attribute1 c_so_number,                                                                   --so number
                  rcrla.interface_line_attribute3 c_delivery_id,                                                           --delivery number
                  rcrla.interface_line_attribute6 c_so_line_id,
                  rcta.previous_customer_trx_id,
                  rcta.related_customer_trx_id,
                   /*(SELECT TRIM (UPPER (st_reg_no))
                     FROM jai_cmn_cus_addresses                          --Added by Babu for R12UPG-India Localization Reports
					      --ja_in_customer_addresses                       Commented by Babu for R12UPG-India Localization Reports
                    WHERE customer_id = c1.cust_account_id               /*table changed from 'bhcasa' to 'c1' for~Place of supply changes*/
                     /* AND address_id = c1.cust_acct_site_id)
                     ship_to_cust_gstin_no,*/   --Commented by Ashok Avala for R12UPG-GST Changes
                  (select jprl.registration_number
					from jai_party_regs_v jpr,
						 jai_party_reg_lines_v jprl
					where jpr.party_reg_id = jprl.party_reg_id
					AND party_id = c1.cust_account_id
					AND party_site_id = c1.cust_acct_site_id
					AND site_flag = 'Y'
					AND (jprl.EFFECTIVE_TO IS NULL OR jprl.EFFECTIVE_TO > SYSDATE)
					AND jprl.regime_code ='GST'
                    AND rownum = 1 --Added by Ashok Avala to fix the duplicate issues
					) ship_to_cust_gstin_no,    --Added by Ashok Avala for R12UPG-GST Changes
				--	NULL ship_to_cust_gstin_no,
                  (SELECT trx_number
                     FROM ra_customer_trx_all rcta1
                    WHERE rcta1.customer_trx_id = NVL (rcta.previous_customer_trx_id, rcta.related_customer_trx_id))
                     original_invoice_number,
                  (SELECT trx_date
                     FROM ra_customer_trx_all rcta2
                    WHERE rcta2.customer_trx_id = NVL (rcta.previous_customer_trx_id, rcta.related_customer_trx_id))
                     original_invoice_date,
                  rctta.name trx_type_name,
                 ROUND (NVL (rcta.exchange_rate, 1) * rcrla.extended_amount, 2) line_item_amount,
                    -- ROUND (NVL (rcta.exchange_rate, 1) * jrct.line_amt, 2) line_item_amount,
                  (SELECT name
                     FROM apps.ra_batch_sources_all rbsa
                    WHERE rbsa.org_id = rcta.org_id
                      AND rbsa.batch_source_id = rcta.batch_source_id
                      AND ROWNUM = 1)
                     transaction_source,
                  rcta.ct_reference order_header_reference,
                  -- DECODE (jinrcttl.quantity, 0, 1, jinrcttl.quantity) quantity, --Added Quantity ~As Part of Revised GSTR1 Format on 30-Jun-2017, By Infosys
                 DECODE (rcrla.quantity_ordered, 0, 1, rcrla.quantity_ordered) quantity,   --Added by Ashok Avala for R12UPG-GST Changes
           --       NVL (jinrcttl.unit_code, 'EA') unit_code,    --Added unit_code ~As Part of Revised GSTR1 Format on 30-Jun-2017, By Infosys
                 NVL (rcrla.uom_code, 'EA') unit_code,     --Added by Ashok Avala for R12UPG-GST Changes
                  jrct.organization_id inv_org_id
             FROM ra_customer_trx_all rcta,
                  hz_cust_accounts_all bhca,      --Table changed from hz_cust_accounts to hz_cust_accounts_all~ for place of supply changes
                  ra_cust_trx_types_all rctta,
                  hz_parties bhp,
                  ra_customer_trx_lines_all rcrla,
                 --ja_in_hr_organization_units jihou,
				  --jai_cmn_inventory_orgs jihou,
				  jai_party_regs_v jihou,
				--ja_in_ra_customer_trx jrct,
				--jai_ar_trxs jrct,
				  jai_tax_lines_v jrct,
				   --jai_party_reg_lines_v jprl,
                  --ja_in_ra_customer_trx_lines jinrcttl,
				--  jai_ar_trx_lines  jinrcttl,
                  hr_locations hl,
                  hr_organization_units_v hou,
                  org_organization_definitions ood,
                  hz_cust_site_uses_all bhcsua,
                  hz_cust_acct_sites_all bhcasa,
                  hz_locations bhl,
                  hz_party_sites bhps,
                  /*added new start~Place of supply changes*/
                  hz_cust_site_uses_all b1,
                  hz_cust_acct_sites_all c1,
                  hz_locations hl1,
                  hz_party_sites hps1
            /*added new end~Place of supply changes*/
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
              /*added new end~Place of supply changes*/
              AND hps1.party_id = bhp.party_id(+)
              AND c1.cust_account_id = bhca.cust_account_id(+)
              -- and rcta.interface_header_attribute10=jihou.organization_id
               --AND NVL (jrct.location_id, 186614) = jihou.location_id --  IN-SP-Hosur 186614 assumed to be default in case org-location is not entered in AR
              AND NVL (jrct.location_id, 186614) = jihou.party_site_id  --Added by Ashok Avala as per R12UPG-GST Changes
                  AND rcta.customer_trx_id = jrct.trx_id (+) --Added outer join by Ashok avala on 18-May-2018 as per R12UPG-GST Changes
            --    AND jinrcttl.customer_trx_id = jrct.trx_id
              --AND jinrcttl.customer_trx_id = rcta.customer_trx_id
              AND hl.location_id = jihou.party_site_id
              --AND hl.location_id = jihou.location_id
              AND rcrla.customer_trx_line_id = jrct.trx_line_id (+) --Added outer join by Ashok avala on 18-May-2018 as per R12UPG-GST Changes
              AND rcrla.customer_trx_id = jrct.trx_id (+)  --Added outer join by Ashok avala on 18-May-2018 as per R12UPG-GST Changes
            --  AND jihou.organization_id = ood.organization_id
--              AND jihou.party_id = ood.organization_id
              /*and jihou.party_reg_id=jprl.party_reg_id
			  AND (jprl.EFFECTIVE_TO IS NULL OR jprl.EFFECTIVE_TO > SYSDATE)
			  AND jprl.regime_code ='GST' */
              AND rcta.Interface_Header_Attribute10 = hou.organization_id
              AND hou.location_id = hl.location_id
              AND hou.organization_id = ood.organization_id
			  AND trunc(rcta.creation_date) >= '14-AUG-2018'  --Added by Ashok Avala to fetch the records after 14-AUG-2018
              --AND rcta.trx_date BETWEEN sysdate-10 AND sysdate
              AND hl.loc_information16 = 'Tamil Nadu'
              AND rcta.org_id = 8222 --p_org_id
              AND RCTA.TRX_NUMBER = '103782'
              --AND ROWNUM <=10
         ORDER BY rcta.trx_number, rcta.trx_date;