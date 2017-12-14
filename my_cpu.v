module my_cpu
(
    input         resetn, 
    input         clk,

    //display data
	output        wb_valid,
	output [31:0] wb_pc,
    output [31:0] rf_0,
    output [31:0] rf_1,
    output [31:0] rf_2,
    output [31:0] rf_3,
    output [31:0] rf_4,
    output [31:0] rf_5,
    output [31:0] rf_6,
    output [31:0] rf_7,
    output [31:0] rf_8,
    output [31:0] rf_9,
    output [31:0] rf_10,
    output [31:0] rf_11,
    output [31:0] rf_12,
    output [31:0] rf_13,
    output [31:0] rf_14,
    output [31:0] rf_15,
    output [31:0] rf_16,
    output [31:0] rf_17,
    output [31:0] rf_18,
    output [31:0] rf_19,
    output [31:0] rf_20,
    output [31:0] rf_21,
    output [31:0] rf_22,
    output [31:0] rf_23,
    output [31:0] rf_24,
    output [31:0] rf_25,
    output [31:0] rf_26,
    output [31:0] rf_27,
    output [31:0] rf_28,
    output [31:0] rf_29,
    output [31:0] rf_30,
    output [31:0] rf_31
);

wire [31:0] inst_ram_inst;
wire [31:0] data_ram_data;
wire [31:0] inst_ram_addr;
wire [ 3:0] inst_ram_we;
wire [31:0] inst_ram_din;
wire [31:0] data_ram_addr;
wire [ 3:0] data_ram_we;
wire [31:0] data_ram_din;

wire reset;
assign reset = ~resetn;
cpu cpu(.clock(clk), .reset(reset), .inst_ram_inst(inst_ram_inst), .data_ram_data(data_ram_data), .inst_ram_addr(inst_ram_addr), .inst_ram_we(inst_ram_we), .inst_ram_din(inst_ram_din), .data_ram_addr(data_ram_addr), .data_ram_we(data_ram_we), .data_ram_din(data_ram_din), .wb_valid(wb_valid), .wb_pc(wb_pc), .rf_0(rf_0), .rf_1(rf_1), .rf_2(rf_2), .rf_3(rf_3), .rf_4(rf_4), .rf_5(rf_5), .rf_6(rf_6), .rf_7(rf_7), .rf_8(rf_8), .rf_9(rf_9), .rf_10(rf_10), .rf_11(rf_11), .rf_12(rf_12), .rf_13(rf_13), .rf_14(rf_14), .rf_15(rf_15), .rf_16(rf_16), .rf_17(rf_17), .rf_18(rf_18), .rf_19(rf_19), .rf_20(rf_20), .rf_21(rf_21), .rf_22(rf_22), .rf_23(rf_23), .rf_24(rf_24), .rf_25(rf_25), .rf_26(rf_26), .rf_27(rf_27), .rf_28(rf_28), .rf_29(rf_29), .rf_30(rf_30), .rf_31(rf_31));

wire inst_ram_wea;
assign inst_ram_wea = |inst_ram_we;
//inst sram
parameter INST_INIT_FILE = "none";
inst_ram #(.INST_INIT_FILE(INST_INIT_FILE)) inst_ram(
    .clka (clk                              ),
    .wea  (inst_ram_wea                     ),
    .addra(inst_ram_addr[15:2]              ),
    .dina (inst_ram_din                     ),
    .douta(inst_ram_inst                    )
);

//data sram
data_ram data_ram(
    .clka (clk                              ),
    .wea  (data_ram_we                      ),
    .addra(data_ram_addr[15:2]              ),
    .dina (data_ram_din                     ),
    .douta(data_ram_data                    )
);

endmodule
