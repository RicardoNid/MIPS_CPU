// define all the parameters that would be used after

package mips_cpu_pkg;

	localparam WIDTH_INST     = 32;
	// parameters of regfile
	localparam WIDTH_REG      = 32;
	localparam NUM_REG        = 32;
	localparam WIDTH_REG_ADDR = $clog2(NUM_REG);
	typedef logic [31 : 0] reg_t;
	typedef logic [63 : 0] double_reg_t;
	typedef logic [WIDTH_REG_ADDR-1 : 0] reg_addr_t;
	localparam REG_NOP        = 5'b00000;
	localparam ZERO           = 32'h00000000;
	// parameters of program counter & im
	localparam WIDTH_IM_ADDR  = 32;
	typedef logic [WIDTH_IM_ADDR-1 : 0] im_addr_t;
	localparam PC_INIT        = 32'h00000000;
	localparam IM_DEPTH       = 2048;
	// parameters of dm
	localparam WIDTH_DM_ADDR  = 32;
	typedef logic [WIDTH_DM_ADDR-1 : 0] dm_addr_t;
	localparam DM_DEPTH       = 2048;

// extract the info about ALU from inst to alutype & aluop
	typedef enum logic [3 : 0] {
		NOP   = 4'b0000,
		ARITH = 4'b0001,
		LOGIC = 4'b0010,
		MOVE  = 4'b0100,
		SHIFT = 4'b1000
	} alutype_enum;
	localparam ALUTYPE_ZERO   = NOP;

	typedef enum logic [2 : 0] {MULT_, DIV_} mult_op_enum;
	typedef enum logic [2 : 0] {ADD_, SUB_, GT, GE, LT, LE, EQ} arith_op_enum;
	typedef enum logic [2 : 0] {AND_, OR_, XOR_} logic_op_enum;
	typedef enum logic [2 : 0] {HI, LO} move_op_enum;
	typedef enum logic [2 : 0] {LL, RL, RA} shift_op_enum;

	typedef union packed{
		mult_op_enum mult;
		arith_op_enum arith;
		logic_op_enum logic_;
		move_op_enum move;
		shift_op_enum shift;
	} aluop_t;

	//
	typedef struct packed {
		aluop_t specific_op;
		logic sign;
		logic error;
	} aluop_enum;

	localparam ALUOP_ZERO     = 5'b00000;

// extract the info about load/stroe from inst to memop

	typedef enum logic [1 : 0] {NONE, LOAD, STORE} ls_type_enum;
	localparam LS_TYPE_ZERO   = NONE;
	typedef enum logic [1 : 0] {WORD, HALF, BYTE} ls_width_enum;
	localparam LS_WIDTH_ZERO  = WORD;

	typedef struct packed{
		ls_type_enum is_ls;
		ls_width_enum ls_width;
	} memop;

	typedef enum logic [5 : 0] {
		// alu
		ADDI  = 6'b001000,
		ADDIU = 6'b001001,
		SLTI  = 6'b001010,
		SLTIU = 6'b001011,
		ANDI  = 6'b001100,
		ORI   = 6'b001101,
		XORI  = 6'b001110,
		LUI   = 6'b001111,
		// load/store
		LB    = 6'b100000,
		LBU   = 6'b100100,
		LH    = 6'b100001,
		LHU   = 6'b100101,
		LW    = 6'b100011,
		SB    = 6'b101000,
		SH    = 6'b101001,
		SW    = 6'b101011
	} opcode_enum;

	typedef enum logic [5 : 0] {
		ADD   = 6'b100000,
		ADDU  = 6'b100001,
		SUB   = 6'b100010,
		SUBU  = 6'b100011,
		SLT   = 6'b101010,
		SLTU  = 6'b101011,
		AND   = 6'b100100,
		OR    = 6'b100101,
		NOR   = 6'b100111,
		XOR   = 6'b100110,
		SLL   = 6'b000000,
		SRL   = 6'b000010,
		SRA   = 6'b000011,
		SLLV  = 6'b000100,
		SRLV  = 6'b000110,
		SRAV  = 6'b000111,
		MULT  = 6'b011000,
		MULTU = 6'b011001,
		DIV   = 6'b011010,
		DIVU  = 6'b011011,
		MFHI  = 6'b010000,
		MFLO  = 6'b010010,
		MTHI  = 6'b010001,
		MTLO  = 6'b010011
	} func_enum;

	typedef struct packed{
		opcode_enum op;
		logic [4 : 0] rs;
		logic [4 : 0] rt;
		logic [15 : 0] imm;
	} inst_i_t;

	typedef struct packed{
		opcode_enum op;
		logic [4 : 0] rs;
		logic [4 : 0] rt;
		logic [4 : 0] rd;
		logic [4 : 0] sa;
		func_enum func;
	} inst_r_t;

	typedef struct packed{
		opcode_enum op;
		logic [25 : 0] index;
	} inst_j_t;


	typedef union packed{
		inst_i_t i;
		inst_r_t r;
		inst_j_t j;
	} inst_t;

endpackage
