#!/bin/bash

ncverilog test.v ../../hdl/filter/jt49_{dcrm,mave,dly}.v \
    +define+NCVERILOG +access+r +define+SIMULATION