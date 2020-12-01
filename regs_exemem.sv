//

import mips_cpu_pkg::*;

module regs_exemem (
        input  logic         cpu_clk_50M,
        input  logic         cpu_rst_n,
        // signal from exe stage
        input  logic         exe_o_dm2rf,
        input  logic         exe_o_hilowe,
        input  logic         exe_o_rfwe,
        input  reg_enum      exe_o_rfwa,
        input  double_word_t exe_o_mulres,
        input  word_t        exe_o_alures,
        input  word_t        exe_o_dmdin,
        input  memop_struct  exe_o_memop,
        // signal to mem stage
        output logic         mem_i_dm2rf,
        output logic         mem_i_hilowe,
        output logic         mem_i_rfwe,
        output reg_enum      mem_i_rfwa,
        output double_word_t mem_i_mulres,
        output word_t        mem_i_alures,
        output word_t        mem_i_dmdin,
        output memop_struct  mem_i_memop
    );

    always_ff @ (posedge cpu_clk_50M) begin
        if(!cpu_rst_n) begin
            mem_i_dm2rf  <= 1'b0;
            mem_i_hilowe <= 1'b0;
            mem_i_rfwe   <= 1'b0;
            mem_i_rfwa   <= REG_ZERO;
            mem_i_mulres <= {ZERO, ZERO};
            mem_i_alures <= ZERO;
            mem_i_dmdin  <= ZERO;
            mem_i_memop  <= ZERO;
        end else begin
            mem_i_dm2rf  <= exe_o_dm2rf;
            mem_i_hilowe <= exe_o_hilowe;
            mem_i_rfwe   <= exe_o_rfwe;
            mem_i_rfwa   <= exe_o_rfwa;
            mem_i_mulres <= exe_o_mulres;
            mem_i_alures <= exe_o_alures;
            mem_i_dmdin  <= exe_o_dmdin;
            mem_i_memop  <= exe_o_memop;
        end
    end

endmodule
