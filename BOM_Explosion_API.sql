CREATE OR REPLACE PROCEDURE xxbom_explosion_api (
    p_item_id IN NUMBER
) /* The BOM assembly which you want to explode */ IS
    v_group_id       NUMBER;
    x_error_message  VARCHAR2(2000);
    x_error_code     NUMBER;
    sess_id          NUMBER;
    l_rec_count      NUMBER;
BEGIN
--DELETE FROM xx_bom_explosion_temp;
--COMMIT;
    SELECT
        bom_explosion_temp_s.NEXTVAL
    INTO v_group_id
    FROM
        dual;

    SELECT
        bom_explosion_temp_session_s.NEXTVAL
    INTO sess_id
    FROM
        dual;

    bompxinq.exploder_userexit(verify_flag => 0, org_id => '105', order_by => 1,--:B_Bill_Of_Matls.Bom_Bill_Sort_Order_Type,
                              grp_id => v_group_id,
                              session_id => 0,
                              levels_to_explode => 20, --:B_Bill_Of_Matls.Levels_To_Explode,
                              bom_or_eng => 1, -- :Parameter.Bom_Or_Eng,
                              impl_flag => 1, --:B_Bill_Of_Matls.Impl_Only,
                              plan_factor_flag => 2, --:B_Bill_Of_Matls.Planning_Percent,
                              explode_option => 3, --:B_Bill_Of_Matls.Bom_Inquiry_Display_Type,
                              module => 2,--:B_Bill_Of_Matls.Costs,
                              cst_type_id => 0,--:B_Bill_Of_Matls.Cost_Type_Id,
                              std_comp_flag => 2,
                              expl_qty => 1,--:B_Bill_Of_Matls.Explosion_Quantity,
                              item_id => p_item_id,--:B_Bill_Of_Matls.Assembly_Item_Id,
                              alt_desg => NULL,--:B_Bill_Of_Matls.Alternate_Bom_Designator,
                              comp_code => NULL,
                              unit_number_from => 0, --NVL(:B_Bill_Of_Matls.Unit_Number_From, :CONTEXT.UNIT_NUMBER_FROM),
                              unit_number_to => 'ZZZZZZZZZZZZZZZZZ', --NVL(:B_Bill_Of_Matls.Unit_Number_To, :CONTEXT.UNIT_NUMBER_TO),
                              rev_date => sysdate, --:B_Bill_Of_Matls.Disp_Date,
                              show_rev => 1, -- yes
                              material_ctrl => 2, --:B_Bill_Of_Matls.Material_Control,
                              lead_time => 2, --:B_Bill_Of_Matls.Lead_Time,
                              err_msg => x_error_message, --err_msg
                              error_code => x_error_code);--error_code
    SELECT
        COUNT(*)
    INTO l_rec_count
    FROM
        bom_small_expl_temp temp
    WHERE
        temp.group_id = v_group_id;

    dbms_output.put_line('l_rec_count = ' || l_rec_count);
    INSERT INTO xx_bom_explosion_temp (
        top_bill_sequence_id,
        bill_sequence_id,
        organization_id,
        component_sequence_id,
        component_item_id,
        plan_level,
        extended_quantity,
        sort_order,
        request_id,
        program_application_id,
        program_id,
        program_update_date,
        group_id,
        session_id,
        select_flag,
        select_quantity,
        extend_cost_flag,
        top_alternate_designator,
        top_item_id,
        context,
        attribute1,
        attribute2,
        attribute3,
        attribute4,
        attribute5,
        attribute6,
        attribute7,
        attribute8,
        attribute9,
        attribute10,
        attribute11,
        attribute12,
        attribute13,
        attribute14,
        attribute15,
        header_id,
        line_id,
        list_price,
        selling_price,
        component_yield_factor,
        item_cost,
        include_in_rollup_flag,
        based_on_rollup_flag,
        actual_cost_type_id,
        component_quantity,
        shrinkage_rate,
        so_basis,
        optional,
        mutually_exclusive_options,
        check_atp,
        shipping_allowed,
        required_to_ship,
        required_for_revenue,
        include_on_ship_docs,
        include_on_bill_docs,
        low_quantity,
        high_quantity,
        pick_components,
        primary_uom_code,
        primary_unit_of_measure,
        base_item_id,
        atp_components_flag,
        atp_flag,
        bom_item_type,
        pick_components_flag,
        replenish_to_order_flag,
        shippable_item_flag,
        customer_order_flag,
        internal_order_flag,
        customer_order_enabled_flag,
        internal_order_enabled_flag,
        so_transactions_flag,
        mtl_transactions_enabled_flag,
        stock_enabled_flag,
        description,
        assembly_item_id,
        configurator_flag,
        price_list_id,
        rounding_factor,
        pricing_context,
        pricing_attribute1,
        pricing_attribute2,
        pricing_attribute3,
        pricing_attribute4,
        pricing_attribute5,
        pricing_attribute6,
        pricing_attribute7,
        pricing_attribute8,
        pricing_attribute9,
        pricing_attribute10,
        pricing_attribute11,
        pricing_attribute12,
        pricing_attribute13,
        pricing_attribute14,
        pricing_attribute15,
        component_code,
        loop_flag,
        inventory_asset_flag,
        planning_factor,
        operation_seq_num,
        parent_bom_item_type,
        wip_supply_type,
        item_num,
        effectivity_date,
        disable_date,
        implementation_date,
        supply_subinventory,
        supply_locator_id,
        component_remarks,
        change_notice,
        operation_lead_time_percent,
        rexplode_flag,
        common_bill_sequence_id,
        operation_offset,
        current_revision,
        locator,
        from_end_item_unit_number,
        to_end_item_unit_number,
        basis_type
    )
        SELECT
            top_bill_sequence_id,
            bill_sequence_id,
            organization_id,
            component_sequence_id,
            component_item_id,
            plan_level,
            extended_quantity,
            sort_order,
            request_id,
            program_application_id,
            program_id,
            program_update_date,
            group_id,
            session_id,
            select_flag,
            select_quantity,
            extend_cost_flag,
            top_alternate_designator,
            top_item_id,
            context,
            attribute1,
            attribute2,
            attribute3,
            attribute4,
            attribute5,
            attribute6,
            attribute7,
            attribute8,
            attribute9,
            attribute10,
            attribute11,
            attribute12,
            attribute13,
            attribute14,
            attribute15,
            header_id,
            line_id,
            list_price,
            selling_price,
            component_yield_factor,
            item_cost,
            include_in_rollup_flag,
            based_on_rollup_flag,
            actual_cost_type_id,
            component_quantity,
            shrinkage_rate,
            so_basis,
            optional,
            mutually_exclusive_options,
            check_atp,
            shipping_allowed,
            required_to_ship,
            required_for_revenue,
            include_on_ship_docs,
            include_on_bill_docs,
            low_quantity,
            high_quantity,
            pick_components,
            primary_uom_code,
            primary_unit_of_measure,
            base_item_id,
            atp_components_flag,
            atp_flag,
            bom_item_type,
            pick_components_flag,
            replenish_to_order_flag,
            shippable_item_flag,
            customer_order_flag,
            internal_order_flag,
            customer_order_enabled_flag,
            internal_order_enabled_flag,
            so_transactions_flag,
            mtl_transactions_enabled_flag,
            stock_enabled_flag,
            description,
            assembly_item_id,
            configurator_flag,
            price_list_id,
            rounding_factor,
            pricing_context,
            pricing_attribute1,
            pricing_attribute2,
            pricing_attribute3,
            pricing_attribute4,
            pricing_attribute5,
            pricing_attribute6,
            pricing_attribute7,
            pricing_attribute8,
            pricing_attribute9,
            pricing_attribute10,
            pricing_attribute11,
            pricing_attribute12,
            pricing_attribute13,
            pricing_attribute14,
            pricing_attribute15,
            component_code,
            loop_flag,
            inventory_asset_flag,
            planning_factor,
            operation_seq_num,
            parent_bom_item_type,
            wip_supply_type,
            item_num,
            effectivity_date,
            disable_date,
            implementation_date,
            supply_subinventory,
            supply_locator_id,
            component_remarks,
            change_notice,
            operation_lead_time_percent,
            rexplode_flag,
            common_bill_sequence_id,
            operation_offset,
            current_revision,
            locator,
            from_end_item_unit_number,
            to_end_item_unit_number,
            basis_type
        FROM
            bom_small_expl_temp;
/*Begin
for i in (select * from bom_small_expl_temp)
LOOP
UPDATE xx_bom_explosion_temp
SET
star_item = (
SELECT
segment1
FROM
inv.mtl_system_items_b msib
WHERE
msib.inventory_item_id = i.COMPONENT_ITEM_ID
AND msib.ORGANIZATION_ID =i.ORGANIZATION_ID
);
-- DBMS_OUTPUT.put_line('rowcount'||sql%rowcount);
--WHERE
--group_id = v_group_id;
END LOOP;
end;*/
    COMMIT;
END;
/
declare cursor c1 IS( SELECT
    inventory_item_id
FROM
( SELECT
    m.*,
    ROWNUM r
FROM
    mtl_system_items_b m where organization_id ='105'and item_type = 'ATO')where r > 701 and r <= 1000);
    begin 
    for i IN c1 
    loop xxbom_explosion_api(i.inventory_item_id) ;
    END LOOP ;
    end;
/
SELECT
    (
        SELECT
            segment1
        FROM
            mtl_system_items_b
        WHERE
                inventory_item_id = a.top_item_id
            AND organization_id = '105'
            AND item_type = 'ATO'
    )                                star_item,
    a.display_plan_level,
    a.plan_level                     "Level",
    a.item_number                    "Item",
    a.description                    "Description",
    a.current_revision               "Revision",
    a.item_type_description          "Type",
    a.item_status                    "Status",
    a.eng_item_flag                  "Engineering Item",
    a.item_num                       "Item Seq",
    a.operation_seq_num              "Op Seq",
    a.parent_alternate_flag          alternate,
    a.eng_bill                       "Engineering Bill",
    a.component_remarks              "Comments",
    a.unit_of_measure                "UOM",
    a.basis_type                    "Basis",
    a.component_quantity             "Quantity",
    a.planning_factor                "Planning %",
    a.component_yield_factor         "Yield Extended",
    a.effectivity_control            "Quantity Effectivity Control",
    a.effective_from                 "From",
    a.effective_to                   " To",
    a.from_effectivity_date          "From Date",
    a.to_effectivity_date            "To Date",
    a.implemented_flag               "Implemented ECO",
    a.supply_type                    "Supply Type",
    a.supply_subinventory            "Subinventory",
    a.locator                        "Locator",
    a.extend_cost_flag               "Costed",
    a.item_cost                      "Unit Cost",
    a.extended_quantity6             "Extended Quantity",
    a.extended_cost                  "Extended Cost",
    a.operation_seq_num7             "Operation Seq",
    a.manufacturing_lead_time        "Manufacturing",
    a.operation_offset               "Offset",
    a.cum_manufacturing_lead_time    "Cumulative Manufacuturing",
    a.cumulative_total_lead_time    "Cumulative Total Optional",
    a.mutually_exclusive_options     "Mutually Exclusive",
    a.check_atp                      "ATP",
    a.minimum_quantity               "Min Qty",
    a.maximum_quantity               "Max Qty",
    a.so_basis                       "Sales Order",
    a.shippable_item_flag            "BasisShippable",
    a.include_on_ship_docs           "Include on Ship Docs",
    a.required_to_ship               "Required To Ship",
    a.required_for_revenue           "Required For Revenue"
FROM
    bom_expl_inquiry_view a where A.CURRENT_REVISION is not null and plan_level > 0 and - 1 = - 1 START with a.top_item_id = a.top_item_id
    CONNECT BY NOCYCLE
PRIOR A.TOP_ITEM_ID = A.TOP_ITEM_ID
ORDER BY
A.SORT_ORDER;
    /