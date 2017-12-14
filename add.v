module add
(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);

assign sum = a + b + cin;
assign cout = (a[31]==1'b1 && b[31]==1'b1) | (a[31]==1'b1 && b[31]==1'b0 && sum[31]==1'b0) | (a[31]==1'b0 && b[31]==1'b1 & sum[31]==1'b0);

endmodule
