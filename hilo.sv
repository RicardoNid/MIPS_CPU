//

import mips_cpu_pkg::*;

module hilo (
		input  logic cpu_clk_50M,
		input  logic cpu_rst_n,
		input  logic hilowe,
		input  word_t hi_i,
		input  word_t lo_i,
		output word_t hi_o,
		output word_t lo_o
	);

// sync write, async read, hi_o & lo_o are registers
always_ff @ (posedge cpu_clk_50M) begin
	if(!cpu_rst_n) begin
		hi_o <= ZERO;
		lo_o <= ZERO;
	end
	else if(hilowe) begin
		hi_o <= hi_i;
		lo_o <= lo_i;
	end
end

endmodule
