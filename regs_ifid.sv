//

import mips_cpu_pkg::*;

module regs_ifid (
		input  inst_t inst,

		output inst_t id_i_inst
	);

//  always_ff @ (posedge cpu_clk_50M) begin
//      if(!cpu_rst_n) begin
//          id_i_inst <= ZERO;
//      end
//      else begin
//          id_i_inst <= inst;
//      end
//  end

// passthrough
	assign id_i_inst = inst;

endmodule
