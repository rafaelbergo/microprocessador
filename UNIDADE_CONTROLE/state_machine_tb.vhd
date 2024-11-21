-- VHDL #4 - UNIDADE DE CONTROLE(prazo: 20/11/2024)

-- Alunos:

-- Giovane Limas Salvi - 2355841 - s71
-- Rafael Carvalho Bergo - 2387190 - s71

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine_tb is
end;

architecture a_state_machine_tb of state_machine_tb is
    component state_machine is port (
        clk:        in std_logic;
        rst:        in std_logic;
        toggle:     in std_logic;
        state:      out std_logic
    );
    end component;

    constant period_time            : time := 100 ns;
    signal finished                 : std_logic := '0';
    signal clk, rst, toggle, state  : std_logic;

begin

    uut : state_machine port map(
        clk => clk,
        rst => rst,
        toggle => toggle,
        state => state
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
        toggle <= '1';

        wait for 600 ns;
        toggle <= '0';

        wait for 150 ns;
        toggle <= '1';

        wait;
    end process;
end architecture;