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
        mem[1] = reverse(inst_t'({ ORI, REG_ZERO, REG_AT, 16'h64})) ;
        mem[2] = reverse(inst_t'({ LUI, 5'h0, REG_V0, 16'h6500})) ;
        mem[3] = reverse(inst_t'({ 32'h0 })) ;
        mem[4] = reverse(inst_t'({ 32'h0 })) ;
        mem[5] = reverse(inst_t'({ ADDIU, REG_AT, REG_V1, 16'h4})) ;
        mem[6] = reverse(inst_t'({ SLTIU, REG_AT, REG_A0, 16'h68})) ;
        mem[7] = reverse(inst_t'({ 6'h0, REG_AT, REG_V0, REG_A1, 5'h0, ADD})) ;
        mem[8] = reverse(inst_t'({ 6'h0, REG_V0, REG_AT, REG_A2, 5'h0, SUBU})) ;
        mem[9] = reverse(inst_t'({ 6'h0, REG_AT, REG_V0, REG_A3, 5'h0, SLT})) ;
        mem[10]= reverse(inst_t'({ 6'h0, REG_AT, REG_V0, REG_T0, 5'h0, AND})) ;
        mem[11]= reverse(inst_t'({ ORI, REG_AT, REG_T1, 16'h65})) ;
        mem[12]= reverse(inst_t'({ 6'h0, REG_ZERO, REG_AT, REG_T2, 5'h4, SLL})) ;
        mem[13]= reverse(inst_t'({ 6'h0, REG_AT, REG_V0, REG_ZERO, 5'h0, MULT})) ;
        mem[14]= reverse(inst_t'({ 32'h0 })) ;
        mem[15]= reverse(inst_t'({ 32'h0 })) ;
        mem[16]= reverse(inst_t'({ 16'h0, REG_T3,5'h0,MFHI})) ;
        mem[17]= reverse(inst_t'({ 16'h0, REG_T4,5'h0,MFLO})) ;
        mem[18]= reverse(inst_t'({ 32'h0 })) ;
        mem[19]= reverse(inst_t'({ORI,REG_ZERO, REG_AT, 16'hff})) ;
        mem[20]= reverse(inst_t'({32'd0})) ;
        mem[21]= reverse(inst_t'({32'd0})) ;
        mem[22]= reverse(inst_t'({SB, REG_ZERO, REG_AT, 16'h03})) ;
        mem[23]= reverse(inst_t'({ORI, REG_ZERO, REG_AT, 16'hee})) ;
        mem[24]= reverse(inst_t'({32'd0})) ;
        mem[25]= reverse(inst_t'({32'd0})) ;
        mem[26]= reverse(inst_t'({SB, REG_ZERO, REG_AT, 16'h02})) ;
        mem[27]= reverse(inst_t'({ORI, REG_ZERO, REG_AT, 16'hdd})) ;
        mem[28]= reverse(inst_t'({32'd0})) ;
        mem[29]= reverse(inst_t'({32'd0})) ;
        mem[30]= reverse(inst_t'({SB, REG_ZERO, REG_AT, 16'h01})) ;
        mem[31]= reverse(inst_t'({ORI, REG_ZERO, REG_AT, 16'hcc})) ;
        mem[32]= reverse(inst_t'({32'd0})) ;
        mem[33]= reverse(inst_t'({32'd0})) ;
        mem[34]= reverse(inst_t'({SB, REG_ZERO, REG_AT, 16'h00})) ;
        mem[35]= reverse(inst_t'({LB, REG_ZERO, REG_V0, 16'h03})) ;
        mem[36]= reverse(inst_t'({32'd0})) ;
        mem[37]= reverse(inst_t'({LUI, REG_ZERO, REG_AT, 16'h4455})) ;
        mem[38]= reverse(inst_t'({32'd0})) ;
        mem[39]= reverse(inst_t'({32'd0})) ;
        mem[40]= reverse(inst_t'({32'd0})) ;
        mem[41]= reverse(inst_t'({ORI, REG_AT, REG_AT, 16'h6677})) ;
        mem[42]= reverse(inst_t'({32'd0})) ;
        mem[43]= reverse(inst_t'({32'd0})) ;
        mem[44]= reverse(inst_t'({SW, REG_ZERO, REG_AT, 16'h08})) ;
        mem[45]= reverse(inst_t'({32'd0})) ;
        mem[46]= reverse(inst_t'({32'd0})) ;
        mem[47]= reverse(inst_t'({32'd0})) ;
        mem[48]= reverse(inst_t'({LW, REG_ZERO, REG_V0, 16'h08})) ;
        mem[49]= reverse(inst_t'({32'd0})) ;
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
