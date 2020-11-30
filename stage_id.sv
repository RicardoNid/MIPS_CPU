//

import mips_cpu_pkg::*;

module stage_id (
		// interface with rf
		output logic        rfre1,
		output reg_addr_t   rfra1,
		input  reg_t        rfrd1,
		output logic        rfre2,
		output reg_addr_t   rfra2,
		input  reg_t        rfrd2,
		// interface with regs_ifid
		input  inst_t       id_i_inst,
		// interface with regs_idexe
		output logic        id_o_dm2rf,
		output logic        id_o_hilowe,
		output logic        id_o_rfwe,
		output alutype_enum id_o_alutype,
		output aluop_enum   id_o_aluop,
		output reg_addr_t   id_o_rfwa,
		output reg_t        id_o_src1,
		output reg_t        id_o_src2,
		output reg_t        id_o_dmdin,
		output memop        id_o_memop
	);

	// passthrogh : none
	// rearrange inst
	inst_t               rearranged_inst = {id_i_inst[7 : 0],id_i_inst[15 : 8],id_i_inst[23 : 16],id_i_inst[31 : 24]};
	// 提取指令字中各个字段的信息
	opcode_enum          opcode          = rearranged_inst.r.op;
	func_enum            func            = rearranged_inst.r.func;
	reg_addr_t           rd              = rearranged_inst.r.rd;
	reg_addr_t           rs              = rearranged_inst.r.rs;
	reg_addr_t           rt              = rearranged_inst.r.rt;
	logic       [4 : 0]  sa              = rearranged_inst.r.sa;
	logic       [15 : 0] imm             = rearranged_inst.i.imm;
	// 第一级译码逻辑∶确定当前需要译码的指令
	logic                is_inst_r       = ~|opcode;
	// not of type r, using opecode to define
	logic                is_ADDI         = opcode == ADDI ;
	logic                is_ADDIU        = opcode == ADDIU ;
	logic                is_SLTI         = opcode == SLTI ;
	logic                is_SLTIU        = opcode == SLTIU ;
	logic                is_ANDI         = opcode == ANDI ;
	logic                is_ORI          = opcode == ORI ;
	logic                is_XORI         = opcode == XORI ;
	logic                is_LUI          = opcode == LUI ;
	logic                is_LB           = opcode == LB ;
	logic                is_LBU          = opcode == LBU ;
	logic                is_LH           = opcode == LH ;
	logic                is_LHU          = opcode == LHU ;
	logic                is_LW           = opcode == LW ;
	logic                is_SB           = opcode == SB ;
	logic                is_SH           = opcode == SH ;
	logic                is_SW           = opcode == SW ;
	// of type r, using func to define
	logic                is_ADD          = (is_inst_r && func == ADD );
	logic                is_ADDU         = (is_inst_r && func == ADDU);
	logic                is_SUB          = (is_inst_r && func == SUB );
	logic                is_SUBU         = (is_inst_r && func == SUBU);
	logic                is_SLT          = (is_inst_r && func == SLT );
	logic                is_SLTU         = (is_inst_r && func == SLTU);
	logic                is_AND          = (is_inst_r && func == AND );
	logic                is_OR           = (is_inst_r && func == OR );
	logic                is_NOR          = (is_inst_r && func == NOR );
	logic                is_XOR          = (is_inst_r && func == XOR );
	logic                is_SLL          = (is_inst_r && func == SLL );
	logic                is_SRL          = (is_inst_r && func == SRL );
	logic                is_SRA          = (is_inst_r && func == SRA );
	logic                is_SLLV         = (is_inst_r && func == SLLV);
	logic                is_SRLV         = (is_inst_r && func == SRLV);
	logic                is_SRAV         = (is_inst_r && func == SRAV);
	logic                is_MULT         = (is_inst_r && func == MULT);
	logic                is_MULTU        = (is_inst_r && func == MULT);
	logic                is_DIV          = (is_inst_r && func == DIV );
	logic                is_DIVU         = (is_inst_r && func == DIVU);
	logic                is_MFHI         = (is_inst_r && func == MFHI);
	logic                is_MFLO         = (is_inst_r && func == MFLO);
	logic                is_MTHI         = (is_inst_r && func == MTHI);
	logic                is_MTLO         = (is_inst_r && func == MTLO);
	//  第二级译码逻辑∶生成具体控制信号
	// alutype
	assign id_o_alutype[0]        = is_MULT;       // mult todo
	assign id_o_alutype[1]        = is_MULT;       // arith todo
	assign id_o_alutype[2]        = is_MULT;       // logic todo
	assign id_o_alutype[3]        = is_MULT;       // move  todo
	assi
gn id_o_alutype[4]        = is_MULT;       // shift todo
// aluop
	assign id_o_aluop.specific_op = 3'b000;        // todo
	assign id_o_aluop.sign        = 1'b0;          // todo
	assign id_o_aluop.error       = 1'b0;          // todo
	// memop
	assign id_o_memop.is_ls       = LS_TYPE_ZERO;  // todo
	assign id_o_memop.ls_width    = LS_WIDTH_ZERO; // todo
// inner control
	logic                rtsel;
	logic                upper;
	logic                sext;
	logic                shift;
	logic                immsel;
	assign rtsel                  = 1'b0;          // todo
	assign upper                  = 1'b0;          // for LUI only
	assign sext                   = 1'b0;          // todo
	assign shift                  = 1'b0;          // todo
	assign immsel                 = 1'b0;          // todo
// outer control
	assign id_o_dm2rf             = 1'b0;          // todo
	assign id_o_hilowe            = 1'b0;          // todo
	assign id_o_rfwe              = 1'b0;          // todo
// datapath
// inner data
	reg_t                immext;
	assign immext                 =
		upper ? (imm << 16)
		: sext ? {{16{imm[15]}},imm}
		: {16'h0000, imm};                         // todo
// outer data
	assign id_o_rfwa              = rtsel ? rt : rd;
	assign id_o_src1              = shift ? sa : rfrd1;
	assign id_o_src2              = immsel ? immext : rfrd2;
	assign id_o_dmdin             = rfrd2;
	assign rfra1                  = rs;
	assign rfra2                  = rt;
	assign rfre1                  = 1'b0;          //todo
	assign rfre2                  = 1'b0;          // todo
endmodule
