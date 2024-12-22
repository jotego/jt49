#!/bin/bash

iverilog *.v ../../hdl/*.v ../../doc/ay_model.v -o sim && ./sim -lxt
rm -f sim
