#!/bin/bash

ghdl -a *.vhd

ghdl -a uc3_tb.vhd
ghdl -e uc3

ghdl -r uc3_tb --wave=uc3_tb.ghw

gtkwave uc3_tb.ghw

rm -rf work-obj93.cf
rm -rf uc3_tb.ghw