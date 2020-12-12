//

import mips_cpu_pkg::*;

module stage_wb (
        // interface with regs_memwb
        input  logic                 wb_i_dm2rf,
        input  logic                 wb_i_hilowe,
        input  logic                 wb_i_rfwe,
        input  logic         [3 : 0] wb_i_bytesel,
        input  logic                 wb_i_loadsign,
        input  reg_enum              wb_i_rfwa,
        input  double_word_t         wb_i_mulres,
        input  word_t                wb_i_alures,
        input  word_t                wb_i_dmdout,
        // interface with regfile and hilo
        output logic                 rfwe,
        output reg_enum              rfwa,
        output word_t                rfwd,
        output logic                 hilowe,
        output word_t                hi_i,
        output word_t                lo_i
    );

    // passthrough, connected to storage
    assign rfwe   = wb_i_rfwe;
    assign rfwa   = wb_i_rfwa;
    assign hilowe = wb_i_hilowe;
    assign hi_i   = wb_i_mulres[63 : 32];
    assign lo_i   = wb_i_mulres[31 : 0];

    // datapath
    // fixme : improve logic
    word_t ext_masked_dmdout;
    always_comb begin
        if(wb_i_loadsign && wb_i_bytesel[1] == 0) begin
            ext_masked_dmdout[7 : 0]   = wb_i_dmdout[7 : 0];
            ext_masked_dmdout[31 : 8]  ={24{wb_i_dmdout[7]}};
        end else if(wb_i_loadsign && wb_i_bytesel[2] == 0)begin
            ext_masked_dmdout[15 : 0]  = wb_i_dmdout[15 : 0];
            ext_masked_dmdout[31 : 16] ={16{wb_i_dmdout[15]}};
        end else begin
            ext_masked_dmdout          = wb_i_dmdout;
        end
    end

    assign rfwd   = wb_i_dm2rf ? ext_masked_dmdout : wb_i_alures;

endmodule
