module cp0_reg
(
    input  wire        clock,
    input  wire        reset,

    input  wire [ 5:0] ex,
    input  wire [31:0] epc_in,
    input  wire        is_bd,

    input  wire [ 4:0] cp0_reg,
    input  wire [ 2:0] cp0_sel,
    input  wire        we,
    input  wire [31:0] value,
    output wire [31:0] value_out,

    input  wire        inst_ERET,
    input  wire        valid
);

reg [31:0] count;
reg status_exl;
reg cause_bd;
reg [4:0] cause_exc_code;
reg [31:0] epc;

wire we_count;
wire we_status;
wire we_epc;
assign we_count = we & cp0_reg==5'd9 & cp0_sel==3'b0;
assign we_status = we & cp0_reg==5'd12 & cp0_sel==3'b0;
assign we_epc = we & cp0_reg==5'd14 & cp0_sel==3'b0; 

wire count_out;
wire status_out;
wire cause_out;
wire epc_out;
assign count_out = cp0_reg==5'd9 & cp0_sel==3'b0;
assign status_out = cp0_reg==5'd12 & cp0_sel==3'b0;
assign cause_out = cp0_reg==5'd13 & cp0_sel==3'b0;
assign epc_out = cp0_reg==5'd14 & cp0_sel==3'b0;
assign value_out = {32{count_out}} & count
                 | {32{status_out}} & {30'b0, status_exl, 1'b0}
                 | {32{cause_out}} & {cause_bd, 24'b0, cause_exc_code, 2'b0}
                 | {32{epc_out | inst_ERET}} & epc;

reg tick;
always @(posedge clock)
begin
    if (reset) begin
        tick <= 1'b0;
        count <= 32'b0;
    end
    else if (we_count) begin
        count <= value;
        tick <= 1'b1;
    end
    else begin
        if (tick) begin
            tick <= 1'b0;
            count <= count + 32'b1;
        end
        else begin
            tick <= 1'b1;
            count <= count;
        end
    end
end

always @(posedge clock)
begin
    if (reset)
    begin
        status_exl <= 1'b0;
    end
    else if (|ex & valid)
    begin
        status_exl <= 1'b1;
    end
    else if (inst_ERET & valid)
    begin
        status_exl <= 1'b0;
    end
    else
    begin
        status_exl <= we_status ? value[1] : status_exl;
    end
end

always @(posedge clock)
begin
    if (reset)
    begin
        cause_bd <= 1'b0;
        cause_exc_code <= 5'b0;
    end
    else if (|ex & valid)
    begin
        cause_bd <= is_bd;
        cause_exc_code <= {5{ex[0]}} & 5'h4
                        | {5{ex[1]}} & 5'h5
                        | {5{ex[2]}} & 5'h8
                        | {5{ex[3]}} & 5'h9
                        | {5{ex[4]}} & 5'ha
                        | {5{ex[5]}} & 5'hc;
    end
end

always @(posedge clock)
begin
    if (reset)
    begin
        epc <= 32'b0;
    end
    else if (|ex & valid)
    begin
        epc <= epc_in;
    end
    else
    begin
        epc <= we_epc ? value : epc;
    end
end

endmodule
