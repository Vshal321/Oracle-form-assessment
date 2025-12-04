SET SERVEROUTPUT ON 
DECLARE
      v_run_id                                       NUMBER := 0;
      v_ret_code                                   VARCHAR2 (4000);
      v_ret_mssg                                        VARCHAR2 (4000);
      v_sql                                          VARCHAR2 (2000);
BEGIN 


TREX_MGP_PROCESS_API_DATA_PK.GET_ORDDET (
        p_cust_accnt_id      =>   2655150 
        ,p_order_status       => 'u0000'
        ,p_order_date_start   => '29-AUG-2022'
        ,p_order_date_end     => '29-NOV-2022'
        ,p_language_code      => 'en'
        ,p_invoice_number     => 'u0000'
        ,p_order_number       => NULL
        ,p_po_number          => 'u0000'
        ,p_serial_number      => 'u0000'
        ,p_location           => '924 113TH ST'
        ,p_item_number        => 'u0000'
        ,p_item_desc          => NULL
          , p_run_id          => v_run_id
          , p_ret_code              => v_ret_code
          , p_ret_mssg               => v_ret_mssg
         );
   DBMS_OUTPUT.PUT_LINE('Run ID :'|| v_run_id);
DBMS_OUTPUT.PUT_LINE('Ret Code :'||v_ret_code);
DBMS_OUTPUT.PUT_LINE('Message Data:'||v_ret_mssg);
DBMS_OUTPUT.PUT_LINE('SQL Data:'||v_sql);
END;
