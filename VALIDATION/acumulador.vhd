library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumulador is
    port(
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_in:        in unsigned(15 downto 0);
        data_out:       out unsigned(15 downto 0)
    );
end entity;

architecture a_acumulador of acumulador is 

    component regs16bits port(
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in unsigned(15 downto 0);
        data_out:   out unsigned(15 downto 0)
    );
    end component;

begin

    reg: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_out
    );

end architecture;