library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_instrucao is
    port (
        clk:            in std_logic;
        wr_en:          in std_logic;
        instr_in:        in unsigned(16 downto 0);
        instr_out:       out unsigned(16 downto 0)
    );
end entity;

architecture a_registrador_instrucao of registrador_instrucao is 
begin
    process(clk, wr_en)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                instr_out <= instr_in;
            end if;
        end if;
    end process;
end architecture;