library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc3_tb is
end;

architecture a_uc3_tb of uc3_tb is
    component uc3 is port (
        clk:        in std_logic;
        rst:        in std_logic;
        toggle:     in std_logic;
        wr_en:      in std_logic;
        data:       out unsigned(16 downto 0)
    );
    end component;

    constant period_time        : time := 100 ns;
    signal finished             : std_logic := '0';
    signal data                 : unsigned(16 downto 0);
    signal clk, rst             : std_logic;
    signal wr_en, toggle        : std_logic := '1';

begin

    uut : uc3 port map(
        clk => clk,
        rst => rst,
        toggle => toggle,
        wr_en => wr_en,
        data => data
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
        wait;
    end process;

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
        wait for 200 ns;

        wait;
    end process;
end architecture;