module except_addr_signal
(
    input  wire        clock,
    input  wire        reset,
    input  wire [ 5:0] ex,
    output wire [31:0] ex_addr,
    output wire        ex_signal,

    input  wire        inst_ERET,
    input  wire [31:0] cp0_value,
    input  wire        pipe5_valid
);

wire rst;
wire rst_before_clk;
wire rst_after_clk;
assign rst = rst_before_clk & ~rst_after_clk;
dflop dflop1(.clock(clock), .D(reset), .Q(rst_after_clk));
dflop dflop2(.clock(clock), .D(rst_after_clk), .Q(rst_before_clk));

wire ex_sgn;
wire [31:0] ex_addr_except_rst;
assign ex_addr = rst ? 32'hbfc00000 : ex_addr_except_rst;
assign ex_addr_except_rst = inst_ERET ? cp0_value : 32'hbfc00380;
assign ex_signal = rst ? 1'b1 : ex_sgn;
assign ex_sgn = ((|ex) | inst_ERET) & pipe5_valid ? 1'b1 : 1'b0;

endmodule
