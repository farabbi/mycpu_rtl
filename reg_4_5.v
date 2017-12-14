module reg_4_5
(
    input  wire        clock,
    input  wire        reset,

    input  wire        valid,
    input  wire [ 5:0] ex,
    input  wire [31:0] pc,
    input  wire [ 4:0] dest,
    input  wire [31:0] ctrl_info,
    input  wire [31:0] ctrl_info2,
    input  wire [31:0] wb_value,

    input  wire        allow_in,

    output wire        allow_out,

    output reg         valid_reg,
    output reg  [ 5:0] ex_reg,
    output reg  [31:0] pc_reg,
    output reg  [ 4:0] dest_reg,
    output reg  [31:0] ctrl_info_reg,
    output reg  [31:0] ctrl_info2_reg,
    output reg  [31:0] wb_value_reg,
    
    input  wire        pipe5_valid,
    input  wire [ 5:0] pipe5_ex,
    input  wire        inst_ERET,
    
    input  wire [31:0] mul_hi,
    input  wire [31:0] mul_low,
    input  wire [31:0] div_hi,
    input  wire [31:0] div_low,
    input  wire        div_complete,
    output reg  [31:0] hi_reg,
    output reg  [31:0] low_reg
);

always @(posedge clock)
begin
    if (reset)
    begin
        hi_reg <= 0;
    end
    else if (div_complete)
    begin
        hi_reg <= div_hi;
    end
    else
    begin
        hi_reg <= mul_hi;
    end
end

always @(posedge clock)
begin
    if (reset)
    begin
        low_reg <= 0;
    end
    else if (div_complete)
    begin
        low_reg <= div_low;
    end
    else
    begin
        low_reg <= mul_low;
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
        valid_reg <= valid & ~((|pipe5_ex) & pipe5_valid) & ~inst_ERET;
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
        wb_value_reg <= 32'b0;
    end
    else if (allow_in)
    begin
        ex_reg <= ex;
        pc_reg <= pc;
        dest_reg <= dest;
        ctrl_info_reg <= ctrl_info;
        ctrl_info2_reg <= ctrl_info2;
        wb_value_reg <= wb_value;
    end
end

assign allow_out = allow_in;

endmodule
