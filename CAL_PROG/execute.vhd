library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
    port( 
        clk             : in std_logic;
        rst             : in std_logic;
        entr0           : in unsigned(15 downto 0);
        entr1           : in unsigned(15 downto 0);
        operation       : in unsigned(1 downto 0);
        result          : out unsigned(15 downto 0)
    );
end entity;

architecture a_execute of execute is
    
    signal overflow_flag, carry_flag, zero_flag: std_logic;

    component ula is port (
        entr0:              in unsigned(15 downto 0);
        entr1:              in unsigned(15 downto 0);
        operation:          in unsigned(1 downto 0);
        result:             out unsigned(15 downto 0);
        overflow_flag:      out std_logic;
        carry_flag:         out std_logic;
        zero_flag:          out std_logic
    );
    end component;

begin

    ula_uut: ula port map (
        entr0 => entr0,
        entr1 => entr1,
        operation => operation,
        result => result,
        overflow_flag => overflow_flag,
        carry_flag => carry_flag,
        zero_flag => zero_flag
    );

end architecture;