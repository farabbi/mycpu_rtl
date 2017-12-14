module reg_3_4
(
    input  wire        clock,
    input  wire        reset,

    input  wire        valid,
    input  wire [ 5:0] ex,
    input  wire [31:0] pc,
    input  wire [ 4:0] dest,
    input  wire [31:0] ctrl_info,
    input  wire [31:0] ctrl_info2,
    input  wire [31:0] mem_value,
    input  wire [ 1:0] offset,

    input  wire        allow_in,

    output wire        allow_out,

    output reg         valid_reg,
    output reg  [ 5:0] ex_reg,
    output reg  [31:0] pc_reg,
    output reg  [ 4:0] dest_reg,
    output reg  [31:0] ctrl_info_reg,
    output reg  [31:0] ctrl_info2_reg,
    output reg  [31:0] mem_value_reg,
    output reg  [ 1:0] offset_reg,
    
    input  wire [ 5:0] pipe5_ex,
    input  wire        pipe5_valid,
    input  wire [ 5:0] pipe4_ex,
    input  wire        pipe4_valid,
    input  wire        inst_ERET,
    
    input  wire [31:0] div_quotient,
    input  wire [31:0] div_remainder,
    input  wire        div_complete,
    output reg  [31:0] div_quotient_reg,
    output reg  [31:0] div_remainder_reg,
    output reg         div_complete_reg
);

always @(posedge clock)
begin
    if (reset)
    begin
        div_quotient_reg <= 32'b0;
        div_remainder_reg <= 32'b0;
        div_complete_reg <= 32'b0;
    end
    else if (allow_in)
    begin
    	div_quotient_reg <= div_quotient;
    	div_remainder_reg <= div_remainder;
    	div_complete_reg <= div_complete;
    end
end

always @(posedge clock)
begin
    if (reset)
    begin
        valid_reg <= 1'b0;
    end
    else if (allow_in)
    begin
        valid_reg <= valid & ~((|pipe5_ex) & pipe5_valid) & ~((|pipe4_ex) & pipe4_valid) & ~inst_ERET;
    end
end

always @(posedge clock)
begin
    if (reset)
    begin
        ex_reg <= 6'b0;
        pc_reg <= 32'b0;
        dest_reg <= 5'b0;
        ctrl_info_reg <= 32'b0;
        ctrl_info2_reg <= 32'b0;
        mem_value_reg <= 32'b0;
        offset_reg <= 2'b0;
    end
    else if (allow_in)
    begin
        ex_reg <= ex;
        pc_reg <= pc;
        dest_reg <= dest;
        ctrl_info_reg <= ctrl_info;
        ctrl_info2_reg <= ctrl_info2;
        mem_value_reg <= mem_value;
        offset_reg <= offset;
    end
end

assign allow_out = allow_in;

endmodule
