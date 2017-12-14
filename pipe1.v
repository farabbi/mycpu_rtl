module pipe1
(
    input  wire        clock,
    input  wire        reset,

    input  wire        valid_in,
    output wire        valid_out,

    input  wire        allow_out,
    output wire        nextpc_en,

    input  wire [31:0] pc,
    input  wire [31:0] inst_ram_inst,
    output wire [ 5:0] ex_out,
    output wire [31:0] pc_out,
    output wire [31:0] inst_out,

    input  wire [ 5:0] pipe4_ex,
    input  wire        pipe4_valid,
    input  wire [ 5:0] pipe3_ex,
    input  wire        pipe3_valid,
    input  wire [ 5:0] pipe2_ex,
    input  wire        pipe2_valid,
    input  wire [ 5:0] pipe1_ex,
    input  wire        pipe1_valid
);

reg [31:0] pc_reg;
reg valid_reg;

assign inst_out = inst_ram_inst;
assign pc_out = pc_reg;

always @(posedge clock)
begin
    if (reset)
    begin
        pc_reg <= 32'b0;
    end
    else
    begin
        pc_reg <= pc;
    end
end

wire fetch_adel;
fetch_adel fetch_adel1(
    .pc_offset  (pc_reg[1:0]),
    .fetch_adel (fetch_adel)
);

assign ex_out = {5'b0, fetch_adel};

assign nextpc_en = allow_out;

assign valid_out = valid_reg;

always @(posedge clock)
begin
    if (reset) begin
        valid_reg <= 1'b0;
    end
    else begin
        valid_reg <= valid_in & ~((|pipe4_ex) & pipe4_valid) & ~((|pipe3_ex) & pipe3_valid) & ~((|pipe2_ex) & pipe2_valid) & ~((|pipe1_ex) & pipe1_valid);
    end
end

endmodule
