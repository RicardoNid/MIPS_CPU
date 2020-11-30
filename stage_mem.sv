//

import mips_cpu_pkg::*;

module stage_mem (
		// interface with dm
		output logic                dmce,
		output logic                dmwe,
		output dm_addr_t            dmaddr,
		output reg_t                dmdin,
		input  reg_t                dmdout,
		// interface with regs_exemem
		input  logic                mem_i_dm2rf,
		input  logic                mem_i_hilowe,
		input  logic                mem_i_rfwe,
		input  reg_addr_t           mem_i_rfwa,
		input  double_reg_t         mem_i_mulres,
		input  reg_t                mem_i_alures,
		input  reg_t                mem_i_dmdin,
		input  memop                mem_i_memop,
		// interface with regs_memwb
		output logic                mem_o_dm2rf,
		output logic                mem_o_hilowe,
		output logic                mem_o_rfwe,
		output logic        [3 : 0] mem_o_bytesel,
		output reg_addr_t           mem_o_rfwa,
		output double_reg_t         mem_o_mulres,
		output reg_t                mem_o_alures,
		output reg_t                mem_o_dmdout
	);

// passthrough
	assign mem_o_dm2rf  = mem_i_dm2rf;
	assign mem_o_hilowe = mem_i_hilowe;
	assign mem_o_rfwe   = mem_i_rfwe;
	assign mem_o_rfwa   = mem_i_rfwa;
	assign mem_o_mulres = mem_i_mulres;
	assign mem_o_alures = mem_i_alures;
	assign dmdin        = mem_i_dmdin;
	assign mem_o_dmdout = dmdout;
	assign dmaddr       = mem_i_alures;

// MCU
	always_comb begin
		unique case (mem_i_memop.ls_width)
			WORD : mem_o_bytesel    = 4'b1111;
			HALF : mem_o_bytesel    = 4'b0011;
			BYTE : mem_o_bytesel    = 4'b0001;
			default : mem_o_bytesel = 4'b1111;
		endcase;

		unique case (mem_i_memop.is_ls)
			NONE : begin
				dmce = 1'b0;
				dmwe = 1'b0;
			end
			LOAD : begin
				dmce = 1'b1;
				dmwe = 1'b0;

			end
			STORE : begin
				dmce = 1'b1;
				dmwe = 1'b1;
			end
			default : begin
				dmce = 1'b0;
				dmwe = 1'b0;
			end
		endcase

	end



endmodule