library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is
end;

architecture a_main_tb of main_tb is
    component rom is port (
        clk:        in std_logic;
        address:    in unsigned(6 downto 0);
        data:       out unsigned(16 downto 0)
    );
    end component;

    constant period_time    : time := 100 ns;
    signal finished         : std_logic := '0';
    signal data             : unsigned(16 downto 0);
    signal clk              : std_logic;
    signal address          : unsigned(6 downto 0);

begin

    rom_uut: rom port map(
        clk => clk,
        address => address,
        data => data
    );

    sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULACAO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin
        wait for 100 ns;
        address <= "0000000";

        wait for 100 ns;
        address <= "0000010";

        wait for 100 ns;
        address <= "0000011";
        wait;
    end process;
end architecture;