library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc2_tb is
end;

architecture a_uc2_tb of uc2_tb is
    component uc2 is port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        toggle:     in std_logic;
        data:       out unsigned(16 downto 0)
    );
    end component;

    constant period_time        : time := 100 ns;
    signal finished             : std_logic := '0';
    signal data                 : unsigned(16 downto 0);
    signal clk, rst, toggle     : std_logic;
    signal wr_en                : std_logic := '1';

begin

    uc_v2_uut : uc2 port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        toggle => toggle,
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
        wait;
    end process;
end architecture;