#!/bin/bash

ghdl -a *.vhd

ghdl -a main_tb.vhd
ghdl -e main_tb

ghdl -r main_tb --wave=main_tb.ghw

gtkwave main_tb.ghw

rm -rf work-obj93.cf
rm -rf main_tb.ghw