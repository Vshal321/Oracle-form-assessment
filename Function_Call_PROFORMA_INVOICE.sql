SET SERVEROUTPUT ON 
DECLARE
      v_value                                   VARCHAR2 (100);
BEGIN 

 v_value := TREX_OM_SOA_REPORT_PKG.get_available_quantity (
           p_header_id         => 15970535
                               ,p_line_id          => 159046945
                               ,p_inventory_item_id =>29815508
							   ,p_ship_set_id       =>NULL
							   ,p_organization_id   =>21417
							   ,p_ordered_quantity  =>11
							   ,p_shipped_quantity  =>NULL
							   ,p_source_type_code  => 'INTERNAL'
         );
DBMS_OUTPUT.PUT_LINE('Available Qty Value :'|| v_value);
END;

SET SERVEROUTPUT ON 
DECLARE
      v_value                                   VARCHAR2 (100);
BEGIN 

 v_value := TREX_OM_SOA_REPORT_PKG.get_ship_set_name (
           p_header_id         => 15970535
                               ,p_line_id          => 159046945
                               ,p_inventory_item_id =>29815508
							   ,p_ship_set_id       =>68621951
							   ,p_organization_id   =>21417
							   ,p_ordered_quantity  =>11
							   ,p_shipped_quantity  =>NULL
							   ,p_source_type_code  => 'INTERNAL'
         );
DBMS_OUTPUT.PUT_LINE('Ship Set Function Value :'|| v_value);
END;