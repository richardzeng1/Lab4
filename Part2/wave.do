# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns Part2.v

# Load simulation using mux as the top level simulation module.
vsim Part2

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# SW 7-5 for ALU functions
# SW 9 for reset_n
# Key 0 for clock input
# sw 3-0 for data in

# ALU functions
force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 0

# Data (A)
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1

# Clock and reset
force {KEY[0]} 0 0, 1 10 -r 20
force {SW[9]} 1 0, 0 10 -r 20
run 120ns

# Changing the inputs of data A
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

run 120ns

# Chaning ALU to add a + b
force {SW[7]} 0
force {SW[6]} 0
force {SW[5]} 1

run 120ns
