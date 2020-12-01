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
        mem[0] = reverse(inst_t'({ADDI, REG_T0, REG_T7, 16'd127}));
        mem[1] = reverse(inst_t'({ADDI, REG_T7, REG_T0, 16'd127}));
        mem[2] = reverse(inst_t'({ADDI, REG_T0, REG_T7, 16'd127}));
        mem[3] = reverse(inst_t'({ADDI, REG_T7, REG_T0, 16'd127}));
        mem[4] = reverse(inst_t'({ADDI, REG_T0, REG_T7, 16'd127}));
        mem[5] = reverse(inst_t'({ADDI, REG_T7, REG_T0, 16'd127}));
        mem[6] = reverse(inst_t'({ADDI, REG_T0, REG_T7, 16'd127}));
        mem[7] = reverse(inst_t'({ADDI, REG_T7, REG_T0, 16'd127}));
        mem[8] = reverse(inst_t'({ADDI, REG_T0, REG_T7, 16'd127}));
        mem[9] = reverse(inst_t'({ADDI, REG_T7, REG_T0, 16'd127}));
    end

    always_ff @(posedge cpu_clk_50M) begin
        if (imce) begin
            if (imwe)
                mem[imaddr] <= imdin;
            if (!cpu_rst_n)
                inst        <= ZERO;
            else
                inst        <= mem[imaddr / 4];
        end
    end
endmodule
