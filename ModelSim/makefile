include design_source.mk

# CSR-SIM Path
CSR_SIM_PATH = $(StateMover_PATH)/CSR_SIM

# Modelsim Flags
VSIM_FLAGS  = -pli $(CSR_SIM_PATH)/csr_sim.sl -t ps -voptargs=+acc +notimingchecks 
VSIM_LFLAGS = -L unisims_ver -L unimacro_ver -L secureip -L xpm

#all: compile_netlist compile_dut compile_tb run_gui 
all: clean compile run_gui

run:
	vsim -do "run -all ;quit -force" -c sys_tb work.glbl $(VSIM_FLAGS) $(VSIM_LFLAGS)

 ## Change the signal below into signal that you want to observe
run_gui:
	vsim -do $(WAVE_FILE) $(TB_MODULE) work.glbl $(VSIM_FLAGS) $(VSIM_LFLAGS)
  
compile: 
	vlib work
	vlog $(VIVADO_PATH)/data/verilog/src/glbl.v
	vlog $(NETLIST_FILE)

	vlog $(IL_FILE_PATH)/$(IL_FILE)
	vlog $(TOP_FILE_PATH)/$(TOP_FILE)

	vlog $(TB_FILE_PATH)/$(TB_FILE)


hardware_create_project: 
	vivado -mode tcl -source vivado_create_project.tcl -nolog -nojournal

hardware_implement: 
	vivado -mode tcl -source vivado_implement.tcl -nolog -nojournal

clean:
	rm -rf work
	rm -f transcript
	rm -f vsim.wlf

