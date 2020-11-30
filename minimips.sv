// top module

import mips_cpu_pkg::*;

module minimips (
		input logic cpu_clk_50M,
		input logic cpu_rst_n
	);

	// memories
	logic                rfre1;
	logic                rfra1;
	logic                rfrd1;
	logic                rfre2;
	logic                rfra2;
	logic                rfrd2;
	logic                rfwe;
	logic                rfwa;
	logic                rfwd;

	regfile u_regfile (
		.cpu_clk_50M(cpu_clk_50M),
		.cpu_rst_n  (cpu_rst_n  ),
		.rfra1      (rfra1      ),
		.rfra2      (rfra2      ),
		.rfrd1      (rfrd1      ),
		.rfrd2      (rfrd2      ),
		.rfre1      (rfre1      ),
		.rfre2      (rfre2      ),
		.rfwa       (rfwa       ),
		.rfwd       (rfwd       ),
		.rfwe       (rfwe       )
	);

	logic                hilowe;
	logic                hi_i;
	logic                lo_i;
	logic                hi_o;
	logic                lo_o;

	hilo u_hilo (
		.cpu_clk_50M(cpu_clk_50M),
		.cpu_rst_n  (cpu_rst_n  ),
		.hi_i       (hi_i       ),
		.hi_o       (hi_o       ),
		.hilowe     (hilowe     ),
		.lo_i       (lo_i       ),
		.lo_o       (lo_o       )
	);

	logic                imaddr;
	logic                imce;
	logic                inst;

	im u_im (
		.cpu_clk_50M(cpu_clk_50M),
		.cpu_rst_n  (cpu_rst_n  ),
		.imaddr     (imaddr     ),
		.imce       (imce       ),
		.inst       (inst       )
	);

	logic                dmce;
	logic                dmwe;
	logic                dmaddr;
	logic                dmdin;
	logic                dmdout;

	dm u_dm (
		.cpu_clk_50M(cpu_clk_50M),
		.cpu_rst_n  (cpu_rst_n  ),
		.dmdin      (dmdin      ),
		.dmaddr     (dmaddr     ),
		.dmce       (dmce       ),
		.dmwe       (dmwe       ),
		.dmdout     (dmdout     )
	);

	// pipeline regs
	logic                id_i_inst;

	regs_ifid u_regs_ifid (
		.id_i_inst (id_i_inst ),
		.inst      (inst      )
	);

	logic                id_o_dm2rf;
	logic                id_o_hilowe;
	logic                id_o_rfwe;
	alutype_enum         id_o_alutype;
	logic                id_o_aluop;
	logic                id_o_rfwa;
	logic                id_o_src1;
	logic                id_o_src2;
	logic                id_o_dmdin;
	logic                id_o_memop;
	logic                exe_i_dm2rf;
	logic                exe_i_hilowe;
	logic                exe_i_rfwe;
	alutype_enum         exe_i_alutype;
	aluop_enum           exe_i_aluop;
	logic                exe_i_rfwa;
	logic                exe_i_src1;
	logic                exe_i_src2;
	logic                exe_i_dmdin;
	logic                exe_i_memop;

	regs_idexe u_regs_idexe (
		  .cpu_clk_50M  (cpu_clk_50M  ),
		  .cpu_rst_n    (cpu_rst_n    ),
		  .exe_i_aluop  (exe_i_aluop  ),
		  .exe_i_alutype(exe_i_alutype),
		  // signal to exe stage
		  .exe_i_dm2rf  (exe_i_dm2rf  ),
		  .exe_i_dmdin  (exe_i_dmdin  ),
		  .exe_i_hilowe (exe_i_hilowe ),
		  .exe_i_rfwa   (exe_i_rfwa   ),
		  .exe_i_rfwe   (exe_i_rfwe   ),
		  .exe_i_src1   (exe_i_src1   ),
		  .exe_i_src2   (exe_i_src2   ),
		  .id_o_aluop   (id_o_aluop   ),
		  .id_o_alutype (id_o_alutype ),
		  .id_o_memop   (id_o_memop   )
		,
		  // signal from id stage
		  .id_o_dm2rf   (id_o_dm2rf   ),
		  .id_o_dmdin   (id_o_dmdin   ),
		  .id_o_hilowe  (id_o_hilowe  ),
		  .id_o_rfwa    (id_o_rfwa    ),
		  .id_o_rfwe    (id_o_rfwe    ),
		  .id_o_src1    (id_o_src1    ),
		  .id_o_src2    (id_o_src2    )
		, .exe_i_memop  (exe_i_memop  )
	);

	logic                exe_o_dm2rf;
	logic                exe_o_hilowe;
	logic                exe_o_rfwe;
	logic                exe_o_rfwa;
	logic                exe_o_mulres;
	logic                exe_o_alures;
	logic                exe_o_dmdin;
	logic                exe_o_memop;
	logic                mem_i_dm2rf;
	logic                mem_i_hilowe;
	logic                mem_i_rfwe;
	logic                mem_i_rfwa;
	logic                mem_i_mulres;
	logic                mem_i_alures;
	logic                mem_i_dmdin;
	logic                mem_i_memop;

	regs_exemem u_regs_exemem (
		.cpu_clk_50M (cpu_clk_50M  ),
		.cpu_rst_n   (cpu_rst_n    ),
		.exe_o_alures(exe_o_alures ),
		// signal from exe stage
		.exe_o_dm2rf (exe_o_dm2rf  ),
		.exe_o_dmdin (exe_o_dmdin  ),
		.exe_o_hilowe(exe_o_hilowe ),
		.exe_o_mulres(exe_o_mulres ),
		.exe_o_rfwa  (exe_o_rfwa   ),
		.exe_o_rfwe  (exe_o_rfwe   ),
		.mem_i_alures(mem_i_alures ),
		.exe_o_memop (exe_o_memop  ),
		// signal to mem stage
		.mem_i_dm2rf (mem_i_dm2rf  ),
		.mem_i_dmdin (mem_i_dmdin  ),
		.mem_i_hilowe(mem_i_hilowe ),
		.mem_i_mulres(mem_i_mulres ),
		.mem_i_rfwa  (mem_i_rfwa   ),
		.mem_i_rfwe  (mem_i_rfwe   ),
		.mem_i_memop (mem_i_memop  )
	);

	logic                mem_o_dm2rf;
	logic                mem_o_hilowe;
	logic                mem_o_rfwe;
	logic        [3 : 0] mem_o_bytesel;
	logic                mem_o_rfwa;
	logic                mem_o_mulres;
	logic                mem_o_alures;
	logic                mem_o_dmdout;
	logic                wb_i_dm2rf;
	logic                wb_i_hilowe;
	logic                wb_i_rfwe;
	logic        [3 : 0] wb_i_bytesel;
	logic                wb_i_rfwa;
	logic                wb_i_mulres;
	logic                wb_i_alures;
	logic                wb_i_dmdout;

	regs_memwb u_regs_memwb (
		.cpu_clk_50M  (cpu_clk_50M  ),
		.cpu_rst_n    (cpu_rst_n    ),
		.mem_o_alures (mem_o_alures ),
		.mem_o_bytesel(mem_o_bytesel),
		// signal from mem stage
		.mem_o_dm2rf  (mem_o_dm2rf  ),
		.mem_o_dmdout (mem_o_dmdout ),
		.mem_o_hilowe (mem_o_hilowe ),
		.mem_o_mulres (mem_o_mulres ),
		.mem_o_rfwa   (mem_o_rfwa   ),
		.mem_o_rfwe   (mem_o_rfwe   ),
		.wb_i_alures  (wb_i_alures  ),
		.wb_i_bytesel (wb_i_bytesel ),
		// signal to wb stage
		.wb_i_dm2rf   (wb_i_dm2rf   ),
		.wb_i_dmdout  (wb_i_dmdout  ),
		.wb_i_hilowe  (wb_i_hilowe  ),
		.wb_i_mulres  (wb_i_mulres  ),
		.wb_i_rfwa    (wb_i_rfwa    ),
		.wb_i_rfwe    (wb_i_rfwe    )
	);

	// stages
	stage_if u_stage_if (
		.cpu_clk_50M(cpu_clk_50M),
		.cpu_rst_n  (cpu_rst_n  ),
		// interface with im
		.imaddr     (imaddr     ),
		.imce       (imce       )
	);

	stage_id u_stage_id (
		// interface with regs_ifid
		.id_i_inst   (id_i_inst    ),
		.id_o_aluop  (id_o_aluop   ),
		.id_o_alutype(id_o_alutype ),
		// interface with regs_idexe
		.id_o_dm2rf  (id_o_dm2rf   ),
		.id_o_dmdin  (id_o_dmdin   ),
		.id_o_hilowe (id_o_hilowe  ),
		.id_o_rfwa   (id_o_rfwa    ),
		.id_o_rfwe   (id_o_rfwe    ),
		.id_o_src1   (id_o_src1    ),
		.id_o_src2   (id_o_src2    ),
		.rfra1       (rfra1        ),
		.rfra2       (rfra2        ),
		.rfrd1       (rfrd1        ),
		.rfrd2       (rfrd2        ),
		// interface with rf
		.rfre1       (rfre1        ),
		.rfre2       (rfre2        ),
		.id_o_memop  (id_o_memop   )
	);

	stage_exe u_stage_exe (
		.exe_i_aluop  (exe_i_aluop   ),
		.exe_i_alutype(exe_i_alutype ),
		// interface with regs_idexe
		.exe_i_dm2rf  (exe_i_dm2rf   ),
		.exe_i_dmdin  (exe_i_dmdin   ),
		.exe_i_hilowe (exe_i_hilowe  ),
		.exe_i_rfwa   (exe_i_rfwa    ),
		.exe_i_rfwe   (exe_i_rfwe    ),
		.exe_i_src1   (exe_i_src1    ),
		.exe_i_src2   (exe_i_src2    ),
		.exe_i_memop  (exe_i_memop   ),
		// interface with regs_exemem
		.exe_o_dm2rf  (exe_o_dm2rf   ),
		.exe_o_dmdin  (exe_o_dmdin   ),
		.exe_o_hilowe (exe_o_hilowe  ),
		.exe_o_mulres (exe_o_mulres  ),
		.exe_o_alures (exe_o_alures  ),
		.exe_o_rfwa   (exe_o_rfwa    ),
		.exe_o_rfwe   (exe_o_rfwe    ),
		// interface with hilo
		.hi_o         (hi_o          ),
		.lo_o         (lo_o          ),
		.exe_o_memop  (exe_o_memop   )
	);

	stage_mem u_stage_mem (
		  .dmdin        (dmdin         ),
		  .dmaddr       (dmaddr        ),
		  // interface with dm
		  .dmce         (dmce          ),
		  .dmwe         (dmwe          ),
		  .dmdout       (dmdout        ),
		  .mem_i_alures (mem_i_alures  ),
		  // interface with regs_exemem
		  .mem_i_dm2rf  (mem_i_dm2rf   ),
		  .mem_i_dmdin  (mem_i_dmdin   ),
		  .mem_i_hilowe (mem_i_hilowe  ),
		  .mem_i_mulres (mem_i_mulres  ),
		  .mem_i_rfwa   (mem_i_rfwa    ),
		  .mem_i_rfwe   (mem_i_rfwe    ),
		  .mem_o_alures (mem_o_alures  ),
		  .mem_o_bytesel(mem_o_bytesel ),
		  // interface with regs_memwb
		  .mem_o_dm2rf  (mem_o_dm2rf   ),
		  .mem_o_dmdout (mem_o_dmdout  ),
		  .mem_o_hilowe (mem_o_hilowe  ),
		  .mem_o_mulres (mem_o_mulres  ),
		  .mem_o_rfwa   (mem_o_rfwa    ),
		  .mem_o_rfwe   (mem_o_rfwe    )
		, .mem_i_memop  (mem_i_memop   )
	);

	stage_wb u_stage_wb (
		.hi_i        (hi_i        ),
		.hilowe      (hilowe      ),
		.lo_i        (lo_i        ),
		.rfwa        (rfwa        ),
		.rfwd        (rfwd        ),
		// interface with regfile and hilo
		.rfwe        (rfwe        ),
		.wb_i_alures (wb_i_alures ),
		.wb_i_bytesel(wb_i_bytesel),
		// interface with regs_memwb
		.wb_i_dm2rf  (wb_i_dm2rf  ),
		.wb_i_dmdout (wb_i_dmdout ),
		.wb_i_hilowe (wb_i_hilowe ),
		.wb_i_mulres (wb_i_mulres ),
		.wb_i_rfwa   (wb_i_rfwa   ),
		.wb_i_rfwe   (wb_i_rfwe   )
	);

endmodule
