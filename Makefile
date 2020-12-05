VCS = vcs -sverilog -timescale=1ns/1ns +vpi -l build.log -f file.f -debug_all
SIMV = ./simv -l simv.log

ifndef TB_SEED
	TB_SEED = 1024
endif

all: comp run
comp:
	$(VCS) +define+TB_SEED=$(TB_SEED) 
run:
	$(SIMV) -gui &
dbg:
	verdi -f file.f -ssf top.fsdb &
clean:
	rm -rf core csrc simv* vc_hdrs.h ucli.key urg* *.log *.fsdb novas.* verdiLog