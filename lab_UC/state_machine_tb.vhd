library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine_tb is
end entity;

architecture a_state_machine_tb of state_machine_tb is

    constant period_time:       time := 100 ns; 
    signal finished, toggle:    std_logic := '0';
    signal clk, rst, state:      std_logic;

    component state_machine 
        port(
            clk:    in std_logic;
            toggle: in std_logic;
            rst:    in std_logic;
            state:  out std_logic
        );
    end component;

begin
    uut: state_machine port map(
        clk => clk,
        toggle => toggle,
        rst => rst,
        state => state
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process;

    -- gerador de clock
    clk_proc: process
    begin
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
        toggle <= '1';

        wait for 200 ns;
        toggle <= '0';

        wait for 100 ns;
        toggle <= '1';

        wait;
    end process;
end architecture;