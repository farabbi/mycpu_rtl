module nextpc
(
    input  wire [31:0] pc,
    input  wire        nextpc_en,
    input  wire [31:0] branch_offset,
    input  wire        br_taken,
    input  wire [25:0] jump_target,
    input  wire        j_taken,
    input  wire [31:0] vsrc1,
    input  wire        jr_taken,
    input  wire [31:0] ex_addr,
    input  wire        ex_signal,
    output wire [31:0] nextpc
);

wire [31:0] wire1;
wire [31:0] wire2;
wire [31:0] wire3;
wire [31:0] wire4;
wire [31:0] wire5;
assign nextpc = ex_signal ? ex_addr : wire1;
assign wire1 = jr_taken ? vsrc1 : wire2;
assign wire2 = j_taken ? {pc[31:28], jump_target, 2'b0} : wire3;
assign wire3 = pc + wire4;
assign wire4 = br_taken ? branch_offset : wire5;
assign wire5 = nextpc_en ? 32'd4 : 32'd0;

endmodule
