// define all the parameters that would be used after

package mips_cpu_pkg;

    localparam WIDTH_INST     = 32;
    // parameters of regfile
    localparam WIDTH_REG      = 32;
    localparam NUM_REG        = 32;
    localparam WIDTH_REG_ADDR = $clog2(NUM_REG);
    typedef logic [31 : 0] word_t;
    typedef logic [63 : 0] double_word_t;
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

    typedef enum logic [3 : 0] {
        NOP   = 4'b0000,
        ARITH = 4'b0001,
        LOGIC = 4'b0010,
        MOVE  = 4'b0100,
        SHIFT = 4'b1000
    } alutype_enum;

    typedef enum logic [1 : 0] {ALU_MULT, ALU_DIV} mult_op_enum;
    typedef enum logic [1 : 0] {ALU_ADD, ALU_SUB, ALU_LT} arith_op_enum;
    typedef enum logic [1 : 0] {ALU_AND, ALU_OR, ALU_XOR, ALU_NOR} logic_op_enum;
    typedef enum logic [1 : 0] {ALU_HI, ALU_LO} move_op_enum;
    typedef enum logic [1 : 0] {ALU_LL, ALU_RL, ALU_RA} shift_op_enum;

    typedef union packed{
        mult_op_enum mult_op;
        arith_op_enum arith_op;
        logic_op_enum logic_op;
        move_op_enum move_op;
        shift_op_enum shift_op;
    } aluop_t;

    //
    typedef struct packed {
        aluop_t op;
        logic sign;
    } aluop_struct;

    localparam ALUOP_ZERO     = 5'b00000;

    // extract the info about load/stroe from inst to memop
    typedef enum logic [1 : 0] {MEM_NONE, MEM_LOAD, MEM_STORE} ls_type_enum;
    typedef enum logic [1 : 0] {MEM_WORD, MEM_HALF, MEM_BYTE} ls_width_enum;

    typedef struct packed{
        ls_type_enum ls_type;
        ls_width_enum ls_width;
        logic sign;
    } memop_struct;

    // todo : step-1 - opcode/func
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

    typedef enum logic [4 : 0] {
        REG_ZERO, REG_AT,
        REG_V0, REG_V1,
        REG_A0, REG_A1, REG_A2, REG_A3,
        REG_T0, REG_T1, REG_T2, REG_T3, REG_T4, REG_T5, REG_T6, REG_T7, REG_T8, REG_T9,
        REG_S0, REG_S1, REG_S2, REG_S3, REG_S4, REG_S5,REG_S6, REG_S7,
        REG_K0, REG_K1,
        REG_GP, REG_SP, REG_FP, REG_RA
    } reg_enum;

    typedef struct packed{
        opcode_enum op;
        reg_enum rs;
        reg_enum rt;
        logic [15 : 0] imm;
    } inst_i_t;

    typedef struct packed{
        opcode_enum op;
        reg_enum rs;
        reg_enum rt;
        reg_enum rd;
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
    
    function automatic inst_t reverse(inst_t origianl);
        return inst_t'({origianl[7 : 0], origianl[15 : 8], origianl[23 : 16], origianl[31 : 24]});
    endfunction

endpackage
