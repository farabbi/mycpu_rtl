module alu
(
    input  wire [31:0] vsrc1,
    input  wire [31:0] vsrc2,
    input  wire [15:0] imm,
    input  wire [31:0] pc,
    input  wire [ 3:0] alu_res_sel,
    input  wire [ 4:0] logic_type,
    input  wire [ 2:0] shift_type,
    input  wire        imm_op,
    input  wire        unsigned_op,
    input  wire        link_op,
    input  wire        do_sub,
    input  wire        store_op,
    input  wire [ 2:0] store_type,
    input  wire [ 4:0] load_type,
    output wire [31:0] res,
    output wire [ 1:0] offset,
    output wire [31:0] data_ram_addr,
    output wire [ 3:0] data_ram_we,
    output wire [31:0] data_ram_din,
    output wire        overflow,
    output wire        adel,
    output wire        ades,
    input  wire        overflow_op
);

wire [31:0] add_a;
wire [31:0] add_b;
wire [31:0] pre_add_b;
wire        cout;
wire [31:0] add_res;

assign add_a = link_op ? pc : vsrc1;
assign add_b = pre_add_b ^ {32{do_sub}};
assign pre_add_b = imm_op ? {{16{imm[15]}}, imm} : vsrc2;

add add(.a(add_a), .b(add_b), .cin(do_sub), .cout(cout), .sum(add_res));

wire slt_res;
slt slt(.a31(add_a[31]), .b31(pre_add_b[31]), .cout(cout), .unsigned_op(unsigned_op), .less(slt_res));

overflow overflow1(.a31(add_a[31]), .b31(pre_add_b[31]), .s31(add_res[31]), .overflow(overflow), .overflow_op(overflow_op), .do_sub(do_sub));

wire [31:0] shift_x;
wire [4:0] shift_shamt;
wire [31:0] shift_res;

assign shift_x = vsrc2;
assign shift_shamt = imm_op ? imm[10:6] : vsrc1[4:0];

shift shift(.x(shift_x), .shamt(shift_shamt), .type(shift_type), .y(shift_res));

wire [31:0] logic_a;
wire [31:0] logic_b;
wire [31:0] logic_res;

assign logic_a = vsrc1;
assign logic_b = imm_op ? {16'b0, imm} : vsrc2;

logic logic(.a(logic_a), .b(logic_b), .type(logic_type), .res(logic_res));

assign res = {32{alu_res_sel[0]}} & add_res
           | {32{alu_res_sel[1]}} & slt_res
           | {32{alu_res_sel[2]}} & shift_res
           | {32{alu_res_sel[3]}} & logic_res;

wire [31:0] paddr;
vaddr2paddr vaddr2paddr(.vaddr(add_res), .paddr(paddr));
assign data_ram_addr = paddr;

adel adel1(.load_type(load_type), .offset(add_res[1:0]), .adel(adel));
ades ades1(.store_type(store_type), .offset(add_res[1:0]), .ades(ades));

wire [3:0] wmask;
store store(.offset(add_res[1:0]), .type(store_type), .value(vsrc2), .wmask(wmask), .wdata(data_ram_din));
assign data_ram_we = wmask & {4{store_op}};

assign offset = add_res[1:0];

endmodule
