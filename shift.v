module shift
(
    input  wire [31:0] x,
    input  wire [ 4:0] shamt,
    input  wire [ 2:0] type,
    output wire [31:0] y
);

wire [31:0] result [31:0];
wire [31:0] shamt_d;

generate
genvar i;
    for (i=0; i<32; i=i+1)
    begin: gen_result
        assign result[i] = {32{type[0]}} & {x[31-i:0], {i{1'b0}}}
                         | {32{type[1]}} & {{i{1'b0}}, x[31:i]}
                         | {32{type[2]}} & {{i{x[31]}}, x[31:i]};
    end //block gen_result
endgenerate

generate
    for (i=0; i<32; i=i+1)
    begin: gen_shamt_dec
        assign shamt_d[i] = (shamt == i);
    end //block gen_shamt_dec
endgenerate

wire [31:0] wire11;
wire [31:0] wire12;
wire [31:0] wire13;
wire [31:0] wire14;
wire [31:0] wire15;
wire [31:0] wire16;
wire [31:0] wire17;
wire [31:0] wire18;
wire [31:0] wire21;
wire [31:0] wire22;

assign wire11 = {32{shamt_d[ 0]}} & result[ 0]
              | {32{shamt_d[ 1]}} & result[ 1]
              | {32{shamt_d[ 2]}} & result[ 2]
              | {32{shamt_d[ 3]}} & result[ 3];

assign wire12 = {32{shamt_d[ 4]}} & result[ 4]
              | {32{shamt_d[ 5]}} & result[ 5]
              | {32{shamt_d[ 6]}} & result[ 6]
              | {32{shamt_d[ 7]}} & result[ 7];

assign wire13 = {32{shamt_d[ 8]}} & result[ 8]
              | {32{shamt_d[ 9]}} & result[ 9]
              | {32{shamt_d[10]}} & result[10]
              | {32{shamt_d[11]}} & result[11];

assign wire14 = {32{shamt_d[12]}} & result[12]
              | {32{shamt_d[13]}} & result[13]
              | {32{shamt_d[14]}} & result[14]
              | {32{shamt_d[15]}} & result[15];

assign wire15 = {32{shamt_d[16]}} & result[16]
              | {32{shamt_d[17]}} & result[17]
              | {32{shamt_d[18]}} & result[18]
              | {32{shamt_d[19]}} & result[19];

assign wire16 = {32{shamt_d[20]}} & result[20]
              | {32{shamt_d[21]}} & result[21]
              | {32{shamt_d[22]}} & result[22]
              | {32{shamt_d[23]}} & result[23];

assign wire17 = {32{shamt_d[24]}} & result[24]
              | {32{shamt_d[25]}} & result[25]
              | {32{shamt_d[26]}} & result[26]
              | {32{shamt_d[27]}} & result[27];

assign wire18 = {32{shamt_d[28]}} & result[28]
              | {32{shamt_d[29]}} & result[29]
              | {32{shamt_d[30]}} & result[30]
              | {32{shamt_d[31]}} & result[31];

assign wire21 = wire11 | wire12 | wire13 | wire14;
assign wire22 = wire15 | wire16 | wire17 | wire18;
assign y = wire21 | wire22;

endmodule
