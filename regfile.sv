//

import mips_cpu_pkg::*;

module regfile (
        input  logic    cpu_clk_50M,
        input  logic    cpu_rst_n,
        input  logic    rfre1,
        input  reg_enum rfra1,
        output word_t   rfrd1,
        input  logic    rfre2,
        input  reg_enum rfra2,
        output word_t   rfrd2,
        input  logic    rfwe,
        input  reg_enum rfwa,
        input  word_t   rfwd
        , input logic [7:0] fix
    );

    word_t regs [NUM_REG];
    // sync write
    always_ff @ (posedge cpu_clk_50M) begin
        if(!cpu_rst_n) begin
            regs <= '{default : ZERO};
        end else begin
            // write on reg0 is forbidden
            if(rfwe && rfwa != REG_ZERO)
                regs[rfwa] <= rfwd;
        end
    end

    // async read
    always_comb begin
        rfrd1 = (!cpu_rst_n || rfra1 == REG_ZERO || !rfre1) ? ZERO : regs[rfra1];
        rfrd2 = (!cpu_rst_n || rfra2 == REG_ZERO || !rfre2) ? ZERO : regs[rfra2];
    end
    
    

endmodule






