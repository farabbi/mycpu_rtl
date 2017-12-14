module cpu
(
    input  wire        clock,
    input  wire        reset,
    input  wire [31:0] inst_ram_inst,
    input  wire [31:0] data_ram_data,
    output wire [31:0] inst_ram_addr,
    output wire [ 3:0] inst_ram_we,
    output wire [31:0] inst_ram_din,
    output wire [31:0] data_ram_addr,
    output wire [ 3:0] data_ram_we,
    output wire [31:0] data_ram_din,

    output wire        wb_valid,
    output wire [31:0] wb_pc,
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
    output wire [31:0] rf_31
);

assign wb_valid = pipe5_valid;
assign wb_pc = pc_to_pipe5;

wire pipe0_valid;
wire pipe5_valid;
wire [5:0] pipe5_ex;
wire [31:0] pipe1_pc;
wire nextpc_en;
wire br_taken;
wire [31:0] branch_offset;
wire j_taken;
wire [25:0] jump_target;
wire jr_taken;
wire [31:0] nextpc;
wire inst_ERET;
wire [31:0] cp0_value;
wire [31:0] vsrc1;
pipe0 pipe0(
    .clock         (clock), 
    .reset         (reset), 
    .pc            (pipe1_pc),
    .nextpc_en     (nextpc_en), 
    .br_taken      (br_taken), 
    .branch_offset (branch_offset), 
    .j_taken       (j_taken), 
    .jump_target   (jump_target), 
    .jr_taken      (jr_taken), 
    .vsrc1         (vsrc1), 
    .ex            (pipe5_ex), 
    .nextpc        (nextpc), 
    .inst_ram_addr (inst_ram_addr), 
    .inst_ram_we   (inst_ram_we), 
    .inst_ram_din  (inst_ram_din), 
    .inst_ERET     (inst_ERET), 
    .cp0_value     (cp0_value),
    .valid_out     (pipe0_valid),
    .pipe5_valid   (pipe5_valid)
);

wire pipe1_valid;
wire [5:0] pipe1_ex;
wire pipe2_valid;
wire [5:0] pipe2_ex;
wire pipe3_valid;
wire [5:0] pipe3_ex;
wire pipe4_valid;
wire [5:0] pipe4_ex;
wire allow_from_reg_1_2;
wire [31:0] pipe1_inst;
pipe1 pipe1(
    .clock         (clock),
    .reset         (reset),
    .valid_in      (pipe0_valid),
    .valid_out     (pipe1_valid), 
    .allow_out     (allow_from_reg_1_2), 
    .nextpc_en     (nextpc_en), 
    .pc            (nextpc), 
    .inst_ram_inst (inst_ram_inst), 
    .ex_out        (pipe1_ex), 
    .pc_out        (pipe1_pc), 
    .inst_out      (pipe1_inst),
    .pipe4_valid   (pipe4_valid),
    .pipe4_ex      (pipe4_ex),
    .pipe3_valid   (pipe3_valid),
    .pipe3_ex      (pipe3_ex),
    .pipe2_valid   (pipe2_valid),
    .pipe2_ex      (pipe2_ex),
    .pipe1_valid   (pipe1_valid),
    .pipe1_ex      (pipe1_ex)
);

wire pipe2_is_bd_save;
wire allow_from_pipe2;
wire valid_to_pipe2;
wire pipe2_is_bd_load;
wire [5:0] ex_to_pipe2;
wire [31:0] pc_to_pipe2;
wire [31:0] inst_to_pipe2;
reg_1_2 reg_1_2(
    .clock            (clock), 
    .reset            (reset), 
    .valid            (pipe1_valid), 
    .is_bd            (pipe2_is_bd_save), 
    .ex               (pipe1_ex), 
    .pc               (pipe1_pc), 
    .inst             (pipe1_inst), 
    .allow_in         (allow_from_pipe2), 
    .allow_out        (allow_from_reg_1_2), 
    .valid_reg        (valid_to_pipe2), 
    .is_bd_reg        (pipe2_is_bd_load), 
    .ex_reg           (ex_to_pipe2), 
    .pc_reg           (pc_to_pipe2), 
    .inst_reg         (inst_to_pipe2), 
    .pipe5_valid      (pipe5_valid), 
    .pipe5_ex         (pipe5_ex), 
    .pipe4_valid      (pipe4_valid), 
    .pipe4_ex         (pipe4_ex), 
    .pipe3_valid      (pipe3_valid), 
    .pipe3_ex         (pipe3_ex), 
    .pipe2_valid      (pipe2_valid), 
    .pipe2_ex         (pipe2_ex),
    .inst_ERET        (inst_ERET)
    );

wire allow_from_reg_2_3;
wire [31:0] mem_value;
wire [31:0] wb_value;
wire [31:0] regfile_data;
wire regfile_we;
wire [4:0] pipe5_dest;
wire [4:0] pipe4_dest;
wire [4:0] pipe3_dest;
wire [31:0] vsrc2;
wire [15:0] imm;
wire [31:0] pipe2_pc;
wire [4:0] pipe2_dest;
wire [31:0] pipe2_ctrl_info;
wire [31:0] pipe2_ctrl_info2;
wire pipe3_finish;
wire pipe4_finish;
wire pipe5_finish;
wire pipe3_load_op;
wire pipe4_load_op;
pipe2 pipe2(
    .clock              (clock), 
    .reset              (reset), 
    .valid              (valid_to_pipe2), 
    .valid_out          (pipe2_valid), 
    .allow_out          (allow_from_reg_2_3), 
    .allow_in           (allow_from_pipe2), 
    .inst               (inst_to_pipe2), 
    .data_exec          (mem_value), 
    .data_mem           (wb_value), 
    .data_wb            (regfile_data), 
    .pc                 (pc_to_pipe2), 
    .ex                 (ex_to_pipe2), 
    .regfile_we         (regfile_we), 
    .regfile_waddr      (pipe5_dest), 
    .regfile_wdata      (regfile_data), 
    .is_bd_load         (pipe2_is_bd_load), 
    .dest_exec          (pipe3_dest), 
    .dest_mem           (pipe4_dest), 
    .dest_wb            (pipe5_dest), 
    .vsrc1              (vsrc1), 
    .vsrc2              (vsrc2), 
    .imm                (imm), 
    .ex_out             (pipe2_ex), 
    .pc_out             (pipe2_pc), 
    .dest_out           (pipe2_dest), 
    .ctrl_info_out      (pipe2_ctrl_info), 
    .ctrl_info2_out     (pipe2_ctrl_info2), 
    .is_bd_save         (pipe2_is_bd_save), 
    .branch_offset      (branch_offset), 
    .jump_target        (jump_target), 
    .br_taken           (br_taken), 
    .j_taken            (j_taken), 
    .jr_taken           (jr_taken), 
    .pipe3_valid        (pipe3_valid), 
    .pipe3_finish       (pipe3_finish), 
    .pipe4_valid        (pipe4_valid), 
    .pipe4_finish       (pipe4_finish), 
    .pipe5_valid        (pipe5_valid), 
    .pipe5_finish       (pipe5_finish), 
    .rf_0               (rf_0), 
    .rf_1               (rf_1), 
    .rf_2               (rf_2), 
    .rf_3               (rf_3), 
    .rf_4               (rf_4), 
    .rf_5               (rf_5), 
    .rf_6               (rf_6), 
    .rf_7               (rf_7), 
    .rf_8               (rf_8), 
    .rf_9               (rf_9), 
    .rf_10              (rf_10), 
    .rf_11              (rf_11), 
    .rf_12              (rf_12), 
    .rf_13              (rf_13), 
    .rf_14              (rf_14), 
    .rf_15              (rf_15), 
    .rf_16              (rf_16), 
    .rf_17              (rf_17), 
    .rf_18              (rf_18), 
    .rf_19              (rf_19), 
    .rf_20              (rf_20), 
    .rf_21              (rf_21), 
    .rf_22              (rf_22), 
    .rf_23              (rf_23), 
    .rf_24              (rf_24), 
    .rf_25              (rf_25), 
    .rf_26              (rf_26), 
    .rf_27              (rf_27), 
    .rf_28              (rf_28), 
    .rf_29              (rf_29), 
    .rf_30              (rf_30), 
    .rf_31              (rf_31),
    .pipe3_load_op		(pipe3_load_op),
    .pipe4_load_op      (pipe4_load_op)
);

wire allow_from_pipe3;
wire valid_to_pipe3;
wire [5:0] ex_to_pipe3;
wire [31:0] pc_to_pipe3;
wire [4:0] dest_to_pipe3;
wire [31:0] ctrl_info_to_pipe3;
wire [31:0] ctrl_info2_to_pipe3;
wire [31:0] vsrc1_to_pipe3;
wire [31:0] vsrc2_to_pipe3;
wire [15:0] imm_to_pipe3;
reg_2_3 reg_2_3(
    .clock          (clock), 
    .reset          (reset), 
    .valid          (pipe2_valid), 
    .ex             (pipe2_ex), 
    .pc             (pipe2_pc), 
    .dest           (pipe2_dest), 
    .ctrl_info      (pipe2_ctrl_info), 
    .ctrl_info2     (pipe2_ctrl_info2), 
    .vsrc1          (vsrc1), 
    .vsrc2          (vsrc2), 
    .imm            (imm), 
    .allow_in       (allow_from_pipe3), 
    .allow_out      (allow_from_reg_2_3), 
    .valid_reg      (valid_to_pipe3), 
    .ex_reg         (ex_to_pipe3), 
    .pc_reg         (pc_to_pipe3), 
    .dest_reg       (dest_to_pipe3), 
    .ctrl_info_reg  (ctrl_info_to_pipe3), 
    .ctrl_info2_reg (ctrl_info2_to_pipe3), 
    .vsrc1_reg      (vsrc1_to_pipe3), 
    .vsrc2_reg      (vsrc2_to_pipe3), 
    .imm_reg        (imm_to_pipe3), 
    .pipe5_valid    (pipe5_valid), 
    .pipe5_ex       (pipe5_ex), 
    .pipe4_valid    (pipe4_valid), 
    .pipe4_ex       (pipe4_ex), 
    .pipe3_valid    (pipe3_valid), 
    .pipe3_ex       (pipe3_ex),
    .inst_ERET      (inst_ERET)
    );

wire allow_from_reg_3_4;
wire [31:0] pipe3_pc;
wire [31:0] pipe3_ctrl_info;
wire [31:0] pipe3_ctrl_info2;
wire [1:0] offset;
wire div_complete;
wire div_op;
pipe3 pipe3(
    .valid              (valid_to_pipe3), 
    .valid_out          (pipe3_valid), 
    .allow_out          (allow_from_reg_3_4), 
    .allow_in           (allow_from_pipe3), 
    .data_finish        (pipe3_finish), 
    .ex                 (ex_to_pipe3), 
    .pc                 (pc_to_pipe3), 
    .dest               (dest_to_pipe3), 
    .ctrl_info          (ctrl_info_to_pipe3), 
    .ctrl_info2         (ctrl_info2_to_pipe3), 
    .vsrc1              (vsrc1_to_pipe3), 
    .vsrc2              (vsrc2_to_pipe3), 
    .imm                (imm_to_pipe3), 
    .ex_out             (pipe3_ex), 
    .pc_out             (pipe3_pc), 
    .dest_out           (pipe3_dest), 
    .ctrl_info_out      (pipe3_ctrl_info), 
    .ctrl_info2_out     (pipe3_ctrl_info2), 
    .mem_value          (mem_value), 
    .offset             (offset), 
    .data_ram_addr      (data_ram_addr), 
    .data_ram_we        (data_ram_we), 
    .data_ram_din       (data_ram_din),
    .pipe3_load_op		(pipe3_load_op),
    .div_complete       (div_complete),
    .div_op             (div_op)
);

wire resetn;
assign resetn = ~reset;
wire mul_div_signed = ~ctrl_info_to_pipe3[25];
wire [63:0] mul_result;
mul mul(
	.mul_clk			(clock),
	.resetn				(resetn),
	.mul_signed			(mul_div_signed),
	.x					(vsrc1_to_pipe3),
	.y					(vsrc2_to_pipe3),
	.result				(mul_result)
);

wire [31:0] div_quotient;
wire [31:0] div_remainder;
div div(
	.div_clk			(clock),
	.resetn				(resetn),
	.div				(div_op),
	.div_signed			(mul_div_signed),
	.x					(vsrc1_to_pipe3),
	.y					(vsrc2_to_pipe3),
	.s					(div_quotient),
	.r					(div_remainder),
	.complete			(div_complete),
	.pipe3_valid		(valid_to_pipe3)
);

wire allow_from_pipe4;
wire valid_to_pipe4;
wire [5:0] ex_to_pipe4;
wire [31:0] pc_to_pipe4;
wire [4:0] dest_to_pipe4;
wire [31:0] ctrl_info_to_pipe4;
wire [31:0] ctrl_info2_to_pipe4;
wire [31:0] mem_value_to_pipe4;
wire [1:0] offset_to_pipe4;
wire div_complete_to_pipe4;
wire [31:0] div_quotient_to_pipe4;
wire [31:0] div_remainder_to_pipe4;
reg_3_4 reg_3_4(
    .clock          (clock), 
    .reset          (reset), 
    .valid          (pipe3_valid), 
    .ex             (pipe3_ex), 
    .pc             (pipe3_pc), 
    .dest           (pipe3_dest), 
    .ctrl_info      (pipe3_ctrl_info), 
    .ctrl_info2     (pipe3_ctrl_info2), 
    .mem_value      (mem_value), 
    .offset         (offset), 
    .allow_in       (allow_from_pipe4), 
    .allow_out      (allow_from_reg_3_4), 
    .valid_reg      (valid_to_pipe4), 
    .ex_reg         (ex_to_pipe4), 
    .pc_reg         (pc_to_pipe4), 
    .dest_reg       (dest_to_pipe4), 
    .ctrl_info_reg  (ctrl_info_to_pipe4), 
    .ctrl_info2_reg (ctrl_info2_to_pipe4), 
    .mem_value_reg  (mem_value_to_pipe4), 
    .offset_reg     (offset_to_pipe4), 
    .pipe5_valid    (pipe5_valid), 
    .pipe5_ex       (pipe5_ex), 
    .pipe4_valid    (pipe4_valid), 
    .pipe4_ex       (pipe4_ex),
    .inst_ERET      (inst_ERET),
    .div_complete   (div_complete),
    .div_quotient   (div_quotient),
    .div_remainder  (div_remainder),
    .div_complete_reg (div_complete_to_pipe4),
    .div_quotient_reg (div_quotient_to_pipe4),
    .div_remainder_reg (div_remainder_to_pipe4)
    );

wire allow_from_reg_4_5;
wire [31:0] pipe4_pc;
wire [31:0] pipe4_ctrl_info;
wire [31:0] pipe4_ctrl_info2;
wire pipe4_div_complete;
wire [31:0] pipe4_div_quotient;
wire [31:0] pipe4_div_remainder;
pipe4 pipe4(
    .valid          (valid_to_pipe4), 
    .valid_out      (pipe4_valid), 
    .allow_in       (allow_from_pipe4), 
    .allow_out      (allow_from_reg_4_5), 
    .data_finish    (pipe4_finish), 
    .ex             (ex_to_pipe4), 
    .pc             (pc_to_pipe4), 
    .dest           (dest_to_pipe4), 
    .ctrl_info      (ctrl_info_to_pipe4), 
    .ctrl_info2     (ctrl_info2_to_pipe4), 
    .mem_value      (mem_value_to_pipe4), 
    .offset         (offset_to_pipe4), 
    .data           (data_ram_data), 
    .ex_out         (pipe4_ex), 
    .pc_out         (pipe4_pc), 
    .dest_out       (pipe4_dest), 
    .ctrl_info_out  (pipe4_ctrl_info), 
    .ctrl_info2_out (pipe4_ctrl_info2), 
    .wb_value       (wb_value), 
    .pipe5_ex       (pipe5_ex),
    .pipe4_load_op  (pipe4_load_op),
    .div_complete   (div_complete_to_pipe4),
    .div_quotient   (div_quotient_to_pipe4),
    .div_remainder  (div_remainder_to_pipe4),
    .div_complete_out (pipe4_div_complete),
    .div_quotient_out (pipe4_div_quotient),
    .div_remainder_out (pipe4_div_remainder)
    );

wire allow_from_pipe5;
wire valid_to_pipe5;
wire [5:0] ex_to_pipe5;
wire [31:0] pc_to_pipe5;
wire [4:0] dest_to_pipe5;
wire [31:0] ctrl_info_to_pipe5;
wire [31:0] ctrl_info2_to_pipe5;
wire [31:0] wb_value_to_pipe5;
wire [31:0] hi_to_pipe5;
wire [31:0] low_to_pipe5;
reg_4_5 reg_4_5(
    .clock              (clock), 
    .reset              (reset), 
    .valid              (pipe4_valid), 
    .ex                 (pipe4_ex), 
    .pc                 (pipe4_pc), 
    .dest               (pipe4_dest), 
    .ctrl_info          (pipe4_ctrl_info), 
    .ctrl_info2         (pipe4_ctrl_info2), 
    .wb_value           (wb_value), 
    .allow_in           (allow_from_pipe5), 
    .allow_out          (allow_from_reg_4_5), 
    .valid_reg          (valid_to_pipe5), 
    .ex_reg             (ex_to_pipe5), 
    .pc_reg             (pc_to_pipe5), 
    .dest_reg           (dest_to_pipe5), 
    .ctrl_info_reg      (ctrl_info_to_pipe5), 
    .ctrl_info2_reg     (ctrl_info2_to_pipe5), 
    .wb_value_reg       (wb_value_to_pipe5), 
    .pipe5_valid        (pipe5_valid), 
    .pipe5_ex           (pipe5_ex),
    .inst_ERET          (inst_ERET),
    .mul_hi				(mul_result[63:32]),
    .mul_low			(mul_result[31:0]),
    .div_hi				(pipe4_div_remainder),
    .div_low			(pipe4_div_quotient),
    .div_complete		(pipe4_div_complete),
    .hi_reg				(hi_to_pipe5),
    .low_reg			(low_to_pipe5)
    );

pipe5 pipe5(
    .clock              (clock), 
    .reset              (reset), 
    .valid              (valid_to_pipe5), 
    .valid_out          (pipe5_valid), 
    .allow_in           (allow_from_pipe5), 
    .data_finish        (pipe5_finish), 
    .ex                 (ex_to_pipe5), 
    .pc                 (pc_to_pipe5), 
    .dest               (dest_to_pipe5), 
    .ctrl_info          (ctrl_info_to_pipe5), 
    .ctrl_info2         (ctrl_info2_to_pipe5), 
    .wb_value           (wb_value_to_pipe5), 
    .ex_out             (pipe5_ex), 
    .dest_out           (pipe5_dest), 
    .regfile_we         (regfile_we), 
    .regfile_data       (regfile_data), 
    .inst_ERET          (inst_ERET), 
    .cp0_value_out      (cp0_value),
    .hi					(hi_to_pipe5),
    .low				(low_to_pipe5)
    );

endmodule
