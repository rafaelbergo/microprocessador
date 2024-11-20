library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc1 is port (
    clk:        in std_logic;
    rst:        in std_logic;
    wr_en:      in std_logic;
    data:       out unsigned(16 downto 0)
);
end entity;

architecture a_uc1 of uc1 is

    component rom is port (
        clk:        in std_logic;
        address:    in unsigned(6 downto 0);
        data:       out unsigned(16 downto 0)
    );
    end component;

    component pc is port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in unsigned(6 downto 0);
        data_out:   out unsigned(6 downto 0)
    );
    end component;

    signal data_in : unsigned(6 downto 0) := "0000000";
    signal data_out: unsigned(6 downto 0);

begin

    pc_uut : pc port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_out
    );

    rom_uut: rom port map(
        clk => clk,
        address => data_out,
        data => data
    );

    data_in <= data_out + "0000001";

end architecture;