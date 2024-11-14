library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ff_t_tb is
end entity;

architecture a_ff_tb of ff_t_tb is
    component ff_t port(
        clk : in std_logic;
        rst : in std_logic;
        t   : in std_logic;
        q   : out std_logic;
        q_not : out std_logic
    );
    end component;

    constant period_time:                   time := 100 ns; 
    signal finished:                        std_logic := '0';

    signal clk, rst, t, q, q_not : std_logic;

begin
    uut: ff_t port map(
        clk => clk,
        rst => rst,
        t   => t,
        q   => q,
        q_not => q_not
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

        t <= '0';

        wait for 100 ns;
        rst <= '1';

        wait for 100 ns;
        t <= '1';

        wait for 100 ns;
        t <= '0';

        wait;
    end process;
end architecture;