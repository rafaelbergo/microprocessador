library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is

end;

architecture a_ula_tb of ula_tb is 
    component ula
        port (
            entr0:      in unsigned(15 downto 0);
            entr1:      in unsigned(15 downto 0);
            operation:  in unsigned(1 downto 0);
            saida:      out unsigned(15 downto 0);
            erro:       out unsigned(0 downto 0)
        );
    end component;

    signal entr0, entr1, saida:     unsigned(15 downto 0);
    signal operation:               unsigned(1 downto 0);
    signal erro:                    unsigned(0 downto 0);


    begin
        uut: ula port map(
            entr0 => entr0,
            entr1 => entr1,
            operation => operation,
            saida => saida,
            erro => erro
        );

    process
    begin 
        operation <= "00";
        entr0 <= "0000000000000011";
        entr1 <= "0000000000000001";
        wait for 50 ns;

        operation <= "01";
        entr0 <= "0000000000000011";
        entr1 <= "0000000000000001";
        wait for 50 ns;

        operation <= "10";
        entr0 <= "0000000000000011";
        entr1 <= "0000000000000011";
        wait for 50 ns;

        operation <= "11";
        entr0 <= "0000000000000000";
        entr1 <= "0000000000000001";
        wait for 50 ns;

        wait;
    end process;
    
end architecture;