--Query to get responsibility assigned to a disc report
SELECT DISTINCT
    disco_docs.doc_name         "Discoverer Workbook",
    resp.responsibility_name    "Responsibility"
FROM
    eul5_us.eul5_documents       disco_docs,
    eul5_us.eul5_access_privs    disco_shares,
    eul5_us.eul5_eul_users       disco_users,
    fnd_responsibility_tl        resp
WHERE
        disco_docs.doc_id = disco_shares.gd_doc_id
    AND resp.responsibility_id = substr(disco_users.eu_username, 2, 5)
    AND disco_users.eu_id (+) = disco_shares.ap_eu_id
    AND upper(disco_docs.doc_name) LIKE upper('Terex PPV All Transactions with FX split'); ---> work book name
/

--To find the owner,folder,business area of the Disc report
SELECT DISTINCT
    b.doc_developer_key    document_developer_key,
    b.doc_name             document_name,
    a.qs_doc_details       worksheet_name,
    c.obj_name             folder_name,
    c.obj_developer_key    folder_developer_key,
    d.ba_name              business_unit,
    fu.user_name           created_by
FROM
    eul5_us.eul5_qpp_stats       a,
    eul5_us.eul5_documents       b,
    eul5_us.eul5_objs            c,
    eul5_us.eul5_bas             d,
    eul5_us.eul5_ba_obj_links    f,
    fnd_user                     fu
WHERE
    b.doc_name LIKE 'Terex PPV All Transactions with FX split'
    AND a.qs_doc_name = b.doc_name
        AND instr(a.qs_object_use_key, c.obj_id) <> 0
            AND c.obj_id = f.bol_obj_id
                AND d.ba_id = f.bol_ba_id
                    AND to_char(fu.user_id) = substr(b.doc_updated_by, 2)
ORDER BY
    b.doc_developer_key;
/