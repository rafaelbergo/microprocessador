library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is port (
    entr0:      in unsigned(15 downto 0);
    entr1:      in unsigned(15 downto 0);
    operation:  in unsigned(1 downto 0);
    saida:      out unsigned(15 downto 0);
    erro:       out unsigned(0 downto 0)
);
end entity;

architecture a_ula of ula is

signal mult: unsigned(31 downto 0);

begin

    process (entr0, entr1) is 
    begin
        mult <= entr0 * entr1;
    end process;

    process(operation, entr0, entr1, mult) is
    begin 
        erro <= "0";
        case operation is
            when "00" => 
                saida <= entr1 + entr0;
            when "01" =>
                saida <= entr1 - entr0;
            when "10" =>
                saida <= mult(15 downto 0);
            when others =>
                if entr0 = "0000000000000000" then
                    saida <= "0000000000000000";
                    erro <= "1";
                else
                    saida <= entr1 - entr0;
                end if;
        end case;
    end process;
end architecture;