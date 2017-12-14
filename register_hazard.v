module register_hazard
(
    input  wire       pipe3_valid,
    input  wire       pipe3_finish,
    input  wire       pipe4_valid,
    input  wire       pipe4_finish,
    input  wire       pipe5_valid,
    input  wire       pipe5_finish,
    input  wire [4:0] dest_exec,
    input  wire [4:0] dest_mem,
    input  wire [4:0] dest_wb,
    input  wire [4:0] rs,
    input  wire [4:0] rt,
    output wire [1:0] rs_sel,
    output wire [1:0] rt_sel
);

wire [1:0] rs_temp1;
wire [1:0] rs_temp2;
wire [1:0] rs_temp3;
assign rs_temp1 = (rs==dest_wb && pipe5_valid && pipe5_finish) ? 2'b01 : 2'b00;
assign rs_temp2 = (rs==dest_mem && pipe4_valid && pipe4_finish) ? 2'b10 : rs_temp1;
assign rs_temp3 = (rs==dest_exec && pipe3_valid && pipe3_finish) ? 2'b11 : rs_temp2;
assign rs_sel = rs==5'b0 ? 2'b00 : rs_temp3;

wire [1:0] rt_temp1;
wire [1:0] rt_temp2;
wire [1:0] rt_temp3;
assign rt_temp1 = (rt==dest_wb && pipe5_valid && pipe5_finish) ? 2'b01 : 2'b00;
assign rt_temp2 = (rt==dest_mem && pipe4_valid && pipe4_finish) ? 2'b10 : rt_temp1;
assign rt_temp3 = (rt==dest_exec && pipe3_valid && pipe3_finish) ? 2'b11 : rt_temp2;
assign rt_sel = rt==5'b0 ? 2'b00 : rt_temp3;

endmodule
