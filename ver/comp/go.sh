#!/bin/bash

gawk -f parser.awk test_cmd > cmd.hex || exit $?

ncverilog -f gather.f +access+r
