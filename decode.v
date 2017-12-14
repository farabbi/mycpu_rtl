module decode
(
    input  wire [31:0] inst,

    output wire        reg_we,
    output wire [ 4:0] reg_waddr,
    output wire        imm_op,
    output wire        unsigned_op,
    output wire        do_sub,
    output wire [ 3:0] alu_res_sel,
    output wire [ 2:0] shift_type,
    output wire [ 4:0] logic_type,
    output wire        load_op,
    output wire [ 4:0] load_type,
    output wire        store_op,
    output wire [ 2:0] store_type,
    output wire        is_bd,
    output wire [ 7:0] branch_type,
    output wire        link_op,
    output wire        break_op,
    output wire        syscall_op,
    output wire        ri_op,
    output wire [ 4:0] cp0_reg,
    output wire [ 2:0] cp0_sel,
    output wire [ 6:0] special_reg_inst,
    output wire        overflow_op,
    output wire [ 4:0] read_dest1,
    output wire [ 4:0] read_dest2,
    output wire        use_reg_op,
    output wire        div_op
);

wire add_op;
wire sub_op;
wire slt_op;
wire shift_op;
wire logic_op;

wire inst_ADDU;
assign inst_ADDU = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b100001;

wire inst_ADDIU;
assign inst_ADDIU = inst[31:26]==6'b001001;

wire inst_SUBU;
assign inst_SUBU = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b100011;

wire inst_ADD;
assign inst_ADD = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b100000;

wire inst_ADDI;
assign inst_ADDI = inst[31:26]==6'b001000;

wire inst_SUB;
assign inst_SUB = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b100010;

wire inst_SLT;
assign inst_SLT = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b101010;

wire inst_SLTI;
assign inst_SLTI = inst[31:26]==6'b001010;

wire inst_SLTU;
assign inst_SLTU = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b101011;

wire inst_SLTIU;
assign inst_SLTIU = inst[31:26]==6'b001011;

wire inst_SLL;
assign inst_SLL = inst[31:26]==6'b000000 && inst[25:21]==5'b00000 && inst[5:0]==6'b000000;

wire inst_SLLV;
assign inst_SLLV = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b000100;

wire inst_SRL;
assign inst_SRL = inst[31:26]==6'b000000 && inst[25:21]==5'b00000 && inst[5:0]==6'b000010;

wire inst_SRLV;
assign inst_SRLV = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b000110;

wire inst_SRA;
assign inst_SRA = inst[31:26]==6'b000000 && inst[25:21]==5'b00000 && inst[5:0]==6'b000011;

wire inst_SRAV;
assign inst_SRAV = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b000111;

wire inst_AND;
assign inst_AND = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b100100;

wire inst_ANDI;
assign inst_ANDI = inst[31:26]==6'b001100;

wire inst_OR;
assign inst_OR = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b100101;

wire inst_ORI;
assign inst_ORI = inst[31:26]==6'b001101;

wire inst_XOR;
assign inst_XOR = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b100110;

wire inst_XORI;
assign inst_XORI = inst[31:26]==6'b001110;

wire inst_NOR;
assign inst_NOR = inst[31:26]==6'b000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b100111;

wire inst_LUI;
assign inst_LUI = inst[31:26]==6'b001111 && inst[25:21]==5'b00000;

wire inst_LB;
assign inst_LB = inst[31:26]==6'b100000;

wire inst_LBU;
assign inst_LBU = inst[31:26]==6'b100100;

wire inst_LH;
assign inst_LH = inst[31:26]==6'b100001;

wire inst_LHU;
assign inst_LHU = inst[31:26]==6'b100101;

wire inst_LW;
assign inst_LW = inst[31:26]==6'b100011;

wire inst_SB;
assign inst_SB = inst[31:26]==6'b101000;

wire inst_SH;
assign inst_SH = inst[31:26]==6'b101001;

wire inst_SW;
assign inst_SW = inst[31:26]==6'b101011;

wire inst_BEQ;
assign inst_BEQ = inst[31:26]==6'b000100;

wire inst_BNE;
assign inst_BNE = inst[31:26]==6'b000101;

wire inst_BGEZ;
assign inst_BGEZ = inst[31:26]==6'b000001 && inst[20:16]==5'b00001;

wire inst_BGTZ;
assign inst_BGTZ = inst[31:26]==6'b000111 && inst[20:16]==5'b00000;

wire inst_BLEZ;
assign inst_BLEZ = inst[31:26]==6'b000110 && inst[20:16]==5'b00000;

wire inst_BLTZ;
assign inst_BLTZ = inst[31:26]==6'b000001 && inst[20:16]==5'b00000;

wire inst_J;
assign inst_J = inst[31:26]==6'b000010;

wire inst_JR;
assign inst_JR = inst[31:26]==6'b000000 && inst[20:11]==10'b0000000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b001000;

wire inst_BGEZAL;
assign inst_BGEZAL = inst[31:26]==6'b000001 && inst[20:16]==5'b10001;

wire inst_BLTZAL;
assign inst_BLTZAL = inst[31:26]==6'b000001 && inst[20:16]==5'b10000;

wire inst_JAL;
assign inst_JAL = inst[31:26]==6'b000011;

wire inst_JALR;
assign inst_JALR = inst[31:26]==6'b000000 && inst[20:16]==5'b00000 && inst[10:6]==5'b00000 && inst[5:0]==6'b001001;

wire inst_BREAK;
assign inst_BREAK = inst[31:26]==6'b000000 && inst[5:0]==6'b001101;

wire inst_SYSCALL;
assign inst_SYSCALL = inst[31:26]==6'b000000 && inst[5:0]==6'b001100;

wire inst_MTC0;
assign inst_MTC0 = inst[31:26]==6'b010000 && inst[25:21]==5'b00100 && inst[10:3]==8'b00000000;

wire inst_MFC0;
assign inst_MFC0 = inst[31:26]==6'b010000 && inst[25:21]==5'b00000 && inst[10:3]==8'b00000000;

wire inst_MTHI;
assign inst_MTHI = inst[31:26]==6'b000000 && inst[20:6]==15'b000000000000000 && inst[5:0]==6'b010001;

wire inst_MTLO;
assign inst_MTLO = inst[31:26]==6'b000000 && inst[20:6]==15'b000000000000000 && inst[5:0]==6'b010011;

wire inst_MFHI;
assign inst_MFHI = inst[31:26]==6'b000000 && inst[25:16]==10'b0000000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b010000;

wire inst_MFLO;
assign inst_MFLO = inst[31:26]==6'b000000 && inst[25:16]==10'b0000000000 && inst[10:6]==5'b00000 && inst[5:0]==6'b010010;

wire inst_ERET;
assign inst_ERET = inst[31:26]==6'b010000 && inst[25]==1'b1 && inst[24:6]==19'b0000000000000000000 && inst[5:0]==6'b011000;

wire inst_MULT;
assign inst_MULT = inst[31:26]==6'b000000 && inst[15:6]==10'b0000000000 && inst[5:0]==6'b011000;
//assign inst_MULT = 1'b0;

wire inst_MULTU;
assign inst_MULTU = inst[31:26]==6'b000000 && inst[15:6]==10'b0000000000 && inst[5:0]==6'b011001;
//assign inst_MULTU = 1'b0;

wire inst_DIV;
assign inst_DIV = inst[31:26]==6'b000000 && inst[15:6]==10'b0000000000 && inst[5:0]==6'b011010;
//assign inst_DIV = 1'b0;

wire inst_DIVU;
assign inst_DIVU = inst[31:26]==6'b000000 && inst[15:6]==10'b0000000000 && inst[5:0]==6'b011011;
//assign inst_DIVU = 1'b0;

assign reg_we = inst_ADDU | inst_ADDIU | inst_SUBU | inst_ADD | inst_ADDI | inst_SUB | inst_SLT | inst_SLTI | inst_SLTU | inst_SLTIU | inst_SLL | inst_SLLV | inst_SRL | inst_SRLV | inst_SRA | inst_SRAV | inst_AND | inst_ANDI | inst_OR | inst_ORI | inst_XOR | inst_XORI | inst_NOR | inst_LUI | inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW | inst_BGEZAL | inst_BLTZAL | inst_JAL | inst_JALR | inst_MFHI | inst_MFLO | inst_MFC0;

assign reg_waddr = {5{inst_ADDU}} & inst[15:11]
                 | {5{inst_ADDIU}} & inst[20:16]
                 | {5{inst_SUBU}} & inst[15:11]
                 | {5{inst_ADD}} & inst[15:11]
                 | {5{inst_ADDI}} & inst[20:16]
                 | {5{inst_SUB}} & inst[15:11]
                 | {5{inst_SLT}} & inst[15:11]
                 | {5{inst_SLTI}} & inst[20:16]
                 | {5{inst_SLTU}} & inst[15:11]
                 | {5{inst_SLTIU}} & inst[20:16]
                 | {5{inst_SLL}} & inst[15:11]
                 | {5{inst_SLLV}} & inst[15:11]
                 | {5{inst_SRL}} & inst[15:11]
                 | {5{inst_SRLV}} & inst[15:11]
                 | {5{inst_SRA}} & inst[15:11]
                 | {5{inst_SRAV}} & inst[15:11]
                 | {5{inst_AND}} & inst[15:11]
                 | {5{inst_ANDI}} & inst[20:16]
                 | {5{inst_OR}} & inst[15:11]
                 | {5{inst_ORI}} & inst[20:16]
                 | {5{inst_XOR}} & inst[15:11]
                 | {5{inst_XORI}} & inst[20:16]
                 | {5{inst_NOR}} & inst[15:11]
                 | {5{inst_LUI}} & inst[20:16]
                 | {5{inst_LB}} & inst[20:16]
                 | {5{inst_LBU}} & inst[20:16]
                 | {5{inst_LH}} & inst[20:16]
                 | {5{inst_LHU}} & inst[20:16]
                 | {5{inst_LW}} & inst[20:16]
                 | {5{inst_SB}} & inst[20:16]
                 | {5{inst_SH}} & inst[20:16]
                 | {5{inst_SW}} & inst[20:16]
                 | {5{inst_BGEZAL}} & 5'b11111
                 | {5{inst_BLTZAL}} & 5'b11111
                 | {5{inst_JAL}} & 5'b11111
                 | {5{inst_JALR}} & inst[15:11]
                 | {5{inst_MFC0}} & inst[20:16]
                 | {5{inst_MFHI}} & inst[15:11]
                 | {5{inst_MFLO}} & inst[15:11];

assign cp0_reg = {5{inst_MTC0}} & inst[15:11]
               | {5{inst_MFC0}} & inst[15:11];
assign cp0_sel = {3{inst_MTC0}} & inst[2:0]
               | {3{inst_MFC0}} & inst[2:0];

assign imm_op = inst_ADDIU | inst_ADDI
              | inst_SLTI | inst_SLTIU  
              | inst_SLL | inst_SRL | inst_SRA 
              | inst_ANDI | inst_ORI | inst_XORI | inst_LUI 
              | inst_BGEZAL | inst_BLTZAL | inst_JAL | inst_JALR
              | inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW
              | inst_SB | inst_SH | inst_SW;

assign unsigned_op = inst_ADDU | inst_ADDIU | inst_SUBU | inst_SLTU | inst_SLTIU | inst_MULTU | inst_DIVU;

assign add_op = inst_ADDU | inst_ADDIU | inst_ADD | inst_ADDI;
assign sub_op = inst_SUBU | inst_SUB;
assign slt_op = inst_SLT | inst_SLTI | inst_SLTU | inst_SLTIU;
assign shift_op = inst_SLL | inst_SLLV | inst_SRL | inst_SRLV | inst_SRA | inst_SRAV;
assign logic_op = inst_AND | inst_ANDI | inst_OR | inst_ORI | inst_XOR | inst_XORI | inst_NOR | inst_LUI;

assign do_sub = sub_op | slt_op;
assign alu_res_sel = {logic_op, shift_op, slt_op,
                      add_op | sub_op |
                      inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW |
                      inst_SB | inst_SH | inst_SW |
                      inst_BGEZAL | inst_BLTZAL | inst_JAL | inst_JALR};

assign shift_type = {inst_SRA | inst_SRAV, inst_SRL | inst_SRLV, inst_SLL | inst_SLLV};
assign logic_type = {inst_LUI, inst_NOR, inst_XOR | inst_XORI, inst_OR | inst_ORI, inst_AND | inst_ANDI};

assign load_op = inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW;
assign load_type = {inst_LW, inst_LHU, inst_LH, inst_LBU, inst_LB};

assign store_op = inst_SB | inst_SH | inst_SW;
assign store_type = {inst_SW, inst_SH, inst_SB};

assign link_op = inst_BGEZAL | inst_BLTZAL | inst_JAL | inst_JALR;

assign is_bd = inst_BEQ | inst_BNE | inst_BGEZ | inst_BGTZ | inst_BLEZ | inst_BLTZ 
             | inst_J | inst_JR | inst_BGEZAL | inst_BLTZAL | inst_JAL | inst_JALR;

assign branch_type = {inst_JR | inst_JALR, inst_J | inst_JAL,
                      inst_BLTZ | inst_BLTZAL, inst_BLEZ, inst_BGTZ, inst_BGEZ | inst_BGEZAL, inst_BNE, inst_BEQ};

assign break_op = inst_BREAK;
assign syscall_op = inst_SYSCALL;
assign ri_op = ~(inst_ADDU | inst_ADDIU | inst_SUBU | inst_ADD | inst_ADDI | inst_SUB
               | inst_SLT | inst_SLTI | inst_SLTU | inst_SLTIU 
               | inst_SLL | inst_SLLV | inst_SRL | inst_SRLV | inst_SRA | inst_SRAV 
               | inst_AND | inst_ANDI | inst_OR | inst_ORI | inst_XOR | inst_XORI | inst_NOR | inst_LUI 
               | inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW 
               | inst_SB | inst_SH | inst_SW 
               | inst_BEQ | inst_BNE | inst_BGEZ | inst_BGTZ | inst_BLEZ | inst_BLTZ | inst_J | inst_JR 
               | inst_BGEZAL | inst_BLTZAL | inst_JAL | inst_JALR 
               | inst_BREAK | inst_SYSCALL 
               | inst_MTC0 | inst_MFC0 | inst_MTHI | inst_MTLO | inst_MFHI | inst_MFLO | inst_ERET
               | inst_MULT | inst_MULTU | inst_DIV | inst_DIVU);

assign special_reg_inst = {inst_ERET, inst_MTHI | inst_MULT | inst_MULTU | inst_DIV | inst_DIVU, 
                           inst_MTLO | inst_MULT | inst_MULTU | inst_DIV | inst_DIVU, 
                           inst_MFHI, inst_MFLO, inst_MTC0, inst_MFC0};

assign overflow_op = inst_ADD | inst_ADDI | inst_SUB;

assign read_dest1 = {5{inst_ADD}} & inst[25:21]
                  | {5{inst_ADDI}} & inst[25:21]
                  | {5{inst_ADDIU}} & inst[25:21]
                  | {5{inst_ADDU}} & inst[25:21]
                  | {5{inst_AND}} & inst[25:21]
                  | {5{inst_ADDI}} & inst[25:21]
                  | {5{inst_BEQ}} & inst[25:21]
                  | {5{inst_BGEZ}} & inst[25:21]
                  | {5{inst_BGEZAL}} & inst[25:21]
                  | {5{inst_BGTZ}} & inst[25:21]
                  | {5{inst_BLEZ}} & inst[25:21]
                  | {5{inst_BLTZ}} & inst[25:21]
                  | {5{inst_BLTZAL}} & inst[25:21]
                  | {5{inst_BNE}} & inst[25:21]
                  | {5{inst_JALR}} & inst[25:21]
                  | {5{inst_JR}} & inst[25:21]
                  | {5{inst_LB}} & inst[25:21]
                  | {5{inst_LBU}} & inst[25:21]
                  | {5{inst_LH}} & inst[25:21]
                  | {5{inst_LHU}} & inst[25:21]
                  | {5{inst_LW}} & inst[25:21]
                  | {5{inst_MTHI}} & inst[25:21]
                  | {5{inst_MTLO}} & inst[25:21]
                  | {5{inst_NOR}} & inst[25:21]
                  | {5{inst_OR}} & inst[25:21]
                  | {5{inst_ORI}} & inst[25:21]
                  | {5{inst_SLLV}} & inst[25:21]
                  | {5{inst_SLT}} & inst[25:21]
                  | {5{inst_SLTI}} & inst[25:21]
                  | {5{inst_SLTIU}} & inst[25:21]
                  | {5{inst_SLTU}} & inst[25:21]
                  | {5{inst_SRAV}} & inst[25:21]
                  | {5{inst_SRLV}} & inst[25:21]
                  | {5{inst_SUB}} & inst[25:21]
                  | {5{inst_SUBU}} & inst[25:21]
                  | {5{inst_XOR}} & inst[25:21]
                  | {5{inst_XORI}} & inst[25:21]
                  | {5{inst_MULT}} & inst[25:21]
                  | {5{inst_MULTU}} & inst[25:21]
                  | {5{inst_DIV}} & inst[25:21]
                  | {5{inst_DIVU}} & inst[25:21];

assign read_dest2 = {5{inst_ADD}} & inst[20:16]
                  | {5{inst_ADDU}} & inst[20:16]
                  | {5{inst_AND}} & inst [20:16]
                  | {5{inst_BEQ}} & inst[20:16]
                  | {5{inst_BNE}} & inst[20:16]
                  | {5{inst_MTC0}} & inst[20:16]
                  | {5{inst_NOR}} & inst[20:16]
                  | {5{inst_OR}} & inst[20:16]
                  | {5{inst_SB}} & inst[20:16]
                  | {5{inst_SH}} & inst[20:16]
                  | {5{inst_SLL}} & inst[20:16]
                  | {5{inst_SLLV}} & inst[20:16]
                  | {5{inst_SLT}} & inst[20:16]
                  | {5{inst_SLTU}} & inst[20:16]
                  | {5{inst_SRA}} & inst[20:16]
                  | {5{inst_SRAV}} & inst[20:16]
                  | {5{inst_SRL}} & inst[20:16]
                  | {5{inst_SRLV}} & inst[20:16]
                  | {5{inst_SUB}} & inst[20:16]
                  | {5{inst_SUBU}} & inst[20:16]
                  | {5{inst_SW}} & inst[20:16]
                  | {5{inst_XOR}} & inst[20:16]
                  | {5{inst_MULT}} & inst[20:16]
                  | {5{inst_MULTU}} & inst[20:16]
                  | {5{inst_DIV}} & inst[20:16]
                  | {5{inst_DIVU}} & inst[20:16];
                  
assign use_reg_op = inst_ADD
                   | inst_ADDI
                   | inst_ADDIU
                   | inst_ADDU
                   | inst_AND
                   | inst_ADDI
                   | inst_BEQ
                   | inst_BGEZ
                   | inst_BGEZAL
                   | inst_BGTZ
                   | inst_BLEZ
                   | inst_BLTZ
                   | inst_BLTZAL
                   | inst_BNE
                   | inst_JALR
                   | inst_JR
                   | inst_LB
                   | inst_LBU
                   | inst_LH
                   | inst_LHU
                   | inst_LW
                   | inst_MTC0
                   | inst_MTHI
                   | inst_MTLO
                   | inst_NOR
                   | inst_OR
                   | inst_ORI
                   | inst_SB
                   | inst_SH
                   | inst_SLL
                   | inst_SLLV
                   | inst_SLT
                   | inst_SLTI
                   | inst_SLTIU
                   | inst_SLTU
                   | inst_SRA
                   | inst_SRAV
                   | inst_SRL
                   | inst_SRLV
                   | inst_SUB
                   | inst_SUBU
                   | inst_SW
                   | inst_XOR
                   | inst_XORI
                   | inst_MULT
                   | inst_MULTU
                   | inst_DIV
                   | inst_DIVU;

assign div_op = inst_DIV | inst_DIVU;

endmodule
