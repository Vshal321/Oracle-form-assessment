SELECT
    aps.vendor_name,
    aps.segment1,
    apss.vendor_site_code,
    apss.vendor_site_id,
    apss.address_line1
    || ' '
    || apss.address_line2
    || ' '
    || apss.address_line3
    || ' '
    || apss.address_line4
    || ' '
    || apss.city
    || ' '
    || apss.zip
    || ' '
    || apss.area_code
    || ' '
    || apss.state
    || ' '
    || apss.province
    || ' '
    || apss.county
    || ' '
    || apss.country AS address,
    decode(apss.ece_tp_location_code, NULL, apss.vendor_site_code),
    apss.ece_tp_location_code,
    apss.tp_header_id
FROM
   --apps.po_headers_all poh,
    apps.ap_suppliers             aps,
    apps.ap_supplier_sites_all    apss
WHERE
        aps.vendor_id = apss.vendor_id
    --and poh.vendor_site_id = apss.vendor_site_id
    AND aps.segment1 = '2259'
    AND apss.vendor_site_code = 'SAN RAMON - 1';
    AND poh.segment1 IN ( '16142629' );