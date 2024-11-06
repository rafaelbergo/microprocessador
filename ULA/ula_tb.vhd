library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is

end;

architecture a_ula_tb of ula_tb is 
    component ula is port(
        entr0:              in unsigned(15 downto 0);
        entr1:              in unsigned(15 downto 0);
        operation:          in unsigned(1 downto 0);
        result:             out unsigned(15 downto 0);

        overflow_flag:      out std_logic;
        carry_flag:         out std_logic;
        zero_flag:          out std_logic;

        greater_than_flag:  out std_logic;
        less_than_flag :    out std_logic;
        equal_to_flag :     out std_logic
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
        operation <= "00"; -- soma
        entr0 <= "0000000000110010"; -- 50
        entr1 <= "0000000000011001"; -- 25
        wait for 50 ns; -- esperado 75

        operation <= "01"; -- subtração
        entr0 <= "0000000011001000"; -- 200
        entr1 <= "0000000001001110"; -- 78
        wait for 50 ns; -- esperado 122

        operation <= "10"; -- and
        entr0 <= "0010011000110101"; -- 9781
        entr1 <= "0000010011011000"; -- 1240
        wait for 50 ns; -- esperado 0000010000010000 (1040)

        operation <= "11"; -- or
        entr0 <= "1000100111000010"; -- 35266
        entr1 <= "0100110000110011"; -- 19507
        wait for 50 ns; -- esperado 1100110111110011 (52723)

        operation <= "00"; -- soma com overflow
        entr0 <= "0111111111111111";
        entr1 <= "0000000000000001";
        wait for 50 ns; -- esperado overflow_flag = 1

        operation <= "00"; -- soma com carry
        entr0 <= "1111111111111111";
        entr1 <= "0000000000000001";
        wait for 50 ns; -- esperado carry_flag = 1

        operation <= "01"; -- subtração com carry
        entr0 <= "0000000000000001";
        entr1 <= "0000000000000101";
        wait for 50 ns; -- esperado carry_flag = 1

        operation <= "01"; -- subtração com overflow
        entr0 <= "1000000000000000"; 
        entr1 <= "0000000000000001";
        wait for 50 ns; -- esperado overflow_flag = 1

        operation <= "00"; -- soma com carry e overflow
        entr0 <= "1000000000000000";
        entr1 <= "1000000000000000";
        wait for 50 ns; -- esperado carry_flag = 1 e overflow_flag = 1

        -- Teste flag zero
        operation <= "01"; -- subtração
        entr0 <= "0000000000000001";
        entr1 <= "0000000000000001";
        wait for 50 ns; -- esperado zero_flag = 1

        operation <= "01"; -- subtração
        entr0 <= "0000000000000000";
        entr1 <= "0000000000000000";
        wait for 50 ns; -- esperado zero_flag = 1
        -- Teste comparacoes
        operation <= "00"; -- soma
        entr0 <= "0000000000000001";
        entr1 <= "0000000000000001";
        wait for 50 ns; -- esperado equal_to_flag = 1

        operation <= "00"; -- soma
        entr0 <= "0000000000001001";
        entr1 <= "0000000000000001";
        wait for 50 ns; -- esperado greater_than_flag = 1

        operation <= "00"; -- soma
        entr0 <= "0000000000000001";
        entr1 <= "0000000000001001";
        wait for 50 ns; -- esperado less_than_flag = 1
        
        wait;
    end process;
    
end architecture;