#!/bin/bash


if which ncverilog; then
    ncverilog test.v ../../hdl/filter/jt49_{dcrm,mave,dly}.v \
        +define+NCVERILOG +access+r +define+SIMULATION
else
    iverilog test.v ../../hdl/filter/jt49_dcrm2.v \
        -DSIMULATION -o sim && sim -lxt
fi