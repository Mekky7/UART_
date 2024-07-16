vlib work
vlog -f src_files.list
vsim -voptargs="+acc" work.UART_TX_tb 
add wave -position insertpoint sim:/UART_TX_tb/*
run -all



 