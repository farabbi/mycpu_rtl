module reg_2_3
(
    input  wire        clock,
    input  wire        reset,

    input  wire        valid,
    input  wire [ 5:0] ex,
    input  wire [31:0] pc,
    input  wire [ 4:0] dest,
    input  wire [31:0] ctrl_info,
    input  wire [31:0] ctrl_info2,
    input  wire [31:0] vsrc1,
    input  wire [31:0] vsrc2,
    input  wire [15:0] imm,

    input  wire        allow_in,

    output wire        allow_out,

    output reg         valid_reg,
    output reg  [ 5:0] ex_reg,
    output reg  [31:0] pc_reg,
    output reg  [ 4:0] dest_reg,
    output reg  [31:0] ctrl_info_reg,
    output reg  [31:0] ctrl_info2_reg,
    output reg  [31:0] vsrc1_reg,
    output reg  [31:0] vsrc2_reg,
    output reg  [15:0] imm_reg,
    
    input  wire [ 5:0] pipe5_ex,
    input  wire        pipe5_valid,
    input  wire [ 5:0] pipe4_ex,
    input  wire        pipe4_valid,
    input  wire [ 5:0] pipe3_ex,
    input  wire        pipe3_valid,
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
        valid_reg <= valid & ~((|pipe5_ex) & pipe5_valid) & ~((|pipe4_ex) & pipe4_valid) & ~((|pipe3_ex) & pipe3_valid) & ~inst_ERET;
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
        vsrc1_reg <= 32'b0;
        vsrc2_reg <= 32'b0;
        imm_reg <= 16'b0;
    end
    else if (allow_in)
    begin
        ex_reg <= ex;
        pc_reg <= pc;
        dest_reg <= dest;
        ctrl_info_reg <= ctrl_info;
        ctrl_info2_reg <= ctrl_info2;
        vsrc1_reg <= vsrc1;
        vsrc2_reg <= vsrc2;
        imm_reg <= imm;
    end
end

assign allow_out = allow_in;

endmodule
