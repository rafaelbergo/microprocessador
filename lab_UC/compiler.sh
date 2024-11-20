#!/bin/bash

ghdl -a *.vhd

ghdl -a state_machine_tb.vhd
ghdl -e state_machine_tb

ghdl -r state_machine_tb --wave=state_machine_tb.ghw

gtkwave state_machine_tb.ghw

rm -rf work-obj93.cf
rm -rf state_machine_tb.ghw