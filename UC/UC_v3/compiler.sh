#!/bin/bash

ghdl -a *.vhd

ghdl -a uc2_tb.vhd
ghdl -e uc2

ghdl -r uc2_tb --wave=uc2_tb.ghw

gtkwave uc2_tb.ghw

rm -rf work-obj93.cf
rm -rf uc2_tb.ghw