library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode_tb is
end;

architecture a_decode_tb of decode_tb is
    component decode is port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(15 downto 0)
    );
    end component;

    constant period_time            : time := 100 ns;
    signal finished                 : std_logic := '0';
    signal clk, rst                 : std_logic;
    signal instruction              : unsigned(15 downto 0);

begin

    uut : decode port map(
        clk => clk,
        rst => rst,
        instruction => instruction
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
        instruction <= "0000000000000100";

        wait for 100 ns;
        instruction <= "0001000000010000";

        wait for 100 ns;
        instruction <= "0001000000010011";

        wait for 100 ns;
        instruction <= "0001000100010000";

        wait;
    end process;
end architecture;