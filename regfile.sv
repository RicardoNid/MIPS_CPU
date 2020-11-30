//

import mips_cpu_pkg::*;

module regfile (
		input  logic      cpu_clk_50M,
		input  logic      cpu_rst_n,
		input  logic      rfre1,
		input  reg_addr_t rfra1,
		output reg_t      rfrd1,
		input  logic      rfre2,
		input  reg_addr_t rfra2,
		output reg_t      rfrd2,
		input  logic      rfwe,
		input  reg_addr_t rfwa,
		input  reg_t      rfwd
	);

	reg_t regs [NUM_REG];
	// sync write
	always_ff @ (posedge cpu_clk_50M) begin
		if(!cpu_rst_n) begin
			regs <= '{default : ZERO};
		end
		else begin
			if(rfwe && rfwa != REG_NOP)
				regs[rfwa] <= rfwd;
		end
	end
	
	// async read
	always_comb begin
		rfrd1 = (!cpu_rst_n || rfra1 == REG_NOP || !rfre1) ?  ZERO : regs[rfra1];
		rfrd2 = (!cpu_rst_n || rfra2 == REG_NOP || !rfre2) ?  ZERO : regs[rfra2];		
	end

endmodule
