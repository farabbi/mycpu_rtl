module pipe3
(
    input  wire        valid,
    output wire        valid_out,

    input  wire        allow_out,
    output wire        allow_in,

    output wire        data_finish,

    input  wire [ 5:0] ex,
    input  wire [31:0] pc,
    input  wire [ 4:0] dest,
    input  wire [31:0] ctrl_info,
    input  wire [31:0] ctrl_info2,
    input  wire [31:0] vsrc1,
    input  wire [31:0] vsrc2,
    input  wire [15:0] imm,

    output wire [ 5:0] ex_out,
    output wire [31:0] pc_out,
    output wire [ 4:0] dest_out,
    output wire [31:0] ctrl_info_out,
    output wire [31:0] ctrl_info2_out,
    output wire [31:0] mem_value,
    output wire [ 1:0] offset,
    output wire [31:0] data_ram_addr,
    output wire [ 3:0] data_ram_we,
    output wire [31:0] data_ram_din,
    
    output wire        pipe3_load_op,
    
    input  wire        div_complete,
    output wire        div_op
);

wire ready_to_go;
assign valid_out = valid & ready_to_go;
assign allow_in = !valid || valid_out && allow_out;

assign ready_to_go = div_op ? div_complete : 1'b1;

assign div_op = ctrl_info[29];

wire reg_we;
wire load_op;
wire overflow_op;
assign reg_we = ctrl_info[27];
assign load_op = ctrl_info[11];
assign data_finish = reg_we & ~load_op;
assign overflow_op = ctrl_info[28];

wire inst_MFC0;
wire inst_MFHI;
wire inst_MFLO;
assign inst_MFC0 = ctrl_info2[8];
assign inst_MFHI = ctrl_info2[11];
assign inst_MFLO = ctrl_info2[10];

assign pipe3_load_op = load_op | inst_MFC0 | inst_MFHI | inst_MFLO;

wire inst_MTC0;
wire inst_MTHI;
wire inst_MTLO;
assign inst_MTC0 = ctrl_info2[9];
assign inst_MTHI = ctrl_info2[13];
assign inst_MTLO = ctrl_info2[12];

wire       imm_op;
wire       unsigned_op;
wire       link_op;
wire       do_sub;
wire [2:0] shift_type;
wire [4:0] logic_type;
wire [3:0] alu_res_sel;
wire       store_op;
wire [2:0] store_type;
wire [4:0] load_type;
assign imm_op = ctrl_info[26];
assign unsigned_op = ctrl_info[25];
assign link_op = ctrl_info[1];
assign do_sub = ctrl_info[24];
assign shift_type = ctrl_info[19:17];
assign logic_type = ctrl_info[16:12];
assign alu_res_sel = ctrl_info[23:20];
assign store_op = ctrl_info[5];
assign store_type = ctrl_info[4:2];
assign load_type = ctrl_info[10:6];

wire overflow;
wire adel;
wire ades;
wire [3:0] pre_data_ram_we;
wire [31:0] alu_result;
alu alu(
	.vsrc1				(vsrc1), 
	.vsrc2				(vsrc2), 
	.imm				(imm), 
	.pc					(pc), 
	.alu_res_sel		(alu_res_sel), 
	.logic_type			(logic_type), 
	.shift_type			(shift_type), 
	.imm_op				(imm_op), 
	.unsigned_op		(unsigned_op), 
	.link_op			(link_op), 
	.do_sub				(do_sub), 
	.store_op			(store_op), 
	.store_type			(store_type), 
	.load_type			(load_type), 
	.res				(alu_result), 
	.offset				(offset), 
	.data_ram_addr		(data_ram_addr), 
	.data_ram_we		(pre_data_ram_we), 
	.data_ram_din		(data_ram_din), 
	.overflow			(overflow), 
	.adel				(adel), 
	.ades				(ades), 
	.overflow_op		(overflow_op)
);

wire [31:0] MT_value;
wire [1:0] MT_sel;
assign MT_sel = {inst_MTC0, inst_MTHI | inst_MTLO};
assign MT_value = {32{MT_sel[0]}} & vsrc1
                | {32{MT_sel[1]}} & vsrc2;
assign mem_value = MT_sel ? MT_value : alu_result;

assign ex_out = ex ? ex : {overflow, 3'b0, ades, adel};
assign pc_out = pc;
assign dest_out = dest;
assign ctrl_info_out = ctrl_info;
assign ctrl_info2_out = ctrl_info2;

assign data_ram_we = pre_data_ram_we & {4{~(|ex) & ~overflow & ~adel & ~ades & valid}};

endmodule
