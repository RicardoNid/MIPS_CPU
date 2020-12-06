import mips_cpu_pkg::*;

module minimips_tb;

    reg    cpu_clk_50M;
    reg    cpu_rst_n;
    reg    en;
    inst_t outer_inst;
    word_t peek1;
    word_t peek2;

    minimips dut (
        .cpu_clk_50M(cpu_clk_50M),
        .cpu_rst_n(cpu_rst_n),
        .en(en),
        .outer_inst(outer_inst),
        .peek1(peek1),
        .peek2(peek2)
    );

    initial begin
        cpu_clk_50M = 0;
        cpu_rst_n   = 0; en = 0;
        #10;
        cpu_rst_n   = 1; en = 1;

    end

    always
        #5 cpu_clk_50M = ! cpu_clk_50M;

//    always
//        #10 $display(minimips.rfwe, minimips.rfwa, minimips.rfwd);

endmodule
