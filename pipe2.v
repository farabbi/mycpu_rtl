module pipe2
(
    input  wire        clock,
    input  wire        reset,

    input  wire        valid,
    output wire        valid_out,

    input  wire        allow_out,
    output wire        allow_in,

    input  wire [31:0] inst,
    input  wire [31:0] data_exec,
    input  wire [31:0] data_mem,
    input  wire [31:0] data_wb,
    input  wire [31:0] pc,
    input  wire [ 5:0] ex,
    input  wire        regfile_we,
    input  wire [ 4:0] regfile_waddr,
    input  wire [31:0] regfile_wdata,
    input  wire        is_bd_load,
    input  wire [ 4:0] dest_exec,
    input  wire [ 4:0] dest_mem,
    input  wire [ 4:0] dest_wb,

    output wire [31:0] vsrc1,
    output wire [31:0] vsrc2,
    output wire [15:0] imm,
    output wire [ 5:0] ex_out,
    output wire [31:0] pc_out,
    output wire [ 4:0] dest_out,
    output wire [31:0] ctrl_info_out,
    output wire [31:0] ctrl_info2_out,
    output wire        is_bd_save,
    output wire [31:0] branch_offset,
    output wire [25:0] jump_target,
    output wire        br_taken,
    output wire        j_taken,
    output wire        jr_taken,

    input  wire        pipe3_valid,
    input  wire        pipe3_finish,
    input  wire        pipe4_valid,
    input  wire        pipe4_finish,
    input  wire        pipe5_valid,
    input  wire        pipe5_finish,

    output wire [31:0] rf_0,
    output wire [31:0] rf_1,
    output wire [31:0] rf_2,
    output wire [31:0] rf_3,
    output wire [31:0] rf_4,
    output wire [31:0] rf_5,
    output wire [31:0] rf_6,
    output wire [31:0] rf_7,
    output wire [31:0] rf_8,
    output wire [31:0] rf_9,
    output wire [31:0] rf_10,
    output wire [31:0] rf_11,
    output wire [31:0] rf_12,
    output wire [31:0] rf_13,
    output wire [31:0] rf_14,
    output wire [31:0] rf_15,
    output wire [31:0] rf_16,
    output wire [31:0] rf_17,
    output wire [31:0] rf_18,
    output wire [31:0] rf_19,
    output wire [31:0] rf_20,
    output wire [31:0] rf_21,
    output wire [31:0] rf_22,
    output wire [31:0] rf_23,
    output wire [31:0] rf_24,
    output wire [31:0] rf_25,
    output wire [31:0] rf_26,
    output wire [31:0] rf_27,
    output wire [31:0] rf_28,
    output wire [31:0] rf_29,
    output wire [31:0] rf_30,
    output wire [31:0] rf_31,
    
    input  wire        pipe3_load_op,
    input  wire        pipe4_load_op
);

wire ready_to_go;

assign valid_out = valid & ready_to_go;
assign allow_in = !valid || valid_out && allow_out;

wire       reg_we;
wire       imm_op;
wire       unsigned_op;
wire       do_sub;
wire [3:0] alu_res_sel;
wire [2:0] shift_type;
wire [4:0] logic_type;
wire       load_op;
wire [4:0] load_type;
wire       store_op;
wire [2:0] store_type;
wire       link_op;
wire [4:0] reg_waddr;
wire       ri_op;
wire       break_op;
wire       syscall_op;
wire [7:0] branch_type;
wire [4:0] cp0_reg;
wire [2:0] cp0_sel;
wire [6:0] special_reg_inst;
wire       overflow_op;
wire       pre_is_bd_save;
wire       use_reg_op;
wire [4:0] read_dest1;
wire [4:0] read_dest2;
wire       div_op;
decode decode(
    .inst               (inst), 
    .reg_we             (reg_we), 
    .reg_waddr          (reg_waddr), 
    .imm_op             (imm_op), 
    .unsigned_op        (unsigned_op), 
    .do_sub             (do_sub), 
    .alu_res_sel        (alu_res_sel), 
    .shift_type         (shift_type), 
    .logic_type         (logic_type), 
    .load_op            (load_op), 
    .load_type          (load_type), 
    .store_op           (store_op), 
    .store_type         (store_type), 
    .is_bd              (pre_is_bd_save), 
    .branch_type        (branch_type), 
    .link_op            (link_op), 
    .break_op           (break_op), 
    .syscall_op         (syscall_op), 
    .ri_op              (ri_op), 
    .cp0_reg            (cp0_reg), 
    .cp0_sel            (cp0_sel), 
    .special_reg_inst   (special_reg_inst), 
    .overflow_op        (overflow_op),
    .use_reg_op			(use_reg_op),
    .read_dest1			(read_dest1),
    .read_dest2			(read_dest2),
    .div_op				(div_op)
    );

wire not_ready_to_go;
load_to_use load_to_use(
	.pipe3_load_op		(pipe3_load_op),
	.pipe4_load_op      (pipe4_load_op),
	.pipe3_dest			(dest_exec),
	.pipe4_dest         (dest_mem),
	.pipe2_read_dest1	(read_dest1),
	.pipe2_read_dest2	(read_dest2),
	.pipe2_use_reg_op	(use_reg_op),
	.not_ready_to_go	(not_ready_to_go)
);
assign ready_to_go = ~not_ready_to_go;

assign is_bd_save = pre_is_bd_save & valid;

assign ctrl_info_out = {2'b0, div_op, overflow_op, reg_we, imm_op, unsigned_op, do_sub, alu_res_sel, shift_type, logic_type, load_op, load_type, store_op, store_type, link_op, is_bd_load};
assign ctrl_info2_out = {17'b0, special_reg_inst, cp0_reg, cp0_sel};
assign dest_out = reg_we ? reg_waddr : 5'b0;
assign pc_out = pc;
assign ex_out = ex ? ex : {1'b0, ri_op, break_op, syscall_op, 2'b0};

wire [31:0] rdata1;
wire [31:0] rdata2;
rf2r1w regfile(
    .clock  (clock), 
    .reset  (reset), 
    .raddr1 (inst[25:21]), 
    .rdata1 (rdata1), 
    .raddr2 (inst[20:16]), 
    .rdata2 (rdata2), 
    .we     (regfile_we), 
    .waddr  (regfile_waddr), 
    .wdata  (regfile_wdata), 
    .rf_0   (rf_0), 
    .rf_1   (rf_1), 
    .rf_2   (rf_2), 
    .rf_3   (rf_3), 
    .rf_4   (rf_4), 
    .rf_5   (rf_5), 
    .rf_6   (rf_6), 
    .rf_7   (rf_7), 
    .rf_8   (rf_8), 
    .rf_9   (rf_9), 
    .rf_10  (rf_10), 
    .rf_11  (rf_11), 
    .rf_12  (rf_12), 
    .rf_13  (rf_13), 
    .rf_14  (rf_14), 
    .rf_15  (rf_15), 
    .rf_16  (rf_16), 
    .rf_17  (rf_17), 
    .rf_18  (rf_18), 
    .rf_19  (rf_19), 
    .rf_20  (rf_20), 
    .rf_21  (rf_21), 
    .rf_22  (rf_22), 
    .rf_23  (rf_23), 
    .rf_24  (rf_24), 
    .rf_25  (rf_25), 
    .rf_26  (rf_26), 
    .rf_27  (rf_27), 
    .rf_28  (rf_28), 
    .rf_29  (rf_29), 
    .rf_30  (rf_30), 
    .rf_31  (rf_31)
    );

assign imm = link_op ? 16'd8 : inst[15:0];

assign branch_offset = {{14{inst[15]}}, inst[15:0], 2'b0};
assign jump_target = inst[25:0];

wire [1:0] rs_sel;
wire [1:0] rt_sel;
register_hazard register_hazard(
    .dest_exec      (dest_exec), 
    .dest_mem       (dest_mem), 
    .dest_wb        (dest_wb), 
    .rs             (inst[25:21]), 
    .rt             (inst[20:16]), 
    .rs_sel         (rs_sel), 
    .rt_sel         (rt_sel), 
    .pipe3_valid    (pipe3_valid), 
    .pipe3_finish   (pipe3_finish), 
    .pipe4_valid    (pipe4_valid), 
    .pipe4_finish   (pipe4_finish), 
    .pipe5_valid    (pipe5_valid), 
    .pipe5_finish   (pipe5_finish)
    );

wire [3:0] rs_sel_d;
wire [3:0] rt_sel_d;
assign rs_sel_d[0] = rs_sel==2'b00;
assign rs_sel_d[1] = rs_sel==2'b01;
assign rs_sel_d[2] = rs_sel==2'b10;
assign rs_sel_d[3] = rs_sel==2'b11;
assign rt_sel_d[0] = rt_sel==2'b00;
assign rt_sel_d[1] = rt_sel==2'b01;
assign rt_sel_d[2] = rt_sel==2'b10;
assign rt_sel_d[3] = rt_sel==2'b11;

wire [31:0] rs_result;
wire [31:0] rt_result;
assign rs_result = {32{rs_sel_d[0]}} & rdata1
                 | {32{rs_sel_d[1]}} & data_wb
                 | {32{rs_sel_d[2]}} & data_mem
                 | {32{rs_sel_d[3]}} & data_exec;
assign rt_result = {32{rt_sel_d[0]}} & rdata2
                 | {32{rt_sel_d[1]}} & data_wb
                 | {32{rt_sel_d[2]}} & data_mem
                 | {32{rt_sel_d[3]}} & data_exec;

assign vsrc1 = rs_result;
assign vsrc2 = rt_result;

wire pre_br_taken;
wire pre_j_taken;
wire pre_jr_taken;
branch branch(
    .type       (branch_type), 
    .opa        (rs_result), 
    .opb        (rt_result), 
    .br_taken   (pre_br_taken), 
    .j_taken    (pre_j_taken), 
    .jr_taken   (pre_jr_taken)
    );

assign br_taken = pre_br_taken & valid;
assign j_taken = pre_j_taken & valid;
assign jr_taken = pre_jr_taken & valid;

endmodule
