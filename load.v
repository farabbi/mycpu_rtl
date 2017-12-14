module load
(
    input  wire [ 4:0] type,
    input  wire [ 1:0] offset,
    input  wire [31:0] data,
    output wire [31:0] result
);

wire [ 7:0] lb_data;
wire [15:0] lh_data;
wire [31:0] lw_data;
wire [ 3:0] lb_data_sel;
wire [ 1:0] lh_data_sel;
assign lb_data_sel[0] = offset==2'b00;
assign lb_data_sel[1] = offset==2'b01;
assign lb_data_sel[2] = offset==2'b10;
assign lb_data_sel[3] = offset==2'b11;
assign lb_data = {8{lb_data_sel[0]}} & data[7:0]
               | {8{lb_data_sel[1]}} & data[15:8]
               | {8{lb_data_sel[2]}} & data[23:16]
               | {8{lb_data_sel[3]}} & data[31:24];
assign lh_data_sel[0] = offset==2'b00;
assign lh_data_sel[1] = offset==2'b10;
assign lh_data = {16{lh_data_sel[0]}} & data[15:0]
               | {16{lh_data_sel[1]}} & data[31:16];
assign lw_data = data;
assign result = {32{type[0]}} & {{24{lb_data[7]}}, lb_data}
              | {32{type[1]}} & {{24{1'b0}}, lb_data}
              | {32{type[2]}} & {{16{lh_data[15]}}, lh_data}
              | {32{type[3]}} & {{16{1'b0}}, lh_data}
              | {32{type[4]}} & lw_data;

endmodule
