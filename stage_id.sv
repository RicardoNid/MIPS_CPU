//

import mips_cpu_pkg::*;

module stage_id (
        // interface with rf
        output logic        rfre1,
        output reg_enum     rfra1,
        input  word_t       rfrd1,
        output logic        rfre2,
        output reg_enum     rfra2,
        input  word_t       rfrd2,
        // interface with regs_ifid
        input  inst_t       id_i_inst,
        // interface with regs_idexe
        output logic        id_o_dm2rf,
        output logic        id_o_hilowe,
        output logic        id_o_rfwe,
        output alutype_enum id_o_alutype,
        output aluop_struct id_o_aluop,
        output reg_enum     id_o_rfwa,
        output word_t       id_o_src1,
        output word_t       id_o_src2,
        output word_t       id_o_dmdin,
        output memop_struct id_o_memop
    );

    // rearrange inst
    inst_t               rearranged_inst;
    assign rearranged_inst = inst_t'({id_i_inst[7 : 0],id_i_inst[15 : 8],
                id_i_inst[23 : 16],id_i_inst[31 : 24]});
    // extract segments of inst
    opcode_enum          opcode ;
    func_enum            func ;
    reg_enum             rd ;
    reg_enum             rs ;
    reg_enum             rt ;
    logic       [4 : 0]  sa ;
    logic       [15 : 0] imm ;

    assign opcode          = rearranged_inst.r.op;
    assign func            = rearranged_inst.r.func;
    assign rd              = rearranged_inst.r.rd;
    assign rs              = rearranged_inst.r.rs;
    assign rt              = rearranged_inst.r.rt;
    assign sa              = rearranged_inst.r.sa;
    assign imm             = rearranged_inst.i.imm;

    // todo : step0
    logic                is_inst_r;
    // not of type r, using opecode to define
    logic                is_ADDI;
    logic                is_ADDIU;
    logic                is_SLTI;
    logic                is_SLTIU;
    logic                is_ANDI;
    logic                is_ORI;
    logic                is_XORI;
    logic                is_LUI;
    logic                is_LB;
    logic                is_LBU;
    logic                is_LH;
    logic                is_LHU;
    logic                is_LW;
    logic                is_SB;
    logic                is_SH;
    logic                is_SW;

    assign is_inst_r       = ~|opcode;

    assign is_ADDI         = opcode == ADDI;
    assign is_ADDIU        = opcode == ADDIU;
    assign is_SLTI         = opcode == SLTI;
    assign is_SLTIU        = opcode == SLTIU;
    assign is_ANDI         = opcode == ANDI;
    assign is_ORI          = opcode == ORI;
    assign is_XORI         = opcode == XORI;
    assign is_LUI          = opcode == LUI;
    assign is_LB           = opcode == LB;
    assign is_LBU          = opcode == LBU;
    assign is_LH           = opcode == LH;
    assign is_LHU          = opcode == LHU;
    assign is_LW           = opcode == LW;
    assign is_SB           = opcode == SB;
    assign is_SH           = opcode == SH;
    assign is_SW           = opcode == SW;

    // of type r, using func to define
    logic                is_ADD;
    logic                is_ADDU;
    logic                is_SUB;
    logic                is_SUBU;
    logic                is_SLT;
    logic                is_SLTU;
    logic                is_AND;
    logic                is_OR;
    logic                is_NOR;
    logic                is_XOR;
    logic                is_SLL;
    logic                is_SRL;
    logic                is_SRA;
    logic                is_SLLV;
    logic                is_SRLV;
    logic                is_SRAV;
    logic                is_MULT;
    logic                is_MULTU;
    logic                is_DIV;
    logic                is_DIVU;
    logic                is_MFHI;
    logic                is_MFLO;
    logic                is_MTHI;
    logic                is_MTLO;

    assign is_ADD          = (is_inst_r && func == ADD );
    assign is_ADDU         = (is_inst_r && func == ADDU);
    assign is_SUB          = (is_inst_r && func == SUB );
    assign is_SUBU         = (is_inst_r && func == SUBU);
    assign is_SLT          = (is_inst_r && func == SLT );
    assign is_SLTU         = (is_inst_r && func == SLTU);
    assign is_AND          = (is_inst_r && func == AND );
    assign is_OR           = (is_inst_r && func == OR );
    assign is_NOR          = (is_inst_r && func == NOR );
    assign is_XOR          = (is_inst_r && func == XOR );
    assign is_SLL          = (is_inst_r && func == SLL );
    assign is_SRL          = (is_inst_r && func == SRL );
    assign is_SRA          = (is_inst_r && func == SRA );
    assign is_SLLV         = (is_inst_r && func == SLLV);
    assign is_SRLV         = (is_inst_r && func == SRLV);
    assign is_SRAV         = (is_inst_r && func == SRAV);
    assign is_MULT         = (is_inst_r && func == MULT);
    assign is_MULTU        = (is_inst_r && func == MULT);
    assign is_DIV          = (is_inst_r && func == DIV );
    assign is_DIVU         = (is_inst_r && func == DIVU);
    assign is_MFHI         = (is_inst_r && func == MFHI);
    assign is_MFLO         = (is_inst_r && func == MFLO);
    assign is_MTHI         = (is_inst_r && func == MTHI);
    assign is_MTLO         = (is_inst_r && func == MTLO);

    // inner switch signal
    logic                rtsel;
    logic                uppersel;
    logic                sext;
    logic                shiftsel;
    logic                immsel;

    logic                is_mult;
    logic                is_add;
    logic                is_sub;
    logic                is_lt;
    logic                is_and;
    logic                is_or;
    logic                is_ll;
    logic                is_hi;
    logic                is_lo;

    logic                is_load;
    logic                is_store;
    logic                is_none;
    logic                is_word;
    logic                is_half;
    logic                is_byte;

    // passthrogh : none
    assign rfra1           = rs;
    assign rfra2           = rt;

    always_comb begin
        word_t temp;
        // todo : step1 source and destination contorl
        // inner
        rtsel       = is_inst_r;       // source of rfwa
        sext        = id_o_alutype[0]; // source of src1
        uppersel    = is_LUI;          // source of src1
        immsel      = 1'b0;            // source of src1
        shiftsel    = 1'b0;            // source of src2
        rfre1       = is_inst_r;
        rfre2       = is_inst_r;
        // outer
        id_o_dm2rf  = is_load;
        id_o_hilowe = is_MULT;
        id_o_rfwe   =                  // write back to register fixme : simplify this logic
        is_ADD || is_SUBU || is_SLT || is_MFHI || is_MFLO ||
        is_ADDIU || is_SLTIU || is_ORI || is_LUI || is_LB || is_LW;
        // datapath of rfwa
        id_o_rfwa   = rtsel ? rt : rd;
        // datapath of src1
        id_o_src1   = shiftsel ? sa : rfrd1;
        // datapath of src2
        temp        = sext ? {{16{imm[15]}},imm} : {16'h0000, imm};
        temp        = uppersel ? (imm << 16) : temp;
        id_o_src2   = immsel ? temp : rfrd2;
        // datapath of dmdin
        id_o_dmdin  = rfrd2;
    end

    // alu decode
    always_comb begin
        // todo : step2 alutype
        id_o_alutype[0]  = // arith
        is_ADD || is_SUBU || is_SLT || is_ADDI || is_ADDIU || is_SLTIU ||
        is_LB || is_LW || is_SB || is_SW;
        id_o_alutype[1]  = // logic
        is_AND || is_ORI || is_LUI;
        id_o_alutype[2]  = // move
        is_MFHI || is_MFLO;
        id_o_alutype[3]  = // shift
        is_SLL;
        // aluop todo : step3 aluop
        is_mult          = is_MULT;
        is_add           = is_ADD || is_ADDI || is_ADDIU || is_LB || is_LW || is_SB || is_SW;
        is_sub           = is_SUBU;
        is_lt            = is_SLT || is_SLTIU;
        is_and           = is_AND;
        is_or            = is_ORI || is_LUI;
        is_ll            = is_SLL;
        is_hi            = is_MFHI;
        is_lo            = is_MFLO;
        id_o_aluop.sign  = is_SLT;
        id_o_aluop.error = is_ADD;
        unique case (id_o_alutype)
            NOP : begin
                unique case (1'b1)
                    is_mult : id_o_aluop.op.mult_op = ALU_MULT;
                endcase
            end
            ARITH : begin
                unique case(1'b1)
                    is_add : id_o_aluop.op.arith_op = ALU_ADD;
                    is_sub : id_o_aluop.op.arith_op = ALU_SUB;
                    is_lt : id_o_aluop.op.arith_op  = ALU_LT;
                endcase
            end
            LOGIC : begin
                unique case(1'b1)
                    is_and : id_o_aluop.op.logic_op = ALU_AND;
                    is_or : id_o_aluop.op.logic_op  = ALU_OR;
                endcase
            end
            MOVE : begin
                unique case(1'b1)
                    is_hi : id_o_aluop.op.move_op = ALU_HI;
                    is_lo : id_o_aluop.op.move_op = ALU_LO;
                endcase
            end
            SHIFT : begin
                unique case(1'b1)
                    is_ll : id_o_aluop.op.shift_op = ALU_LL;
                endcase
            end
        endcase
    end

    // todo : step4 memop decode
    always_comb begin
        is_load  = is_LW || is_LB;
        is_store = is_SW || is_SB;
        is_none  = !(is_load || is_store);
        is_byte  = is_LB || is_SB;
        is_half  = 1'b0;
        is_word  = !(is_byte || is_half);
        unique case(1'b1)
            is_load : id_o_memop.ls_type  = MEM_LOAD;
            is_store : id_o_memop.ls_type = MEM_STORE;
            is_none : id_o_memop.ls_type  = MEM_NONE;
        endcase
        unique case(1'b1)
            is_word : id_o_memop.ls_width = MEM_WORD;
            is_half : id_o_memop.ls_width = MEM_HALF;
            is_byte : id_o_memop.ls_width = MEM_BYTE;
        endcase
        id_o_memop.sign = 1'b0;
    end

endmodule

