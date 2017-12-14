module logic
(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [ 4:0] type,
    output wire [31:0] res
);

wire [31:0] res_and;
wire [31:0] res_or;
wire [31:0] res_xor;
wire [31:0] res_nor;
wire [31:0] res_lui;

assign res_and = a & b;
assign res_or = a | b;
assign res_xor = a ^ b;
assign res_nor = ~(a | b);
assign res_lui = {b[15:0], 16'b0};

assign res = {32{type[0]}} & res_and
           | {32{type[1]}} & res_or
           | {32{type[2]}} & res_xor
           | {32{type[3]}} & res_nor
           | {32{type[4]}} & res_lui;

endmodule
