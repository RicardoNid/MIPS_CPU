//

import mips_cpu_pkg::*;

module stage_wb (
		// interface with regs_memwb
		input  logic                wb_i_dm2rf,
		input  logic                wb_i_hilowe,
		input  logic                wb_i_rfwe,
		input  logic        [3 : 0] wb_i_bytesel,
		input  reg_addr_t           wb_i_rfwa,
		input  double_reg_t         wb_i_mulres,
		input  reg_t                wb_i_alures,
		input  reg_t                wb_i_dmdout,
		// interface with regfile and hilo
		output logic                rfwe,
		output reg_addr_t           rfwa,
		output reg_t                rfwd,
		output logic                hilowe,
		output reg_t                hi_i,
		output reg_t                lo_i
	);

// passthrough
	assign rfwe        = wb_i_rfwe;
	assign rfwa        = wb_i_rfwa;
	assign hilowe      = wb_i_hilowe;
	assign hi_i        = wb_i_mulres[63 : 32];
	assign lo_i        = wb_i_mulres[31 : 0];
// datapath
	reg_t masked_dmout = {
		{{8{wb_i_bytesel[0]}} & wb_i_dmdout[7 : 0]},
		{{8{wb_i_bytesel[1]}} & wb_i_dmdout[15 : 8]},
		{{8{wb_i_bytesel[2]}} & wb_i_dmdout[23 : 16]},
		{{8{wb_i_bytesel[3]}} & wb_i_dmdout[31 : 24]}
	};
	assign rfwd        = wb_i_dm2rf ? masked_dmout : wb_i_alures;

endmodule
