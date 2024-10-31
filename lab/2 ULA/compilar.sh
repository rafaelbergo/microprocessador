ghdl -a mux8x1.vhd
ghdl -e mux8x1

ghdl -a mux8x1_tb.vhd
ghdl -e mux8x1_tb

ghdl -a soma_e_subtrai.vhd
ghdl -e soma_e_subtrai

ghdl -a soma_e_subtrai_tb.vhd
ghdl -e soma_e_subtrai_tb


ghdl -r soma_e_subtrai_tb --wave=soma_e_subtrai_tb.ghw

gtkwave soma_e_subtrai_tb.ghw