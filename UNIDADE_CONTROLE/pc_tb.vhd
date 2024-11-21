-- VHDL #4 - UNIDADE DE CONTROLE(prazo: 20/11/2024)

-- Alunos:

-- Giovane Limas Salvi - 2355841 - s71
-- Rafael Carvalho Bergo - 2387190 - s71

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end;

architecture a_pc_tb of pc_tb is
    component pc is port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in unsigned(6 downto 0);
        data_out:   out unsigned(6 downto 0)
    );
    end component;

    constant period_time                        : time := 100 ns;
    signal finished                             : std_logic := '0';
    signal clk, rst, wr_en                      : std_logic;
    signal data_in, data_out                    : unsigned(6 downto 0);

begin

    uut : pc port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_out
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
        wr_en <= '1';
        data_in <= "0000000";

        wait for 100 ns;
        data_in <= "0000010";

        wait for 100 ns;
        data_in <= "0001010";

        wait for 100 ns;
        wr_en <= '0';
        data_in <= "1100010";

        wait for 100 ns;
        data_in <= "1101010";

        wait for 100 ns;
        data_in <= "1100110";

        wait for 100 ns;
        wr_en <= '1';
        data_in <= "0100010";

        wait;
    end process;
end architecture;