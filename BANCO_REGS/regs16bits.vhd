library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regs16bits is
    port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in unsigned(15 downto 0);
        data_out:   out unsigned(15 downto 0)
    );
end entity;

architecture a_regs16bits of regs16bits is
    signal regs_16: unsigned(15 downto 0) := (others => '0');
begin
    process(clk, rst, wr_en)
    begin
        if rst = '1' then
            regs_16 <= (others => '0');
        elsif wr_en = '1' then
            if rising_edge(clk) then
                regs_16 <= data_in;
            end if;
        end if;
    end process;
    data_out <= regs_16;
end architecture;