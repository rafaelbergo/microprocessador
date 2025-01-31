library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmpr is
    port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        carry_in:       in std_logic;
        overflow_in:    in std_logic;
        zero_in:        in std_logic;
        carry_out:      out std_logic;
        overflow_out:   out std_logic;
        zero_out:       out std_logic
    );
end entity;

architecture a_cmpr of cmpr is
    signal carry_s, overflow_s, zero_s: std_logic;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            carry_s <= '0';
            overflow_s <= '0';
            zero_s <= '0';
        elsif wr_en = '1' then
            if rising_edge(clk) then
                carry_s <= carry_in;
                overflow_s <= overflow_in;
                zero_s <= zero_in;
            end if;
        end if;
    end process;
    carry_out <= carry_s;
    overflow_out <= overflow_s;
    zero_out <= zero_s;
end architecture;