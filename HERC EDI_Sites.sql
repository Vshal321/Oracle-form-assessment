SELECT
    d.party_name              "Customer Name",
    d.party_id                "Customer ID",
    b.ece_tp_location_code    "EDI Location",
    c.location_id             "Location Code",
    f.address1
    || ' '
    || f.address2
    || ' '
    || f.address3
    || ' '
    || f.address4
    || ' '
    || f.city
    || ' '
    || f.postal_code
    || ' '
    || f.state
    || ' '
    || f.province
    || ' '
    || f.county
    || ' '
    || f.country               "Customer Address",
    b.cust_account_id         "Customer Account ID",
    e.account_number          "Customer Account Number",
    --a.tp_header_id,
    a.document_id             "Transaction ID",
    a.document_type           "Transaction Type",
    a.translator_code         "Transaction Code"
FROM
    apps.ece_tp_details            a,
    apps.hz_cust_acct_sites_all    b,
    apps.hz_party_sites            c,
    apps.hz_parties                d,
    apps.hz_cust_accounts          e,
    apps.hz_locations              f
WHERE
        a.tp_header_id = b.tp_header_id
    AND b.party_site_id = c.party_site_id
    AND c.party_id = d.party_id
    AND b.cust_account_id = e.cust_account_id
    AND c.location_id = f.location_id
    AND b.cust_acct_site_id IN (434168)
    AND a.document_id = 'INO'
    AND e.account_number = 1989;