library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc3 is port (
    clk:        in std_logic;
    rst:        in std_logic;
    toggle:     in std_logic;
    wr_en:      in std_logic;
    data:       out unsigned(16 downto 0)
);
end entity;

architecture a_uc3 of uc3 is

    component state_machine is port (
        clk:        in std_logic;
        rst:        in std_logic;
        toggle:     in std_logic;
        state:      out std_logic
    );
    end component;

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
    signal state : std_logic;
    signal wr_en_pc : std_logic;

begin

    pc_uut : pc port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_pc,
        data_in => data_in,
        data_out => data_out
    );

    rom_uut: rom port map(
        clk => clk,
        address => data_out,
        data => data
    );

    state_machine_uut: state_machine port map(
        clk => clk,
        rst => rst,
        toggle => toggle,
        state => state
    );

    data_in <= data_out when rising_edge(clk) and state = '1' else data_out + "0000001";
    wr_en_pc <= wr_en when state = '1' else '0';

end architecture;