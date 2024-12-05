library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    -- Constantes
    constant period_time : time := 100 ns;

    -- Sinais principais
    signal clk           : std_logic := '0';
    signal rst           : std_logic := '1';
    signal finished      : std_logic := '0';

    -- Declaração do componente
    component processador is
        port (
            clk : in std_logic;
            rst : in std_logic
        );
    end component;

begin
    -- Instância do processador
    uut: processador
        port map(
            clk => clk,
            rst => rst
        );

    -- Reset global
    reset_global: process
    begin
        rst <= '1';                          -- Ativa o reset
        wait for period_time * 2;            -- Aguarda 2 ciclos de clock
        rst <= '0';                          -- Desativa o reset
        wait;
    end process;

    -- Tempo total de simulação
    sim_time_proc: process
    begin
        wait for 10 us;                      -- Define o tempo total de simulação
        finished <= '1';                     -- Marca o término da simulação
        wait;
    end process;

    -- Geração do clock
    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;        -- Meio período do clock
            clk <= '1';
            wait for period_time / 2;        -- Meio período do clock
        end loop;
        wait;
    end process clk_proc;

end architecture;
