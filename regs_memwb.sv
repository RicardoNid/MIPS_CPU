//

import mips_cpu_pkg::*;

module regs_memwb (
        input  logic                 cpu_clk_50M,
        input  logic                 cpu_rst_n,
        // signal from mem stage
        input  logic                 mem_o_dm2rf,
        input  logic                 mem_o_hilowe,
        input  logic                 mem_o_rfwe,
        input  logic         [3 : 0] mem_o_bytesel,
        input  reg_enum            mem_o_rfwa,
        input  double_word_t         mem_o_mulres,
        input  word_t                mem_o_alures,
        input  word_t                mem_o_dmdout,
        // signal to wb stage
        output logic                 wb_i_dm2rf,
        output logic                 wb_i_hilowe,
        output logic                 wb_i_rfwe,
        output logic         [3 : 0] wb_i_bytesel,
        output reg_enum            wb_i_rfwa,
        output double_word_t         wb_i_mulres,
        output word_t                wb_i_alures,
        output word_t                wb_i_dmdout
    );

    always_ff @ (posedge cpu_clk_50M) begin
        if(!cpu_rst_n) begin
            wb_i_dm2rf   <= 1'b0;
            wb_i_hilowe  <= 1'b0;
            wb_i_rfwe    <= 1'b0;
            wb_i_bytesel <= 4'b0000;
            wb_i_rfwa    <= REG_ZERO;
            wb_i_mulres  <= {ZERO, ZERO};
            wb_i_alures  <= ZERO;
        end else begin
            wb_i_dm2rf   <= mem_o_dm2rf;
            wb_i_hilowe  <= mem_o_hilowe;
            wb_i_rfwe    <= mem_o_rfwe;
            wb_i_bytesel <= mem_o_bytesel;
            wb_i_rfwa    <= mem_o_rfwa;
            wb_i_mulres  <= mem_o_mulres;
            wb_i_alures  <= mem_o_alures;
        end
    end

    // passthourgh
    assign wb_i_dmdout = mem_o_dmdout;

endmodule
