SELECT ship.price_list_id,
cust.CUST_ACCOUNT_ID, cust.ACCOUNT_NUMBER customer_number,
party.party_name CUST_NAME,
decode(cust.status ,'A','Active','I','Inactive',cust.status)Account_Status,
loc.ADDRESS1||' '||loc.ADDRESS2||' '||loc.ADDRESS3||' '||loc.POSTAL_CODE ||' '||loc.CITY
||' '||NVL(loc.STATE , loc.PROVINCE) ||' '||DECODE(loc.COUNTRY,'MY','MALAYSIA',loc.COUNTRY) address,
loc.ADDRESS_LINES_PHONETIC,
loc.COUNTRY,
ship.LOCATION,
ship.status,
ship.SITE_USE_CODE,
ship.CUST_ACCT_SITE_ID,
ship.SITE_USE_ID,
acct.status,
acct.PARTY_SITE_ID,
acct.cust_account_id,
party_site.party_site_number,
party_site.PARTY_ID,
party_site.LOCATION_ID
FROM 
apps.hz_cust_accounts cust,
apps.hz_cust_acct_sites_all acct,
apps.hz_cust_site_uses_all ship,
apps.hz_party_sites party_site ,
apps.hz_locations loc,
apps.hz_parties party
WHERE cust.cust_account_id = acct.cust_account_id
AND acct.cust_acct_site_id = ship.cust_acct_site_id
AND acct.ORG_ID = ship.ORG_ID
--AND ship.SITE_USE_CODE = 'SHIP_TO'
--AND cust.status = 'A'
and loc.location_id = party_site.location_id
and acct.party_site_id = party_site.party_site_id
and cust.party_id = party.party_id
AND cust.ACCOUNT_NUMBER = '1989'
AND ship.cust_acct_site_id = 2679328;
and ship.price_list_id is not null
--AND loc.ADDRESS_LINES_PHONETIC IS NOT NULL;
--AND loc.ADDRESS_LINES_PHONETIC = 'S68';
--and loc.COUNTRY ='DE';