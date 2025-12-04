select * from apps.hz_cust_account_roles
where CUST_ACCT_SITE_ID = 25411884;
where cust_account_id  IN (13111060);

select * from apps.hz_cust_site_uses_all
where site_use_id IN (489295);
where CUST_ACCT_SITE_ID IN (24674619);
where location = '9187';


select ece_tp_location_code,tp_header_id,a.* from apps.hz_cust_acct_sites_all a
where CUST_ACCT_SITE_ID IN (434168);
where cust_account_id  IN (7988643);
where tp_header_id = 1220;

select * from apps.hz_party_sites
--where party_site_number = '25531414';
--where party_id = 19277135;
--where location_id = 2509547;
where party_site_id IN (52929200);

select * from apps.hz_locations
where location_id IN (2557331);

select * from apps.hz_parties
where party_id IN (3394834, 3394560);

select SHIP_VIA,a.* from apps.hz_cust_accounts a
where cust_account_id  IN (4991,2434334);
where account_number  IN (269178,183011);

select * from apps.hz_contact_points
where owner_table_id IN (select party_site_id
from HZ_PARTY_SITES
where party_id=19524097)
order by last_update_date desc;

--First find out party_id of your customer using following sql:
select cust_account_id, party_id, account_name, account_number
from hz_cust_accounts
where account_number='1000478';

-- Find out party_site_id of the party against which you are going to create contact
select party_site_id, party_site_number, party_site_name, location_id, status
from HZ_PARTY_SITES
where party_id=19524097;

SELECT hou.NAME operating_unit_name,
         hou.short_code,
         hou.organization_id operating_unit_id,
         hou.set_of_books_id,
         hou.business_group_id,
         ood.organization_name inventory_organization_name,
         ood.organization_code Inv_organization_code,
         ood.organization_id Inv_organization_id,
         ood.chart_of_accounts_id
    FROM apps.hr_operating_units hou,
    apps.org_organization_definitions ood
   WHERE 1 = 1 AND hou.organization_id = ood.operating_unit
ORDER BY hou.organization_id ASC;


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
acct.ece_tp_location_code,
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
--AND cust.ACCOUNT_NUMBER = '1989';
--and acct.ece_tp_location_code is not null;
--AND acct.PARTY_SITE_ID = 52057843;
AND ship.cust_acct_site_id IN (24375977,767718);
and ship.price_list_id is not null
--AND loc.ADDRESS_LINES_PHONETIC IS NOT NULL;
--AND loc.ADDRESS_LINES_PHONETIC = 'S68';
--and loc.COUNTRY ='DE';

SELECT
    hp.party_name
FROM
    apps.hz_cust_site_uses_all            hcsua,
    apps.hz_cust_acct_sites_all      hcasa,
    apps.hz_party_sites                   hps,
    apps.hz_parties                       hp
WHERE
        hcsua.site_use_id = 769504
    AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
    AND hcasa.party_site_id = hps.party_site_id
    AND hps.party_id = hp.party_id;
    
    select * from hr_all_organization_units_tl;