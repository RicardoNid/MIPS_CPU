//

import mips_cpu_pkg::*;

module dm (
		input  logic     cpu_clk_50M,
		input  logic     cpu_rst_n,

		input  logic     dmce,
		input  logic     dmwe,
		input  dm_addr_t dmaddr,
		input  reg_t     dmdin,
		output reg_t     dmdout
	);

	// 8K BRAM
	reg_t mem [IM_DEPTH];
	// sync write, sync read
	always_ff @(posedge cpu_clk_50M) begin
		if (dmce) begin
			if (dmwe)
				mem[dmaddr] <= dmdin;
			if (!cpu_rst_n)
				dmdout      <= ZERO;
			else
				dmdout      <= mem[dmaddr];
		end
	end

endmodule
