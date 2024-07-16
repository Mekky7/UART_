vlib work
vlog -f src_files.list
vsim -voptargs="+acc" work.uart_rx_tb 
add wave -position insertpoint sim:/uart_rx_tb/*
add wave -position insertpoint sim:/uart_rx_tb/DUT/block_3/*
run -all



 