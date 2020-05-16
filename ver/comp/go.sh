#!/bin/bash

gawk -f parser.awk test_cmd > cmd.hex || exit $?

iverilog -f gather.f -s test -o sim && sim -lxt
