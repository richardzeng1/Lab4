# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns Part3.v

# Load simulation using mux as the top level simulation module.
vsim Part3

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# SW 7 to 0 for loadVal 7 to 0
# SW9 for reset_n
# Key 1 for load n
# key 2 for shift right
# key 3 for asr 
# key 0 for clock 
# Q to LEDR

force {KEY[0]} 0 0, 1 10
force {SW[9]} 1

# load values
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
force {KEY[1]} 0
force {KEY[2]} 1 
force {KEY[3]} 1

# key 1 is flipped
run 20ns 

#1. answer
force {KEY[0]} 0 0, 1 10
force {KEY[1]} 1
force {KEY[2]} 0
run 20ns

#shifting right no ASR
force {KEY[0]} 0 20, 1 40 -r 80
force {KEY[1]} 1
force {KEY[2]} 1 
force {KEY[3]} 0

run 550ns

# load values
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
force {KEY[1]} 0
force {KEY[2]} 1 
force {KEY[3]} 1

run 100ns

#shifting right with ASR
force {KEY[1]} 1
force {KEY[2]} 1 
force {KEY[3]} 1
run 800ns

# load values
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0
force {KEY[1]} 0
force {KEY[2]} 1 
force {KEY[3]} 1

run 100 ns

#shifting right with ASR
force {KEY[1]} 1
force {KEY[2]} 1 
force {KEY[3]} 1
run 800ns




