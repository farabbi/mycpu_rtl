module pipe0
(
    input  wire        clock,
    input  wire        reset,

    output wire        valid_out,

    input  wire [31:0] pc,
    input  wire        nextpc_en,
    input  wire        br_taken,
    input  wire [31:0] branch_offset,
    input  wire        j_taken,
    input  wire [25:0] jump_target,
    input  wire        jr_taken,
    input  wire [31:0] vsrc1,
    input  wire [ 5:0] ex,
    output wire [31:0] nextpc,
    output wire [31:0] inst_ram_addr,
    output wire [ 3:0] inst_ram_we,
    output wire [31:0] inst_ram_din,

    input  wire        inst_ERET,
    input  wire [31:0] cp0_value,
    input  wire        pipe5_valid
);

assign inst_ram_din = 32'b0;
assign inst_ram_we = 4'b0;

wire [31:0] vaddr;
wire [31:0] paddr;
assign inst_ram_addr = paddr;
vaddr2paddr vaddr2paddr(
	.vaddr(vaddr), 
	.paddr(paddr)
	);

wire [31:0] ex_addr;
wire ex_signal;
except_addr_signal except_addr_signal(
	.clock		(clock), 
	.reset		(reset), 
	.ex			(ex), 
	.ex_addr	(ex_addr), 
	.ex_signal	(ex_signal), 
	.inst_ERET	(inst_ERET), 
	.cp0_value	(cp0_value), 
	.pipe5_valid(pipe5_valid)
	);

nextpc nextpc1(
	.pc				(pc), 
	.nextpc_en		(nextpc_en), 
	.branch_offset	(branch_offset), 
	.br_taken		(br_taken), 
	.jump_target	(jump_target), 
	.j_taken		(j_taken), 
	.vsrc1			(vsrc1), 
	.jr_taken		(jr_taken), 
	.ex_addr		(ex_addr), 
	.ex_signal		(ex_signal), 
	.nextpc			(vaddr)
	);

assign nextpc = vaddr;

reg valid_reg;
always @(posedge clock)
begin
    if (reset) begin
        valid_reg <= 1'b0;
    end
    else begin
        valid_reg <= 1'b1;
    end
end

assign valid_out = valid_reg;

endmodule
