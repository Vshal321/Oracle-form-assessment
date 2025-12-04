	Select eic.interface_table_id,Eit.Transaction_Type, Eit.Interface_Table_Name,Eit.Key_Column_Name, Eic.Record_Number,
	EIC.position,EIC.width,EIC.interface_column_name,EIC.data_type,EIC.base_table_name,EIC.base_column_name,EIC.record_layout_code,--, EIT.layout_qualifier
	eic.XREF_CATEGORY_ALLOWED,eic.XREF_CATEGORY_ID,eic.XREF_KEY1_SOURCE_COLUMN,eic.XREF_KEY2_SOURCE_COLUMN,eic.XREF_KEY3_SOURCE_COLUMN,eic.XREF_KEY4_SOURCE_COLUMN
    from apps.ece_interface_columns EIC,
	apps.ece_interface_tables EIT
	where EIC.interface_table_id = EIT.interface_table_id
	And Eit.Transaction_Type = 'POO'
    AND EIC.RECORD_NUMBER = 1160
    --AND EIC.XREF_CATEGORY_ID IS NOT NULL
    --AND eic.XREF_CATEGORY_ALLOWED = 'Y'
    --AND EIC.base_column_name like 'SU%'
	--and base_column_name like '%SITE%'
	--AND upper(EIC.INTERFACE_COLUMN_NAME) LIKE upper('%ITEM%')
	order by record_number,position;
    
    
    select * from apps.ece_interface_columns
    where interface_table_id = 790;