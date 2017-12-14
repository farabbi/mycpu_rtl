module reg_1_2
(
    input  wire        clock,
    input  wire        reset,

    input  wire        valid,
    input  wire        is_bd,
    input  wire [ 5:0] ex,
    input  wire [31:0] pc,
    input  wire [31:0] inst,

    input  wire        allow_in,

    output wire        allow_out,

    output reg         valid_reg,
    output reg         is_bd_reg,
    output reg  [ 5:0] ex_reg,
    output reg  [31:0] pc_reg,
    output reg  [31:0] inst_reg,
    
    input  wire [ 5:0] pipe5_ex,
    input  wire        pipe5_valid,
    input  wire [ 5:0] pipe4_ex,
    input  wire        pipe4_valid,
    input  wire [ 5:0] pipe3_ex,
    input  wire        pipe3_valid,
    input  wire [ 5:0] pipe2_ex,
    input  wire        pipe2_valid,
    input  wire        inst_ERET
);

always @(posedge clock)
begin
    if (reset)
    begin
        valid_reg <= 1'b0;
    end
    else if (allow_in)
    begin
        valid_reg <= valid & ~((|pipe5_ex) & pipe5_valid) & ~((|pipe4_ex) & pipe4_valid) & ~((|pipe3_ex) & pipe3_valid) & ~((|pipe2_ex) & pipe2_valid) & ~inst_ERET;
    end
end

always @(posedge clock)
begin
    if (reset)
    begin
        is_bd_reg <= 1'b0;
        ex_reg <= 6'b0;
        pc_reg <= 32'b0;
        inst_reg <= 32'b0;
    end
    else if (allow_in)
    begin
        is_bd_reg <= is_bd;
        ex_reg <= ex;
        pc_reg <= pc;
        inst_reg <= inst;
    end
end

assign allow_out = allow_in;

endmodule
