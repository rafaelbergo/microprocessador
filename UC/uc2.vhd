library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc2 is
    clk:        in std_logic;
    rst:        in std_logic;
    wr_en:      in std_logic;
    toggle:     in std_logic;
    data:       out unsigned(16 downto 0)
end;

architecture a_uc2 of uc2 is

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

    component state_machine is port (
        clk:        in std_logic;
        rst:        in std_logic;
        toggle:     in std_logic;
        state:      out std_logic
    );
    end component;

    signal data_in : unsigned(6 downto 0) := "0000000";
    signal data_out: unsigned(6 downto 0);
    signal state: std_logic;

begin

    pc_uut : pc port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_out
    );

    -- state fetch(state 0)
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

    -- update PC(state 1)
    process(clk)
    begin
        if rising_edge(clk) and state = '1' then 
            data_in <= data_out + "0000001";
        end if;
    end process;

end architecture;