onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_testbench/dut/clk
add wave -noupdate -radix decimal /cpu_testbench/dut/pcVal
add wave -noupdate -radix unsigned /cpu_testbench/dut/data/registers/WriteRegister
add wave -noupdate -radix unsigned /cpu_testbench/dut/data/registers/WriteData
add wave -noupdate -radix binary /cpu_testbench/dut/data/registers/RegWrite
add wave -noupdate -radix unsigned /cpu_testbench/dut/data/registers/ReadData1
add wave -noupdate -radix unsigned /cpu_testbench/dut/data/registers/ReadData2
add wave -noupdate -radix unsigned /cpu_testbench/dut/data/registers/ReadRegister1
add wave -noupdate -radix unsigned /cpu_testbench/dut/data/registers/ReadRegister2
add wave -noupdate -radix unsigned /cpu_testbench/dut/data/Rn
add wave -noupdate /cpu_testbench/dut/getInstr/instruction
add wave -noupdate /cpu_testbench/dut/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39100949 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 126
configure wave -valuecolwidth 281
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {183661670 ps}
