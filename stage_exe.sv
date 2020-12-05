//

import mips_cpu_pkg::*;

module stage_exe (
        // interface with hilo
        input  word_t        hi_o,
        input  word_t        lo_o,
        // interface with regs_idexe
        input  logic         exe_i_dm2rf,
        input  logic         exe_i_hilowe,
        input  logic         exe_i_rfwe,
        input  alutype_enum  exe_i_alutype,
        input  aluop_struct  exe_i_aluop,
        input  reg_enum      exe_i_rfwa,
        input  word_t        exe_i_src1,
        input  word_t        exe_i_src2,
        input  word_t        exe_i_dmdin,
        input  memop_struct  exe_i_memop,
        // interface with regs_exemem
        output logic         exe_o_dm2rf,
        output logic         exe_o_hilowe,
        output logic         exe_o_rfwe,
        output reg_enum      exe_o_rfwa,
        output double_word_t exe_o_mulres,
        output word_t        exe_o_alures,
        output word_t        exe_o_dmdin ,
        output memop_struct  exe_o_memop
    );

    // passthrough
    assign exe_o_dm2rf  = exe_i_dm2rf;
    assign exe_o_hilowe = exe_i_hilowe;
    assign exe_o_rfwe   = exe_i_rfwe;
    assign exe_o_rfwa   = exe_i_rfwa;
    assign exe_o_dmdin  = exe_i_dmdin;
    assign exe_o_memop  = exe_i_memop;

    // inner data path
    double_word_t mulres;
    word_t        arithres;
    word_t        logicres;
    word_t        moveres;
    word_t        shiftres;

    // fixme : overflow should be considered, in Chap7
    always_comb begin

        mulres       = exe_i_aluop.op.mult_op == ALU_MULT ? exe_i_src1 * exe_i_src2 : {ZERO,ZERO};

        unique case (exe_i_aluop.op.shift_op) // shift
            ALU_LL : shiftres = exe_i_src2 << exe_i_src1;
            ALU_RL : shiftres = exe_i_src2 >> exe_i_src1;
            ALU_RA : shiftres = exe_i_src2 >>> exe_i_src1;
        endcase

        unique case (exe_i_aluop.op.arith_op) // arith
            ALU_ADD : arithres = exe_i_src1 + exe_i_src2;
            ALU_SUB : arithres = exe_i_src1 - exe_i_src2;
            ALU_LT : arithres  = {{(WIDTH_REG - 1){1'b0}}, exe_i_src1 < exe_i_src2};
        endcase

        unique case (exe_i_aluop.op.logic_op) // logic
            ALU_AND : logicres = exe_i_src1 & exe_i_src2;
            ALU_OR : logicres  = exe_i_src1 | exe_i_src2;
            ALU_XOR : logicres = exe_i_src1 ^ exe_i_src2;
            ALU_NOR : logicres = ~(exe_i_src1 | exe_i_src2);
        endcase

        moveres      = exe_i_aluop.op.move_op == ALU_HI ? hi_o : lo_o; // move

        // fixme : division should be implemented, in Chap6
        // outer data path
        exe_o_mulres = mulres;
        // determine result by using one-hot as mask
        exe_o_alures =
        {WIDTH_REG{exe_i_alutype[0]}} & arithres |
        {WIDTH_REG{exe_i_alutype[1]}} & logicres |
        {WIDTH_REG{exe_i_alutype[2]}} & moveres |
        {WIDTH_REG{exe_i_alutype[3]}} & shiftres;
    end

endmodule
