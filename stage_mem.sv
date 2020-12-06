// handle mem load/store according to memop

import mips_cpu_pkg::*;

module stage_mem (
        // interface with dm
        output logic                 dmce,
        output logic                 dmwe,
        output dm_addr_t             dmaddr,
        output word_t                dmdin,
        input  word_t                dmdout,
        // interface with regs_exemem
        input  logic                 mem_i_dm2rf,
        input  logic                 mem_i_hilowe,
        input  logic                 mem_i_rfwe,
        input  reg_enum              mem_i_rfwa,
        input  double_word_t         mem_i_mulres,
        input  word_t                mem_i_alures,
        input  word_t                mem_i_dmdin,
        input  memop_struct          mem_i_memop,
        // interface with regs_memwb
        output logic                 mem_o_dm2rf,
        output logic                 mem_o_hilowe,
        output logic                 mem_o_rfwe,
        output logic         [3 : 0] mem_o_bytesel,
        output reg_enum              mem_o_rfwa,
        output double_word_t         mem_o_mulres,
        output word_t                mem_o_alures,
        output word_t                mem_o_dmdout
    );

    // passthrough
    assign mem_o_dm2rf  = mem_i_dm2rf;
    assign mem_o_hilowe = mem_i_hilowe;
    assign mem_o_rfwe   = mem_i_rfwe;
    assign mem_o_rfwa   = mem_i_rfwa;
    assign mem_o_mulres = mem_i_mulres;
    assign mem_o_alures = mem_i_alures;
    assign dmdin        = mem_i_dmdin;
    assign mem_o_dmdout = dmdout;
    assign dmaddr       = mem_i_alures;

    // MCU
    always_comb begin
        unique case (mem_i_memop.ls_width)
            MEM_WORD : mem_o_bytesel = 4'b1111;
            MEM_HALF : mem_o_bytesel = 4'b0011;
            MEM_BYTE : mem_o_bytesel = 4'b0001;
        endcase;

        unique case (mem_i_memop.ls_type)
            MEM_NONE : begin
                dmce = 1'b0;
                dmwe = 1'b0;
            end
            MEM_LOAD : begin
                dmce = 1'b1;
                dmwe = 1'b0;

            end
            MEM_STORE : begin
                dmce = 1'b1;
                dmwe = 1'b1;
            end
            default : begin
                dmce = 1'b0;
                dmwe = 1'b0;
            end
        endcase
    end

endmodule