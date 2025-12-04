SELECT
    to_char(hdr.creation_date, 'MON-YYYY') as Month,
    COUNT(hdr.REQUEST_ID) as Total_Count
FROM
    bolinf.trex_fnd_user_resp_hdr_tbl    hdr,
    bolinf.trex_fnd_user_resp_det_tbl    dtl
WHERE
        1 = 1
    AND dtl.level_1_approver IS NULL
    AND dtl.item_type = 'TREXRESP'
    AND hdr.request_status = 'Closed'
    AND hdr.header_id = dtl.header_id
GROUP BY
    to_char(hdr.creation_date, 'MON-YYYY')
ORDER BY TO_DATE(TO_CHAR(hdr.creation_date,'MON-YYYY'),'MON-YYYY') desc;