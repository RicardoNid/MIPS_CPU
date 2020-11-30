//

import mips_cpu_pkg::*;

module im (
		input  logic     cpu_clk_50M,
		input  logic     cpu_rst_n,

		input  im_addr_t imaddr,
		input  logic     imce,
		output inst_t    inst
	);

	// 8K BRAM
	reg_t mem [IM_DEPTH];
	// sync write, sync read
	// ROM, no write
	initial
	begin
	// todo : initial value
	end

	always_ff @(posedge cpu_clk_50M) begin
		if (imce) begin
			if (!cpu_rst_n)
				inst <= ZERO;
			else
				inst <= mem[imaddr];
		end
	end
endmodule
