//

import mips_cpu_pkg::*;

module regs_idexe (
		input  logic        cpu_clk_50M,
		input  logic        cpu_rst_n,
// signal from id stage
		input  logic        id_o_dm2rf,
		input  logic        id_o_hilowe,
		input  logic        id_o_rfwe,
		input  alutype_enum id_o_alutype,
		input  aluop_enum   id_o_aluop,
		input  reg_addr_t   id_o_rfwa,
		input  reg_t        id_o_src1,
		input  reg_t        id_o_src2,
		input  reg_t        id_o_dmdin,
		input  memop        id_o_memop,
// signal to exe stage
		output logic        exe_i_dm2rf,
		output logic        exe_i_hilowe,
		output logic        exe_i_rfwe,
		output alutype_enum exe_i_alutype,
		output aluop_enum   exe_i_aluop,
		output reg_addr_t   exe_i_rfwa,
		output reg_t        exe_i_src1,
		output reg_t        exe_i_src2,
		output reg_t        exe_i_dmdin,
		output memop        exe_i_memop
	);

	always_ff @ (posedge cpu_clk_50M) begin
		if(!cpu_rst_n) begin
			exe_i_dm2rf   <= 1'b0;
			exe_i_hilowe  <= 1'b0;
			exe_i_rfwe    <= 1'b0;
			exe_i_alutype <= ALUTYPE_ZERO;
			exe_i_aluop   <= ALUOP_ZERO;
			exe_i_rfwa    <= ZERO;
			exe_i_src1    <= ZERO;
			exe_i_src2    <= ZERO;
			exe_i_dmdin   <= ZERO;
			exe_i_memop   <= ZERO;
		end
		else begin
			exe_i_dm2rf   <= id_o_dm2rf;
			exe_i_hilowe  <= id_o_hilowe;
			exe_i_rfwe    <= id_o_rfwe;
			exe_i_alutype <= id_o_alutype;
			exe_i_aluop   <= id_o_aluop;
			exe_i_rfwa    <= id_o_rfwa;
			exe_i_src1    <= id_o_src1;
			exe_i_src2    <= id_o_src2;
			exe_i_dmdin   <= id_o_dmdin;
			exe_i_memop   <= id_o_memop;
		end
	end

endmodule
