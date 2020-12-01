//

import mips_cpu_pkg::*;

module regs_ifid (
		input  inst_t inst,

		output inst_t id_i_inst
	);

// passthrough
	assign id_i_inst = inst;

endmodule
