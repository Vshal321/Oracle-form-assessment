WITH sales24mo AS 
  (SELECT aps.org_id , 
    aps.customer_id , 
    aps.customer_site_use_id , 
    csu.cust_acct_site_id , 
    SUM(aps.amount_due_original) AS sales24mo
  FROM apps.AR_PAYMENT_SCHEDULES_ALL aps , 
    apps.hz_cust_site_uses_all csu
  WHERE 1                      =1 
  AND aps.customer_site_use_id = csu.site_use_id 
  AND aps.org_id              IN (124,122,14966,2943, 6123, 10903, 10905, 13314, 14474, 15786, 17681, 27530, 27550, 28570,11023, 32990, 30210, 32410, 32411, 31390, 28331, 29590, 28332, 35231) 
  AND aps.class                = 'INV' 
  AND TRUNC(aps.trx_date)     >=TRUNC(sysdate-749) 
  GROUP BY aps.org_id , 
    aps.customer_id , 
    aps.customer_site_use_id , 
    csu.cust_acct_site_id 
  ), 
   sales12mo AS 
  (SELECT aps.org_id , 
    aps.customer_id , 
    aps.customer_site_use_id , 
    csu.cust_acct_site_id , 
    SUM(aps.amount_due_original) AS sales12mo
  FROM apps.AR_PAYMENT_SCHEDULES_ALL aps , 
    apps.hz_cust_site_uses_all csu
  WHERE 1                      =1 
  AND aps.customer_site_use_id = csu.site_use_id 
  AND aps.org_id              IN (124,122,14966,2943, 6123, 10903, 10905, 13314, 14474, 15786, 17681, 27530, 27550, 28570,11023, 32990, 30210, 32410, 32411, 31390, 28331, 29590, 28332, 35231) 
  AND aps.class                = 'INV' 
  AND TRUNC(aps.trx_date)     >=TRUNC(sysdate-365) 
  GROUP BY aps.org_id , 
    aps.customer_id , 
    aps.customer_site_use_id , 
    csu.cust_acct_site_id 
  )
SELECT DISTINCT 
  f.party_number               AS "Party Number", 
  f.party_name                 AS "Customer Name", 
  a.account_number             AS "Account Number", 
  h.address_lines_phonetic     AS "Alternate Name", 
  f.tax_reference              AS "Tax Registration Number", 
  a.account_name               AS "Account Name", 
  h.country                    AS "Country Code", 
  ter.territory_short_name     AS "Country", 
  g.party_site_number          AS "Site Number", 
  h.address1                   AS "Address1", 
  h.address2                   AS "Address2", 
  h.address3                   AS "Address3", 
  h.address4                   AS "Address4", 
  h.city                       AS "City", 
  h.state                      AS "State", 
  h.postal_code                AS "Postal Code", 
  h.province                   AS "Province", 
  h.county                     AS "County", 
  /* 06/21/2016: added sales currency */ 
  b.attribute20              AS "Sales Currency", 
  g.IDENTIFYING_ADDRESS_FLAG AS "Identifying Address", 
  b.attribute1               AS "Pricing Category", 
  d.site_use_code            AS "Site Usage", 
  d.location                 AS "Location Number", 
  d.primary_flag             AS "Primary Site", 
  d.orig_system_reference    AS "Reference", 
  CASE 
    WHEN d.freight_term = 'CIF' 
    THEN 'Cost, Insurance, Freight' 
    WHEN d.freight_term = 'CIP' 
    THEN 'CIP Carriage and Insurance Paid To' 
    WHEN d.freight_term = 'CFR' 
    THEN 'Cost and Freight' 
    WHEN d.freight_term = 'CPT' 
    THEN 'Carriage paid to' 
    WHEN d.freight_term = 'DAF' 
    THEN 'Delivery at frontier' 
    WHEN d.freight_term = 'DDP' 
    THEN 'Delivered duty paid' 
    WHEN d.freight_term = 'DDU' 
    THEN 'Delivered duty unpaid' 
    WHEN d.freight_term = 'DEQ' 
    THEN 'Delivered ex quay' 
    WHEN d.freight_term = 'DES' 
    THEN 'Delivered ex ship' 
    WHEN d.freight_term = 'EXW' 
    THEN 'ex works' 
    WHEN d.freight_term = 'FAS' 
    THEN 'Free alongside ship' 
    WHEN d.freight_term = 'FCA' 
    THEN 'Free carrier' 
    WHEN d.freight_term = 'FOB' 
    THEN 'Free on board' 
    ELSE NULL 
  END     AS "Freight Terms", 
  pc.name AS "Profile Class", 
  ac.name AS "Collector", 
  i.name  AS "Payment Terms", 
  c.credit_checking                                                        AS "Credit Check", 
  c.credit_hold                                                            AS "Credit Hold", 
  e.currency_code                                                          AS "Currency Code", 
  e.overall_credit_limit                                                   AS "Credit Limit", 
  e.trx_credit_limit                                                       AS "Order Limit", 
  e.last_update_date                                                       AS "Last Credit Limit Update", 
  usr.user_name                                                            AS "Last Updated By", 
  e.min_statement_amount                                                   AS "Min. Statement Amt.", 
  DECODE (d.site_use_code, 'BILL_TO', sales24mo.sales24mo, 'SHIP_TO',NULL) AS "24 Month Gross Sales", 
  DECODE (d.site_use_code, 'BILL_TO', sales12mo.sales12mo, 'SHIP_TO',NULL) AS "12 Month Gross Sales", 
  (SELECT NAME FROM apps.HR_OPERATING_UNITS WHERE organization_id=b.org_id 
  ) AS "Entity" 
FROM apps.hz_cust_accounts_all a , 
  apps.hz_cust_acct_sites_all b , 
  apps.HZ_CUSTOMER_PROFILES c , 
  apps.hz_cust_site_uses_all d , 
  apps.HZ_CUST_PROFILE_AMTS e , 
  apps.hz_parties f, 
  apps.HZ_PARTY_SITES g , 
  apps.HZ_LOCATIONS h,
  apps.fnd_territories_vl ter,
  apps.ra_terms_tl i, 
  apps.hz_cust_profile_classes pc , 
  apps.ar_collectors ac , 
  apps.fnd_user usr , 
  apps.sales24mo,
  apps.sales12mo
WHERE a.cust_account_id       = b.cust_account_id 
AND b.cust_acct_site_id       = d.cust_acct_site_id 
AND (d.site_use_code          ='BILL_TO') 
AND c.cust_account_profile_id = e.cust_account_profile_id(+) 
AND b.org_id                 IN (124,122,14966,2943, 6123, 10903, 10905, 13314, 14474, 15786, 17681, 27530, 27550, 28570,11023, 32990, 30210, 32410, 32411, 31390, 28331, 29590, 28332, 35231) 
AND d.site_use_id             =c.site_use_id (+) 
AND b.PARTY_SITE_ID           = g.PARTY_SITE_ID 
AND f.party_id                = g.party_id 
AND e.last_updated_by         = usr.user_id(+) 
AND h.LOCATION_ID             = g.LOCATION_ID 
AND a.status                  ='A' 
  /* ensure site is active */ 
AND g.status = 'A' 
  /* ensure location is active */ 
AND d.status              = 'A' 
AND d.payment_term_id     =i.term_id (+) 
AND c.profile_class_id    = pc.profile_class_id(+) 
AND c.collector_id        = ac.collector_id(+) 
AND NVL(i.LANGUAGE, 'US') = 'US' 
AND b.cust_account_id   = sales24mo.customer_id(+) 
AND b.org_id            = sales24mo.org_id(+) 
AND b.cust_acct_site_id = sales24mo.cust_acct_site_id(+) 
AND b.cust_account_id   = sales12mo.customer_id(+) 
AND b.org_id            = sales12mo.org_id(+) 
AND b.cust_acct_site_id = sales12mo.cust_acct_site_id(+) 
AND ter.territory_code  = h.country
--and f.party_number = 236349
  /* 04/22/2016: chack the site (HZ_PARTY_SITES) to ensure site is active 
  06/21/2016: added sales currency (attribute20 in hz_cust_acct_sites_all) 
  08/04/2016: checked the location record (hz_cust_site_uses_all) to ensure the location ios active 
  */ 
ORDER BY a.account_number, 
  party_number, 
  party_site_number;