//

import mips_cpu_pkg::*;

module stage_if (
		input  logic     cpu_clk_50M,
		input  logic     cpu_rst_n,
		// interface with im
		output im_addr_t imaddr,
		output logic     imce
	);

	im_addr_t addr_next;
	assign addr_next = imaddr + 4;

	always_ff @ (posedge cpu_clk_50M) begin
		if(!cpu_rst_n) begin
			imaddr <= PC_INIT;
			imce   <= 1'b0;
		end
		else begin
			imaddr <= addr_next;
			imce   <= 1'b1;
		end
	end

endmodule
