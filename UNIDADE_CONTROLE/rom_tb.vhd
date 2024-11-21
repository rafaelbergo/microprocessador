-- VHDL #4 - UNIDADE DE CONTROLE(prazo: 20/11/2024)

-- Alunos:

-- Giovane Limas Salvi - 2355841 - s71
-- Rafael Carvalho Bergo - 2387190 - s71

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end;

architecture a_rom_tb of rom_tb is
    component rom is port (
        clk:        in std_logic;
        address:    in unsigned(6 downto 0);
        rd_en:      in std_logic;
        data:       out unsigned(16 downto 0)
    );
    end component;

    constant period_time            : time := 100 ns;
    signal finished                 : std_logic := '0';
    signal clk, rd_en               : std_logic;
    signal data                     : unsigned(16 downto 0);
    signal address                  : unsigned(6 downto 0);

begin

    uut : rom port map(
        clk => clk,
        address => address,
        rd_en => rd_en,
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
        wait for 200 ns;
        rd_en <= '1';
        address <= "0000000";

        wait for 100 ns;
        address <= "0000010";

        wait for 100 ns;
        address <= "0001010";

        wait for 100 ns;
        rd_en <= '0';
        address <= "1100010";

        wait for 100 ns;
        rd_en <= '1';
        address <= "0001011";

        wait for 100 ns;
        address <= "1100111";

        wait for 100 ns;
        address <= "0000001";

        wait;
    end process;
end architecture;