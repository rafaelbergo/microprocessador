library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_ula is
    port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_wr:        in unsigned(15 downto 0);
        reg_wr:         in unsigned(3 downto 0);
        sel_reg_r1:     in unsigned(3 downto 0); 
        sel_reg_r2:     in unsigned(3 downto 0); 
        data_out_r1:    out unsigned(15 downto 0);
        data_out_r2:    out unsigned(15 downto 0); 
        ula_operation_sel: in unsigned(3 downto 0);
        
        out_ula:        out unsigned(15 downto 0)

    );
end entity;