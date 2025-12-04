--GL Period--
select set_of_books_id, period_name, decode(closing_status,'O','Open', 'C','Closed', 'F','Future', 'N','Never', closing_status) gl_status, start_date, end_date
from apps.gl_period_statuses
where trunc(start_date) > sysdate-40    --adjust date as needed
and trunc(start_date) < sysdate+1
and application_id = 101
order by application_id,start_date desc;

--PO Period--
select set_of_books_id, application_id, period_name, decode(closing_status,'O','Open', 'C','Closed', 'F','Future', 'N','Never', closing_status) po_status, start_date, end_date
from apps.gl_period_statuses
where trunc(start_date) > sysdate-40    --adjust date as needed
and trunc(start_date) < sysdate+1
and application_id = 201
order by application_id,start_date desc;

SELECT oap.organization_id "Organization ID"
,mp.organization_code "Organization Code"
,oap.period_name "Period Name"
,oap.period_start_date "Start Date"
,oap.period_close_date "Closed Date"
,decode(oap.open_flag,
 'P','P - Period Close is processing'
,'N','N - Period Close process is completed'
,'Y','Y - Period is open if Closed Date is NULL'
,'Unknown') "Period Status", oap.creation_date, oap.last_update_date
FROM apps.org_acct_periods oap
,apps.mtl_parameters mp
WHERE oap.organization_id = mp.organization_id
AND trunc(period_start_date) > sysdate-40    --adjust date as needed
and trunc(period_start_date) < sysdate+1
and oap.organization_id = 31890
--order by oap.last_update_date desc;
order by oap.organization_id,oap.period_start_date;

--The following SQL may be used to check for valid periods applicable to GL and PO:
SELECT sob.name "Set of Books"
,fnd.product_code "Porduct Code"
,ps.PERIOD_NAME "Period Name"
,ps.START_DATE "Period Start Date"
,ps.END_DATE "Period End Date"
,ps.creation_date, ps.last_update_date
,decode(ps.closing_status,
 'O','O - Open'
,'N','N - Never Opened'
,'F','F - Future Enterable'
,'C','C - Closed'
,'Unknown') "Period Status"
FROM apps.gl_period_statuses ps
,apps.GL_SETS_OF_BOOKS sob
,apps.FND_APPLICATION_VL fnd
WHERE ps.application_id in (101,201)  -- GL & PO
and sob.SET_OF_BOOKS_ID = ps.SET_OF_BOOKS_ID
and fnd.application_id = ps.application_id
AND ps.adjustment_period_flag = 'N'
AND fnd.product_code = 'GL'
AND (trunc(sysdate-30) -- Comment line if a a date other than SYSDATE is being tested.
--AND ('01-APR-2011' -- Uncomment line if a date other than SYSDATE is being tested.
BETWEEN trunc(ps.start_date) AND trunc (ps.end_date))
order by ps.SET_OF_BOOKS_ID,fnd.product_code, ps.start_date;

--The following SQL may be used to check for valid periods applicable to INV:
SELECT mp.organization_id "Organization ID"
,mp.ORGANIZATION_CODE "Organization Code"
,ood.ORGANIZATION_NAME "Organization Name"
,oap.period_name "Period Name"
,oap.period_start_date "Start Date"
,oap.PERIOD_CLOSE_DATE "Closed Date"
,oap.schedule_close_date "Scheduled Close"
,decode(oap.open_flag,
 'P','P - Period Close is processing'
,'N','N - Period Close process is completed'
,'Y','Y - Period is open if Closed Date is NULL'
,'Unknown') "Period Status",
oap.creation_date, oap.last_update_date
FROM apps.org_acct_periods oap
,apps.org_organization_definitions ood
,apps.mtl_parameters mp
WHERE oap.organization_id = mp.organization_id
AND mp.organization_id = ood.organization_id(+)
and ood.organization_code = 799
--AND (trunc(sysdate) -- Comment line if a a date other than SYSDATE is being tested.
--AND ('01-APR-2011' -- Uncomment line if a date other than SYSDATE is being tested.
--BETWEEN trunc(oap.period_start_date) AND trunc (oap.schedule_close_date))
ORDER BY mp.organization_id,oap.period_start_date;