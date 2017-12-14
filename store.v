module store
(
    input  wire [ 1:0] offset,
    input  wire [ 2:0] type,
    input  wire [31:0] value,
    output wire [ 3:0] wmask,
    output wire [31:0] wdata
);

assign wdata = {32{type[0]}} & {4{value[7:0]}}
             | {32{type[1]}} & {2{value[15:0]}}
             | {32{type[2]}} & value[31:0];

wire [3:0] sb_mask;
wire [3:0] sh_mask;
wire [3:0] sw_mask;

assign sb_mask[0] = offset==2'b00;
assign sb_mask[1] = offset==2'b01;
assign sb_mask[2] = offset==2'b10;
assign sb_mask[3] = offset==2'b11;

assign sh_mask[0] = offset==2'b00;
assign sh_mask[1] = offset==2'b00;
assign sh_mask[2] = offset==2'b10;
assign sh_mask[3] = offset==2'b10;

assign sw_mask[0] = offset==2'b00;
assign sw_mask[1] = offset==2'b00;
assign sw_mask[2] = offset==2'b00;
assign sw_mask[3] = offset==2'b00;

assign wmask = {4{type[0]}} & sb_mask
             | {4{type[1]}} & sh_mask
             | {4{type[2]}} & sw_mask;

endmodule
