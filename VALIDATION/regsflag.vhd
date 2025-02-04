library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regsflag is
    port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in std_logic;
        data_out:   out std_logic
    );
end entity;

architecture a_regsflag of regsflag is
    signal flag: std_logic;
begin
    process(clk, rst, wr_en)
    begin
        if rst = '1' then
            flag <= '0';
        elsif wr_en = '1' then
            if rising_edge(clk) then
                flag <= data_in;
            end if;
        end if;
    end process;
    data_out <= flag;
end architecture;