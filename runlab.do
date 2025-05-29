
vlib work

vlog "./bitwiseXor.sv"
vlog "./mux4_1.sv"
vlog "./checkforZero.sv"
vlog "./mux2_1.sv"
vlog "./alu.sv"
vlog "./checkforZero.sv"
vlog "./register.sv"
vlog "./regfile.sv"
vlog "./mux32_1.sv"
vlog "./demux3_8.sv"
vlog "./demux2_4.sv"
vlog "./decoder.sv"
vlog "./D_FF.sv"
vlog "./datamem.sv"
vlog "./instructmem.sv"
vlog "./math.sv"
vlog "./control.sv"
vlog "./cpu.sv"
vlog "./bitwiseAnd.sv"
vlog "./datapathPC.sv"
vlog "./datapath.sv"
vlog "./OneBitAdder.sv"
vlog "./bitwiseOr.sv"
vlog "./cpu_testbench.sv"


vsim -voptargs="+acc" -t 1ps -lib work cpu_testbench 

do cpu_testbench_wave.do

view wave
view structure
view signals


run -all


