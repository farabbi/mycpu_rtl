module pipe4
(
    input  wire        valid,
    output wire        valid_out,

    output wire        allow_in,
    input  wire        allow_out,

    output wire        data_finish,

    input  wire [ 5:0] ex,
    input  wire [31:0] pc,
    input  wire [ 4:0] dest,
    input  wire [31:0] ctrl_info,
    input  wire [31:0] ctrl_info2,
    input  wire [31:0] mem_value,
    input  wire [ 1:0] offset,
    input  wire [31:0] data,

    output wire [ 5:0] ex_out,
    output wire [31:0] pc_out,
    output wire [ 4:0] dest_out,
    output wire [31:0] ctrl_info_out,
    output wire [31:0] ctrl_info2_out,
    output wire [31:0] wb_value,

    input  wire [ 5:0] pipe5_ex,
    
    output wire        pipe4_load_op,
    
    input  wire [31:0] div_quotient,
    input  wire [31:0] div_remainder,
    input  wire        div_complete,
    output wire [31:0] div_quotient_out,
    output wire [31:0] div_remainder_out,
    output wire        div_complete_out
);

assign div_quotient_out = div_quotient;
assign div_remainder_out = div_remainder;
assign div_complete_out = div_complete;

wire inst_MFC0;
wire inst_MFHI;
wire inst_MFLO;
assign inst_MFC0 = ctrl_info2[8];
assign inst_MFHI = ctrl_info2[11];
assign inst_MFLO = ctrl_info2[10];

assign pipe4_load_op = inst_MFC0 | inst_MFHI | inst_MFLO;

assign valid_out = valid;

assign allow_in = !valid || valid_out && allow_out;

wire reg_we;
assign reg_we = ctrl_info[27];
assign data_finish = reg_we;

assign ex_out = ex;
assign pc_out = pc;
assign dest_out = dest;
assign ctrl_info_out = ctrl_info;
assign ctrl_info2_out = ctrl_info2;

wire [4:0] load_type;
wire       load_op;
assign load_type = ctrl_info[10:6];
assign load_op = ctrl_info[11];

wire [31:0] load_result;
assign wb_value = ~(|ex) & load_op ? load_result : mem_value;

load load(
    .type   (load_type), 
    .offset (offset), 
    .data   (data), 
    .result (load_result)
    );

endmodule
