//

import mips_cpu_pkg::*;

module minimips (
        input  logic  cpu_clk_50M,
        input  logic  cpu_rst_n,
        input  logic  en,
        input  inst_t outer_inst,
        output word_t peek1,
        output word_t peek2
    );

    logic                 rfre1;
    reg_enum              rfra1;
    logic                 rfre2;
    reg_enum              rfra2;
    logic                 rfwe;
    reg_enum              rfwa;
    word_t                rfwd;
    word_t                rfrd1;
    word_t                rfrd2;

    regfile u_regfile (
        // Inputs
        .cpu_clk_50M(cpu_clk_50M),
        .cpu_rst_n (cpu_rst_n),
        .rfra1 (rfra1),
        .rfra2 (rfra2),
        .rfre1 (rfre1),
        .rfre2 (rfre2),
        .rfwa (rfwa),
        .rfwd (rfwd),
        .rfwe (rfwe),
        // Outputs
        .rfrd1 (rfrd1),
        .rfrd2 (rfrd2)
     );

    logic                 hilowe;
    word_t                hi_i;
    word_t                lo_i;
    word_t                hi_o;
    word_t                lo_o;

    hilo u_hilo (
        // Inputs
        .cpu_clk_50M(cpu_clk_50M),
        .cpu_rst_n (cpu_rst_n),
        .hi_i (hi_i),
        .hilowe (hilowe),
        .lo_i (lo_i),
        // Outputs
        .hi_o (hi_o),
        .lo_o (lo_o)
    );

    im_addr_t             imaddr;
    logic                 imce;
    inst_t                inst;

    im u_im (
        // Inputs
        .cpu_clk_50M(cpu_clk_50M),
        .cpu_rst_n (cpu_rst_n),
        .imaddr (imaddr),
        .imwe(en),
        .imdin(outer_inst),
        .imce (imce),
        // Outputs
        .inst (inst)
    );

    logic                 dmce;
    logic                 dmwe;
    dm_addr_t             dmaddr;
    word_t                dmdin;
    word_t                dmdout;

    dm u_dm (
        // Inputs
        .cpu_clk_50M(cpu_clk_50M),
        .cpu_rst_n (cpu_rst_n),
        .dmaddr (dmaddr),
        .dmce (dmce),
        .dmdin (dmdin),
        .dmwe (dmwe),
        // Outputs
        .dmdout (dmdout)
    );

    inst_t                id_i_inst;

    regs_ifid u_regs_ifid (
        // Inputs
        .inst (inst),
        // Outputs
        .id_i_inst(id_i_inst)
    );

    logic                 id_o_dm2rf;
    logic                 id_o_hilowe;
    logic                 id_o_rfwe;
    alutype_enum          id_o_alutype;
    aluop_struct          id_o_aluop;
    reg_enum              id_o_rfwa;
    word_t                id_o_src1;
    word_t                id_o_src2;
    word_t                id_o_dmdin;
    memop_struct          id_o_memop;
    logic                 exe_i_dm2rf;
    logic                 exe_i_hilowe;
    logic                 exe_i_rfwe;
    alutype_enum          exe_i_alutype;
    aluop_struct          exe_i_aluop;
    reg_enum              exe_i_rfwa;
    word_t                exe_i_src1;
    word_t                exe_i_src2;
    word_t                exe_i_dmdin;
    memop_struct          exe_i_memop;

    regs_idexe u_regs_idexe (
        // Inputs
        .cpu_clk_50M (cpu_clk_50M),
        .cpu_rst_n (cpu_rst_n),
        .id_o_aluop (id_o_aluop),
        .id_o_alutype (id_o_alutype),
        // signal from id stage
        .id_o_dm2rf (id_o_dm2rf),
        .id_o_dmdin (id_o_dmdin),
        .id_o_hilowe (id_o_hilowe),
        .id_o_memop (id_o_memop),
        .id_o_rfwa (id_o_rfwa),
        .id_o_rfwe (id_o_rfwe),
        .id_o_src1 (id_o_src1),
        .id_o_src2 (id_o_src2),
        // Outputs
        .exe_i_aluop (exe_i_aluop),
        .exe_i_alutype(exe_i_alutype),
        // signal to exe stage
        .exe_i_dm2rf (exe_i_dm2rf),
        .exe_i_dmdin (exe_i_dmdin),
        .exe_i_hilowe (exe_i_hilowe),
        .exe_i_memop (exe_i_memop),
        .exe_i_rfwa (exe_i_rfwa),
        .exe_i_rfwe (exe_i_rfwe),
        .exe_i_src1 (exe_i_src1),
        .exe_i_src2 (exe_i_src2)
    );

    logic                 exe_o_dm2rf;
    logic                 exe_o_hilowe;
    logic                 exe_o_rfwe;
    reg_enum              exe_o_rfwa;
    double_word_t         exe_o_mulres;
    word_t                exe_o_alures;
    word_t                exe_o_dmdin;
    memop_struct          exe_o_memop;

    logic                 mem_i_dm2rf;
    logic                 mem_i_hilowe;
    logic                 mem_i_rfwe;
    reg_enum              mem_i_rfwa;
    double_word_t         mem_i_mulres;
    word_t                mem_i_alures;
    word_t                mem_i_dmdin;
    memop_struct          mem_i_memop;

    regs_exemem u_regs_exemem (
        // Inputs
        .cpu_clk_50M (cpu_clk_50M),
        .cpu_rst_n (cpu_rst_n),
        .exe_o_alures(exe_o_alures),
        // signal from exe stage
        .exe_o_dm2rf (exe_o_dm2rf),
        .exe_o_dmdin (exe_o_dmdin),
        .exe_o_hilowe(exe_o_hilowe),
        .exe_o_memop (exe_o_memop),
        .exe_o_mulres(exe_o_mulres),
        .exe_o_rfwa (exe_o_rfwa),
        .exe_o_rfwe (exe_o_rfwe),
        // Outputs
        .mem_i_alures(mem_i_alures),
        // signal to mem stage
        .mem_i_dm2rf (mem_i_dm2rf),
        .mem_i_dmdin (mem_i_dmdin),
        .mem_i_hilowe(mem_i_hilowe),
        .mem_i_memop (mem_i_memop),
        .mem_i_mulres(mem_i_mulres),
        .mem_i_rfwa (mem_i_rfwa),
        .mem_i_rfwe (mem_i_rfwe)
    );

    logic                 mem_o_dm2rf;
    logic                 mem_o_hilowe;
    logic                 mem_o_rfwe;
    logic         [3 : 0] mem_o_bytesel;
    reg_enum              mem_o_rfwa;
    double_word_t         mem_o_mulres;
    word_t                mem_o_alures;
    word_t                mem_o_dmdout;

    logic                 wb_i_dm2rf;
    logic                 wb_i_hilowe;
    logic                 wb_i_rfwe;
    logic         [3 : 0] wb_i_bytesel;
    reg_enum              wb_i_rfwa;
    double_word_t         wb_i_mulres;
    word_t                wb_i_alures;
    word_t                wb_i_dmdout;

    regs_memwb u_regs_memwb (
        // Inputs
        .cpu_clk_50M (cpu_clk_50M),
        .cpu_rst_n (cpu_rst_n),
        .mem_o_alures (mem_o_alures),
        .mem_o_bytesel(mem_o_bytesel),
        // signal from mem stage
        .mem_o_dm2rf (mem_o_dm2rf),
        .mem_o_dmdout (mem_o_dmdout),
        .mem_o_hilowe (mem_o_hilowe),
        .mem_o_mulres (mem_o_mulres),
        .mem_o_rfwa (mem_o_rfwa),
        .mem_o_rfwe (mem_o_rfwe),
        // Outputs
        .wb_i_alures (wb_i_alures),
        .wb_i_bytesel (wb_i_bytesel),
        // signal to wb stage
        .wb_i_dm2rf (wb_i_dm2rf),
        .wb_i_dmdout (wb_i_dmdout),
        .wb_i_hilowe (wb_i_hilowe),
        .wb_i_mulres (wb_i_mulres),
        .wb_i_rfwa (wb_i_rfwa),
        .wb_i_rfwe (wb_i_rfwe)
    );

    stage_if u_stage_if (
        // Inputs
        .cpu_clk_50M(cpu_clk_50M),
        .cpu_rst_n (cpu_rst_n),
        // Outputs
        // interface with im
        .imaddr (imaddr),
        .imce (imce)
    );

    stage_id u_stage_id (
        // Inputs
        // interface with regs_ifid
        .id_i_inst (id_i_inst),
        .rfrd1 (rfrd1),
        .rfrd2 (rfrd2),
        // Outputs
        .id_o_aluop (id_o_aluop),
        .id_o_alutype(id_o_alutype),
        // interface with regs_idexe
        .id_o_dm2rf (id_o_dm2rf),
        .id_o_dmdin (id_o_dmdin),
        .id_o_hilowe (id_o_hilowe),
        .id_o_memop (id_o_memop),
        .id_o_rfwa (id_o_rfwa),
        .id_o_rfwe (id_o_rfwe),
        .id_o_src1 (id_o_src1),
        .id_o_src2 (id_o_src2),
        .rfra1 (rfra1),
        .rfra2 (rfra2),
        // interface with rf
        .rfre1 (rfre1),
        .rfre2 (rfre2)
    );

    stage_exe u_stage_exe (
        // Inputs
        .exe_i_aluop (exe_i_aluop),
        .exe_i_alutype(exe_i_alutype),
        // interface with regs_idexe
        .exe_i_dm2rf (exe_i_dm2rf),
        .exe_i_dmdin (exe_i_dmdin),
        .exe_i_hilowe (exe_i_hilowe),
        .exe_i_memop (exe_i_memop),
        .exe_i_rfwa (exe_i_rfwa),
        .exe_i_rfwe (exe_i_rfwe),
        .exe_i_src1 (exe_i_src1),
        .exe_i_src2 (exe_i_src2),
        // interface with hilo
        .hi_o (hi_o),
        .lo_o (lo_o),
        // Outputs
        .exe_o_alures (exe_o_alures),
        // interface with regs_exemem
        .exe_o_dm2rf (exe_o_dm2rf),
        .exe_o_dmdin (exe_o_dmdin),
        .exe_o_hilowe (exe_o_hilowe),
        .exe_o_memop (exe_o_memop),
        .exe_o_mulres (exe_o_mulres),
        .exe_o_rfwa (exe_o_rfwa),
        .exe_o_rfwe (exe_o_rfwe)
    );

    stage_mem u_stage_mem (
        // Inputs
        .dmdout (dmdout),
        .mem_i_alures (mem_i_alures),
        // interface with regs_exemem
        .mem_i_dm2rf (mem_i_dm2rf),
        .mem_i_dmdin (mem_i_dmdin),
        .mem_i_hilowe (mem_i_hilowe),
        .mem_i_memop (mem_i_memop),
        .mem_i_mulres (mem_i_mulres),
        .mem_i_rfwa (mem_i_rfwa),
        .mem_i_rfwe (mem_i_rfwe),
        // Outputs
        .dmaddr (dmaddr),
        // interface with dm
        .dmce (dmce),
        .dmdin (dmdin),
        .dmwe (dmwe),
        .mem_o_alures (mem_o_alures),
        .mem_o_bytesel(mem_o_bytesel),
        // interface with regs_memwb
        .mem_o_dm2rf (mem_o_dm2rf),
        .mem_o_dmdout (mem_o_dmdout),
        .mem_o_hilowe (mem_o_hilowe),
        .mem_o_mulres (mem_o_mulres),
        .mem_o_rfwa (mem_o_rfwa),
        .mem_o_rfwe (mem_o_rfwe)
    );

    stage_wb u_stage_wb (
        // Inputs
        .wb_i_alures (wb_i_alures),
        .wb_i_bytesel(wb_i_bytesel),
        // interface with regs_memwb
        .wb_i_dm2rf (wb_i_dm2rf),
        .wb_i_dmdout (wb_i_dmdout),
        .wb_i_hilowe (wb_i_hilowe),
        .wb_i_mulres (wb_i_mulres),
        .wb_i_rfwa (wb_i_rfwa),
        .wb_i_rfwe (wb_i_rfwe),
        // Outputs
        .hi_i (hi_i),
        .hilowe (hilowe),
        .lo_i (lo_i),
        .rfwa (rfwa),
        .rfwd (rfwd),
        // interface with regfile and hilo
        .rfwe (rfwe)
    );

    assign peek1 = rfrd1;
    assign peek2 = rfrd2;

endmodule
