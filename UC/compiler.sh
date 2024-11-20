#!/bin/bash

ghdl -a *.vhd

ghdl -a uc1_tb.vhd
ghdl -e uc1

ghdl -r uc1_tb --wave=uc1_tb.ghw

gtkwave uc1_tb.ghw

rm -rf work-obj93.cf
rm -rf uc1_tb.ghw