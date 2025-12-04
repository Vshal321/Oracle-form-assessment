  -- +======================================================================+
   -- File       : INC1077574_API_Script.sql
   -- Name       : Supriya Nainglaj
   -- Date       : 20-JUNE-2023
   -- Description: API to update or add new FND messages
   -- Modification History:
   -- --------------------
   --  Modified By         Date         Version   Description
   -- -------------       ----------    -------   ----------------------------------
   --  Supriya Nainglaj    04-04-2023   1.0       INC1077574 - Need DOC messages created

DECLARE
    lv_curr_lang       VARCHAR2(50) := NULL;
    CURSOR c_rec IS
    SELECT
        *
    FROM
        bolinf.trex_fnd_msg_stg;

BEGIN

    SELECT
        value
    INTO lv_curr_lang
    FROM
        nls_session_parameters
    WHERE
        parameter = 'NLS_LANGUAGE';
--Initialize applications information     

    fnd_global.apps_initialize(1249, 20419, 20003); 
    ----dbms_output.put_line('curr lang: ' || lv_curr_lang);
    FOR v_rec IN c_rec LOOP
        EXECUTE IMMEDIATE 'alter session SET nls_language ='|| v_rec.lang||'';
        --dbms_output.put_line('Lang set for : ' || v_rec.lang);
        fnd_new_messages_pkg.load_row(x_application_id => 20003, x_message_name => v_rec.message_name, x_message_number
        => NULL, x_message_text => v_rec.message, x_description => NULL,
                                      x_type => '30_PCT_EXPANSION_PROMPT', x_max_length => NULL, x_category => NULL, x_severity => NULL, x_fnd_log_severity => NULL,
                                      x_owner => 'TEREX.OPS', x_custom_mode => 'FORCE', x_last_update_date => NULL);

        --dbms_output.put_line('Inserted message');
    END LOOP;

    EXECUTE IMMEDIATE 'alter session SET nls_language ='|| lv_curr_lang||'';
    COMMIT;
END;