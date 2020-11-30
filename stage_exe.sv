//

import mips_cpu_pkg::*;

module stage_exe (
		// interface with hilo
		input  reg_t        hi_o,
		input  reg_t        lo_o,
		// interface with regs_idexe
		input  logic        exe_i_dm2rf,
		input  logic        exe_i_hilowe,
		input  logic        exe_i_rfwe,
		input  alutype_enum exe_i_alutype,
		input  aluop_enum   exe_i_aluop,
		input  reg_addr_t   exe_i_rfwa,
		input  reg_t        exe_i_src1,
		input  reg_t        exe_i_src2,
		input  reg_t        exe_i_dmdin,
		input  memop        exe_i_memop,
		// interface with regs_exemem
		output logic        exe_o_dm2rf,
		output logic        exe_o_hilowe,
		output logic        exe_o_rfwe,
		output reg_addr_t   exe_o_rfwa,
		output double_reg_t exe_o_mulres,
		output reg_t        exe_o_alures,
		output reg_t        exe_o_dmdin ,
		output memop        exe_o_memop
	);

	// passthrough
	assign exe_o_dm2rf  = exe_i_dm2rf;
	assign exe_o_hilowe = exe_i_hilowe;
	assign exe_o_rfwe   = exe_i_rfwe;
	assign exe_o_rfwa   = exe_i_rfwa;
	assign exe_o_dmdin  = exe_i_dmdin;
	assign exe_o_memop  = exe_i_memop;

	// inner data path
	double_reg_t mulres;
	reg_t        arithres;
	reg_t        logicres;
	reg_t        moveres;
	reg_t        shiftres;

	assign mulres       = exe_i_aluop.specific_op.mult == MULT_ ? exe_i_src1 * exe_i_src2 : {ZERO,ZERO};
	assign moveres      = exe_i_aluop.specific_op.move == HI ? hi_o : lo_o;

	always_comb begin
		case (exe_i_aluop.specific_op.shift) // shift mode
			LL : shiftres      = exe_i_src1 << exe_i_src2;
			RL : shiftres      = exe_i_src1 >> exe_i_src2;
			RA : shiftres      = exe_i_src1 >>> exe_i_src2;
			default : shiftres = exe_i_src1 << exe_i_src2;
		endcase

		case (exe_i_aluop.specific_op.arith)
			ADD_ : arithres    = exe_i_src1 + exe_i_src2;
			SUB_ : arithres    = exe_i_src1 - exe_i_src2;
			GT : arithres      = exe_i_src1 > exe_i_src2;
			GE : arithres      = exe_i_src1 >= exe_i_src2;
			LT : arithres      = exe_i_src1 < exe_i_src2;
			LE : arithres      = exe_i_src1 <= exe_i_src2;
			EQ : arithres      = exe_i_src1 == exe_i_src2;
			default : arithres = exe_i_src1 + exe_i_src2;
		endcase

		case (exe_i_aluop.specific_op.logic_)
			AND_ : logicres          = exe_i_src1 & exe_i_src2;
			OR : logicres            = exe_i_src1 | exe_i_src2;
			XOR_ : logicres          = exe_i_src1 ^ exe_i_src2;
			default : AND : logicres = exe_i_src1 & exe_i_src2;
		endcase
	end

// outer data path
	// determine result by one-hot type
	assign exe_o_alures = {WIDTH_REG{exe_i_alutype[0]}} & arithres | {WIDTH_REG{exe_i_alutype[1]}} & logicres |
		{WIDTH_REG{exe_i_alutype[2]}} & moveres | {WIDTH_REG{exe_i_alutype[3]}} & shiftres;

	assign exe_o_mulres = mulres;

endmodule
