module pipe5
(
    input  wire        clock,
    input  wire        reset,

    input  wire        valid,
    output wire        valid_out,

    output wire        allow_in,

    output wire        data_finish,

    input  wire [ 5:0] ex,
    input  wire [31:0] pc,
    input  wire [ 4:0] dest,
    input  wire [31:0] ctrl_info,
    input  wire [31:0] ctrl_info2,
    input  wire [31:0] wb_value,

    output wire [ 5:0] ex_out,
    output wire [ 4:0] dest_out,
    output wire        regfile_we,
    output wire [31:0] regfile_data,

    output wire        inst_ERET,
    output wire [31:0] cp0_value_out,
 
 	input  wire [31:0] hi,
 	input  wire [31:0] low
);

wire reg_we;
wire is_bd;
assign is_bd = ctrl_info[0];
assign reg_we = ctrl_info[27];

wire inst_MFHI;
wire inst_MFLO;
wire inst_MTHI;
wire inst_MTLO;
wire inst_MFC0;
wire inst_MTC0;
wire [4:0] cp0_reg;
wire [2:0] cp0_sel;
assign inst_MFHI = ctrl_info2[11];
assign inst_MFLO = ctrl_info2[10];
assign inst_MTHI = ctrl_info2[13];
assign inst_MTLO = ctrl_info2[12];
assign inst_MFC0 = ctrl_info2[8];
assign inst_MTC0 = ctrl_info2[9];
assign cp0_reg = ctrl_info2[7:3];
assign cp0_sel = ctrl_info2[2:0];

assign inst_ERET = ctrl_info2[14];

wire [2:0] MF_sel;
wire [31:0] MF_value;
wire [31:0] MFLO_value;
wire [31:0] MFHI_value;
wire [31:0] MFC0_value;
wire MTLO_we;
wire MTHI_we;
wire MTC0_we;
assign MTLO_we = inst_MTLO & ~(|ex) & valid;
assign MTHI_we = inst_MTHI & ~(|ex) & valid;

wire [31:0] hi_value;
wire [31:0] low_value;
wire mul_div_op;
assign mul_div_op = MTLO_we & MTHI_we;
assign hi_value = mul_div_op ? hi : wb_value;
assign low_value = mul_div_op ? low : wb_value;

low_reg low_reg(
	.clock		(clock), 
	.reset		(reset), 
	.value		(low_value), 
	.we			(MTLO_we), 
	.value_out	(MFLO_value)
	);
hi_reg hi_reg(
	.clock		(clock), 
	.reset		(reset), 
	.value		(hi_value), 
	.we			(MTHI_we), 
	.value_out	(MFHI_value)
	);
	
assign MF_sel = {inst_MFC0, inst_MFHI, inst_MFLO};
assign MF_value = {32{MF_sel[0]}} & MFLO_value
                | {32{MF_sel[1]}} & MFHI_value
                | {32{MF_sel[2]}} & MFC0_value;
assign regfile_data = MF_sel ? MF_value : wb_value;

assign regfile_we = reg_we & ~(|ex) & valid;

assign dest_out = dest;

assign ex_out = ex;

assign data_finish = reg_we;

assign valid_out = valid;

assign allow_in = 1'b1;

wire [31:0] epc_in;
assign epc_in = is_bd ? pc - 32'd4 : pc;

wire cp0_we;
assign cp0_we = inst_MTC0 & ~(|ex) & valid;
cp0_reg cp0_reg1(
	.clock			(clock), 
	.reset			(reset), 
	.ex				(ex), 
	.epc_in			(epc_in), 
	.is_bd			(is_bd), 
	.cp0_reg		(cp0_reg), 
	.cp0_sel		(cp0_sel), 
	.we				(cp0_we), 
	.value			(wb_value), 
	.value_out		(MFC0_value), 
	.inst_ERET		(inst_ERET), 
	.valid			(valid)
	);

assign cp0_value_out = MFC0_value;

endmodule
