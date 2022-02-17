#compilation
vlog tb.sv
#simulation
vsim tb 
#add wave
add wave -position insertpoint sim:/tb/* 

run -all

