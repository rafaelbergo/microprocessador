library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is

end;

architecture a_ula_tb of ula_tb is 
    component ula
        port (
            entr0:              in unsigned(15 downto 0);
            entr1:              in unsigned(15 downto 0);
            operation:          in unsigned(1 downto 0);
            result:             out unsigned(15 downto 0);
            overflow_flag:      out std_logic;
            carry_flag:         out std_logic;
            zero_flag:          out std_logic;
            greater_than_flag:  out std_logic;
            less_than_flag:     out std_logic;
            equal_to_flag:      out std_logic
        );
    end component;

    signal entr0, entr1, result:                                unsigned(15 downto 0);
    signal operation:                                           unsigned(1 downto 0);
    signal overflow_flag, carry_flag, zero_flag:                std_logic;
    signal greater_than_flag, less_than_flag, equal_to_flag:    std_logic;

    begin
        uut: ula port map(
            entr0 => entr0,
            entr1 => entr1,
            operation => operation,
            result => result,
            overflow_flag => overflow_flag,
            carry_flag=> carry_flag,      
            zero_flag=> zero_flag,       
            greater_than_flag=> greater_than_flag,
            less_than_flag => less_than_flag,  
            equal_to_flag => equal_to_flag
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

        operation <= "01";
        entr0 <= "0000000000011000";
        entr1 <= "0000000000011000";
        wait for 50 ns;

        wait;
    end process;
    
end architecture;