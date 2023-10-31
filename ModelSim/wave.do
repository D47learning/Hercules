add wave -divider "TB Signals"
add wave -noupdate {sys_tb/i_clk}

add wave -divider "IL Signals"
add wave -noupdate {sys_tb/top_main/interruption_logic_v1reg/*}




