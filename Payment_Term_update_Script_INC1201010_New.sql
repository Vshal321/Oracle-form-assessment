--This script will update payment term to INV 60 in all open sales order headers and lines for Aerial.
-- change done for INC1201010
set serveroutput on 
DECLARE
    l_header_rec                   oe_order_pub.header_rec_type;
 --l_line_rec OE_ORDER_PUB.line_Rec_Type;--abdul
    l_line_tbl                     oe_order_pub.line_tbl_type;
    l_action_request_tbl           oe_order_pub.request_tbl_type;
    l_header_adj_tbl               oe_order_pub.header_adj_tbl_type;
    l_line_adj_tbl                 oe_order_pub.line_adj_tbl_type;
    l_header_scr_tbl               oe_order_pub.header_scredit_tbl_type;
    l_line_scredit_tbl             oe_order_pub.line_scredit_tbl_type;
    l_request_rec                  oe_order_pub.request_rec_type;
    l_return_status                VARCHAR2(1000);
    l_msg_count                    NUMBER;
    l_msg_data                     VARCHAR2(1000);
    p_api_version_number           NUMBER := 1.0;
    p_init_msg_list                VARCHAR2(10) := fnd_api.g_false;
    p_return_values                VARCHAR2(10) := fnd_api.g_false;
    p_action_commit                VARCHAR2(10) := fnd_api.g_false;
    x_return_status                VARCHAR2(1);
    x_msg_count                    NUMBER;
    x_msg_data                     VARCHAR2(100);
    p_header_rec                   oe_order_pub.header_rec_type := oe_order_pub.g_miss_header_rec;
    p_old_header_rec               oe_order_pub.header_rec_type := oe_order_pub.g_miss_header_rec;
    p_header_val_rec               oe_order_pub.header_val_rec_type := oe_order_pub.g_miss_header_val_rec;
    p_old_header_val_rec           oe_order_pub.header_val_rec_type := oe_order_pub.g_miss_header_val_rec;
    p_header_adj_tbl               oe_order_pub.header_adj_tbl_type := oe_order_pub.g_miss_header_adj_tbl;
    p_old_header_adj_tbl           oe_order_pub.header_adj_tbl_type := oe_order_pub.g_miss_header_adj_tbl;
    p_header_adj_val_tbl           oe_order_pub.header_adj_val_tbl_type := oe_order_pub.g_miss_header_adj_val_tbl;
    p_old_header_adj_val_tbl       oe_order_pub.header_adj_val_tbl_type := oe_order_pub.g_miss_header_adj_val_tbl;
    p_header_price_att_tbl         oe_order_pub.header_price_att_tbl_type := oe_order_pub.g_miss_header_price_att_tbl;
    p_old_header_price_att_tbl     oe_order_pub.header_price_att_tbl_type := oe_order_pub.g_miss_header_price_att_tbl;
    p_header_adj_att_tbl           oe_order_pub.header_adj_att_tbl_type := oe_order_pub.g_miss_header_adj_att_tbl;
    p_old_header_adj_att_tbl       oe_order_pub.header_adj_att_tbl_type := oe_order_pub.g_miss_header_adj_att_tbl;
    p_header_adj_assoc_tbl         oe_order_pub.header_adj_assoc_tbl_type := oe_order_pub.g_miss_header_adj_assoc_tbl;
    p_old_header_adj_assoc_tbl     oe_order_pub.header_adj_assoc_tbl_type := oe_order_pub.g_miss_header_adj_assoc_tbl;
    p_header_scredit_tbl           oe_order_pub.header_scredit_tbl_type := oe_order_pub.g_miss_header_scredit_tbl;
    p_old_header_scredit_tbl       oe_order_pub.header_scredit_tbl_type := oe_order_pub.g_miss_header_scredit_tbl;
    p_header_scredit_val_tbl       oe_order_pub.header_scredit_val_tbl_type := oe_order_pub.g_miss_header_scredit_val_tbl;
    p_old_header_scredit_val_tbl   oe_order_pub.header_scredit_val_tbl_type := oe_order_pub.g_miss_header_scredit_val_tbl;
    p_line_tbl                     oe_order_pub.line_tbl_type := oe_order_pub.g_miss_line_tbl;
    p_old_line_tbl                 oe_order_pub.line_tbl_type := oe_order_pub.g_miss_line_tbl;
    p_line_val_tbl                 oe_order_pub.line_val_tbl_type := oe_order_pub.g_miss_line_val_tbl;
    p_old_line_val_tbl             oe_order_pub.line_val_tbl_type := oe_order_pub.g_miss_line_val_tbl;
    p_line_adj_tbl                 oe_order_pub.line_adj_tbl_type := oe_order_pub.g_miss_line_adj_tbl;
    p_old_line_adj_tbl             oe_order_pub.line_adj_tbl_type := oe_order_pub.g_miss_line_adj_tbl;
    p_line_adj_val_tbl             oe_order_pub.line_adj_val_tbl_type := oe_order_pub.g_miss_line_adj_val_tbl;
    p_old_line_adj_val_tbl         oe_order_pub.line_adj_val_tbl_type := oe_order_pub.g_miss_line_adj_val_tbl;
    p_line_price_att_tbl           oe_order_pub.line_price_att_tbl_type := oe_order_pub.g_miss_line_price_att_tbl;
    p_old_line_price_att_tbl       oe_order_pub.line_price_att_tbl_type := oe_order_pub.g_miss_line_price_att_tbl;
    p_line_adj_att_tbl             oe_order_pub.line_adj_att_tbl_type := oe_order_pub.g_miss_line_adj_att_tbl;
    p_old_line_adj_att_tbl         oe_order_pub.line_adj_att_tbl_type := oe_order_pub.g_miss_line_adj_att_tbl;
    p_line_adj_assoc_tbl           oe_order_pub.line_adj_assoc_tbl_type := oe_order_pub.g_miss_line_adj_assoc_tbl;
    p_old_line_adj_assoc_tbl       oe_order_pub.line_adj_assoc_tbl_type := oe_order_pub.g_miss_line_adj_assoc_tbl;
    p_line_scredit_tbl             oe_order_pub.line_scredit_tbl_type := oe_order_pub.g_miss_line_scredit_tbl;
    p_old_line_scredit_tbl         oe_order_pub.line_scredit_tbl_type := oe_order_pub.g_miss_line_scredit_tbl;
    p_line_scredit_val_tbl         oe_order_pub.line_scredit_val_tbl_type := oe_order_pub.g_miss_line_scredit_val_tbl;
    p_old_line_scredit_val_tbl     oe_order_pub.line_scredit_val_tbl_type := oe_order_pub.g_miss_line_scredit_val_tbl;
    p_lot_serial_tbl               oe_order_pub.lot_serial_tbl_type := oe_order_pub.g_miss_lot_serial_tbl;
    p_old_lot_serial_tbl           oe_order_pub.lot_serial_tbl_type := oe_order_pub.g_miss_lot_serial_tbl;
    p_lot_serial_val_tbl           oe_order_pub.lot_serial_val_tbl_type := oe_order_pub.g_miss_lot_serial_val_tbl;
    p_old_lot_serial_val_tbl       oe_order_pub.lot_serial_val_tbl_type := oe_order_pub.g_miss_lot_serial_val_tbl;
    p_action_request_tbl           oe_order_pub.request_tbl_type := oe_order_pub.g_miss_request_tbl;
    x_header_rec                   oe_order_pub.header_rec_type;
    x_action_request_tbl           oe_order_pub.request_tbl_type;
    x_header_val_rec               oe_order_pub.header_val_rec_type;
    x_header_adj_tbl               oe_order_pub.header_adj_tbl_type;
    x_header_adj_val_tbl           oe_order_pub.header_adj_val_tbl_type;
    x_header_price_att_tbl         oe_order_pub.header_price_att_tbl_type;
    x_header_adj_att_tbl           oe_order_pub.header_adj_att_tbl_type;
    x_header_adj_assoc_tbl         oe_order_pub.header_adj_assoc_tbl_type;
    x_header_scredit_tbl           oe_order_pub.header_scredit_tbl_type;
    x_header_scredit_val_tbl       oe_order_pub.header_scredit_val_tbl_type;
    x_line_val_tbl                 oe_order_pub.line_val_tbl_type;
    x_line_adj_tbl                 oe_order_pub.line_adj_tbl_type;
    x_line_adj_val_tbl             oe_order_pub.line_adj_val_tbl_type;
    x_line_price_att_tbl           oe_order_pub.line_price_att_tbl_type;
    x_line_adj_att_tbl             oe_order_pub.line_adj_att_tbl_type;
    x_line_adj_assoc_tbl           oe_order_pub.line_adj_assoc_tbl_type;
    x_line_scredit_tbl             oe_order_pub.line_scredit_tbl_type;
    x_line_tbl                     oe_order_pub.line_tbl_type;
    x_line_scredit_val_tbl         oe_order_pub.line_scredit_val_tbl_type;
    x_lot_serial_tbl               oe_order_pub.lot_serial_tbl_type;
    x_lot_serial_val_tbl           oe_order_pub.lot_serial_val_tbl_type;
    x_action_request_tbl           oe_order_pub.request_tbl_type;
    x_debug_file                   VARCHAR2(100);
    l_line_tbl_index               NUMBER;
    l_msg_index_out                NUMBER(10);
    l_term_id                      NUMBER;
	l_cnt                          NUMBER := 0;
BEGIN
    dbms_output.enable(1000000);
    mo_global.init('ONT');
    mo_global.set_policy_context('S', 122); --give your org id instead of 11023
    fnd_global.apps_initialize(1249, 50383, 660);-- pass in user_id, responsibility_id, and application_id
    oe_msg_pub.initialize;
    oe_debug_pub.initialize;
    x_debug_file := oe_debug_pub.set_debug_mode('FILE');
    oe_debug_pub.setdebuglevel(5); -- Use 5 for the most debuging output, I warn  you its a lot of data
    dbms_output.put_line('START OF NEW DEBUG');
--This is to UPDATE order line
    l_line_tbl_index := 1;
BEGIN
    SELECT
        term_id
    INTO l_term_id
    FROM
        ra_terms
    WHERE
        name = 'INV 60';

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Payment Term Doesnt Exist');
END; 
FOR line_rec IN (
    SELECT
        ooh.header_id,
        ool.line_id
    FROM
        apps.oe_order_headers_all           ooh,
        apps.oe_order_lines_all             ool,
        apps.ra_terms                       rt,
        apps.qp_list_headers_all            qlh,
        apps.org_organization_definitions   ood
    WHERE
        ooh.header_id = ool.header_id
        AND ooh.sold_to_org_id IN (9719214)
        AND ooh.flow_status_code = 'BOOKED'
        AND ool.flow_status_code NOT IN (
            'CANCELLED',
            'CLOSED'
        )
        AND rt.term_id = ool.payment_term_id
        AND rt.name <> 'INV 60'
        AND ool.price_list_id = qlh.list_header_id
        AND ool.ship_from_org_id = ood.organization_id
        AND ooh.header_id in (13193139
,14459991
,16208059
,16208099
,16208100
,16208101
,16208102
,16208103
,16208104
,16208106
,16208109
,16208110
,16208113
,16208114
,16208115
,16208123
,16208155
,16208167
,16220025
,16303223
,16307161
,16307162
,16307163
,16307165
,16307166
,16307167
,16316541
,16316544
,16316546
,16316547
,16316556
,16331633
,16331671
,16331674
,16331675
,16331676
,16345483
,16497269
,16497297
,16497357
,16497614
,16632506
,16641992
,16642005
,16642006
,16642009
,16642017
,16642018
,16643434
,16643438
,16643439
,16643444
,16643445
,16643448
,16715323
,16715342
,16715346
,16715350
,16804736
,16804753
,16804755
,16809852
,16815036
,16815037
,16876039
,16876044
,16876060
,17081275
,17081276
,17081281
,17081282
,17081284
,17081285
,17081286
,17445697
,17445703
,17445704
,17445705
,17445706
,17445707
,17445709
,17445710
,17445711
,17445712
,17445716
,17445717
,17558679
,17576144
,17576165
,17576166
,17576167
,17576168
,17576169
,17576170
,17576171
,17576172
,17576173
,17576174
,17576175
,17576176
,17576177
,17576178
,17576179
,17576180
,17576186
,17576188
,17576189
,17576190
,17576191
,17576192
,17576193
,17576194
,17576195
,17576197
,17576199
,17576200
,17576201
,17576202
,17576203
,17576204
)
) LOOP
    l_header_rec := oe_order_pub.g_miss_header_rec;
    l_header_rec.header_id := line_rec.header_id;
    l_header_rec.payment_term_id := l_term_id;
    l_header_rec.change_reason := 'PRICING QUERY';--Pricing Query
    l_header_rec.operation := oe_globals.g_opr_update;
    l_line_tbl.DELETE;
-- Changed attributes
    l_line_tbl(l_line_tbl_index) := apps.oe_order_pub.g_miss_line_rec;--l_line_rec;
    l_line_tbl(l_line_tbl_index).payment_term_id := l_term_id;
    l_line_tbl(l_line_tbl_index).header_id := line_rec.header_id;
    l_line_tbl(l_line_tbl_index).line_id := line_rec.line_id;
    l_line_tbl(l_line_tbl_index).change_reason := 'PRICING QUERY';
    l_line_tbl(l_line_tbl_index).operation := oe_globals.g_opr_update;
-- CALL TO PROCESS ORDER
 OE_ORDER_PUB.process_order (
  p_api_version_number => 1.0
  , p_init_msg_list => fnd_api.g_false
  , p_return_values => fnd_api.g_false
  , p_action_commit => fnd_api.g_false
  , x_return_status => l_return_status
  , x_msg_count => l_msg_count
  , x_msg_data => l_msg_data
  , p_header_rec => l_header_rec
  , p_line_tbl => l_line_tbl
  , p_action_request_tbl => l_action_request_tbl
-- OUT PARAMETERS
  , x_header_rec => x_header_rec
  , x_header_val_rec => x_header_val_rec
  , x_Header_Adj_tbl => x_Header_Adj_tbl
  , x_Header_Adj_val_tbl => x_Header_Adj_val_tbl
  , x_Header_price_Att_tbl => x_Header_price_Att_tbl
  , x_Header_Adj_Att_tbl => x_Header_Adj_Att_tbl
  , x_Header_Adj_Assoc_tbl => x_Header_Adj_Assoc_tbl
  , x_Header_Scredit_tbl => x_Header_Scredit_tbl
  , x_Header_Scredit_val_tbl => x_Header_Scredit_val_tbl
  , x_line_tbl => x_line_tbl
  , x_line_val_tbl => x_line_val_tbl
  , x_Line_Adj_tbl => x_Line_Adj_tbl
  , x_Line_Adj_val_tbl => x_Line_Adj_val_tbl
  , x_Line_price_Att_tbl => x_Line_price_Att_tbl
  , x_Line_Adj_Att_tbl => x_Line_Adj_Att_tbl
  , x_Line_Adj_Assoc_tbl => x_Line_Adj_Assoc_tbl
  , x_Line_Scredit_tbl => x_Line_Scredit_tbl
  , x_Line_Scredit_val_tbl => x_Line_Scredit_val_tbl
  , x_Lot_Serial_tbl => x_Lot_Serial_tbl
  , x_Lot_Serial_val_tbl => x_Lot_Serial_val_tbl
  , x_action_request_tbl => p_action_request_tbl
 );

COMMIT; 
-- Check the return status
IF l_return_status = FND_API.G_RET_STS_SUCCESS
THEN

l_cnt := l_cnt + 1;

END IF ; 
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Number of Records Updated-'||' '||l_cnt);
END;