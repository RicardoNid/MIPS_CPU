//

import mips_cpu_pkg::*;

module im (
        input  logic     cpu_clk_50M,
        input  logic     cpu_rst_n,

        input  im_addr_t imaddr,
        input  logic     imwe,
        input  inst_t    imdin,
        input  logic     imce,
        output inst_t    inst
    );

    // 8K BRAM
    inst_t mem [IM_DEPTH];
    // sync write, sync read
    // ROM, no write

    initial begin
        for (int i=0; i<(IM_DEPTH/5); i++) begin
            mem[i * 5] = reverse(inst_t'({ADDIU, REG_T0, REG_T1, 16'd127}));
            mem[i*5+1] = reverse(inst_t'({SW, REG_ZERO, REG_T1, 16'd16}));
            mem[i*5+2] = reverse(inst_t'({ADDIU, REG_T1, REG_T2, 16'd127}));
            mem[i*5+3] = reverse(inst_t'({LW, REG_ZERO, REG_T4, 16'd16}));
            mem[i*5+4] = reverse(inst_t'({ADDIU, REG_T2, REG_T3, 16'd127}));
        end
    end

    always_ff @(posedge cpu_clk_50M) begin
        if (imce) begin
            if (imwe)
                mem[imaddr] <= imdin;
            if (!cpu_rst_n)
                inst        <= ZERO;
            else
                inst        <= mem[imaddr];
        end
    end
endmodule
