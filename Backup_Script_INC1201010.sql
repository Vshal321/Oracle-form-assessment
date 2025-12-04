
CREATE TABLE trex_INC1201010_headers
TABLESPACE TREX_SCRAP
AS
SELECT ooh.* 
FROM
apps.oe_order_headers_all ooh,
apps.oe_order_lines_all ool,
apps.ra_terms rt,
apps.qp_list_headers_all qlh,
apps.org_organization_definitions ood
WHERE
ooh.header_id = ool.header_id
AND ooh.sold_to_org_id IN (9719214) --(Aerial Titans account Number= 192049 )
AND ooh.flow_status_code = 'BOOKED'
AND ool.flow_status_code NOT IN (
'CANCELLED',
'CLOSED'
)
AND rt.term_id = ool.payment_term_id
AND rt.name <> 'INV 60'
AND ool.price_list_id = qlh.list_header_id
AND ool.ship_from_org_id = ood.organization_id;



CREATE TABLE trex_INC1201010_lines
TABLESPACE TREX_SCRAP
AS
SELECT ool.* 
FROM
apps.oe_order_headers_all ooh,
apps.oe_order_lines_all ool,
apps.ra_terms rt,
apps.qp_list_headers_all qlh,
apps.org_organization_definitions ood
WHERE
ooh.header_id = ool.header_id
AND ooh.sold_to_org_id IN (9719214) --(Aerial Titans account Number= 192049 )
AND ooh.flow_status_code = 'BOOKED'
AND ool.flow_status_code NOT IN (
'CANCELLED',
'CLOSED'
)
AND rt.term_id = ool.payment_term_id
AND rt.name <> 'INV 60'
AND ool.price_list_id = qlh.list_header_id
AND ool.ship_from_org_id = ood.organization_id;