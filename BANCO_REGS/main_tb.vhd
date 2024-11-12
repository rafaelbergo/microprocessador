-- VHDL #2 - ULA(prazo: 06/11/2024)

-- Alunos:

-- Giovane Limas Salvi - 2355841 - s71
-- Rafael Carvalho Bergo - 2387190 - s71

------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is

end;

architecture a_main_tb of main_tb is 

    component ula is port(
        entr0:              in unsigned(15 downto 0);
        entr1:              in unsigned(15 downto 0);
        operation:          in unsigned(1 downto 0);
        result:             out unsigned(15 downto 0);
        overflow_flag:      out std_logic;
        carry_flag:         out std_logic;
        zero_flag:          out std_logic;
        greater_than_flag:  out std_logic;
        less_than_flag :    out std_logic;
        equal_to_flag :     out std_logic
    );
    end component;

    component banco_regs is port(
            clk:            in std_logic;
            rst:            in std_logic;
            wr_en:          in std_logic;
            data_wr:        in unsigned(15 downto 0);
            reg_wr:         in unsigned(1 downto 0);
            reg_r1:         in unsigned(1 downto 0);
            data_out:        out unsigned(15 downto 0)
        );
    end component;

    component acumulador is port(
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_in:        in unsigned(15 downto 0);
        data_out:       out unsigned(15 downto 0)
    );
    end component;

    signal clk, rst, wr_en:                 std_logic;
    signal data_wr:                         unsigned(15 downto 0);
    signal reg_wr, reg_r1:                  unsigned(1 downto 0);
    constant period_time:                   time := 100 ns;
    signal finished:                        std_logic := '0';
    signal banco_out, acumulador_out:       unsigned(15 downto 0);
    signal ula_out:                         unsigned(15 downto 0) := (others => '0');

    signal operation:                                           unsigned(1 downto 0);
    signal overflow_flag, carry_flag, zero_flag:                std_logic;
    signal greater_than_flag, less_than_flag, equal_to_flag:    std_logic;

begin

    uut: ula port map(
        entr0 => acumulador_out,
        entr1 => banco_out,
        operation => operation,
        result => ula_out,
        overflow_flag => overflow_flag,
        carry_flag=> carry_flag,      
        zero_flag=> zero_flag,       
        greater_than_flag=> greater_than_flag,
        less_than_flag => less_than_flag,  
        equal_to_flag => equal_to_flag
    );

    banco: banco_regs port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_wr => data_wr,
        reg_wr => reg_wr,
        reg_r1 => reg_r1,
        data_out => banco_out
    );

    acum: acumulador port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => ula_out,
        data_out => acumulador_out
    );

    -- garantir que o regs espere 2 clocks
    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
        wait;
    end process;
    
    -- tempo total da simulação
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
        operation <= "00";
        wait for 200 ns;
        reg_r1 <= "00";
        wr_en <= '1';
        wait for 50 ns;
        data_wr <= "0000000000000001";
        reg_wr <= "00";
        wait for 50 ns;
        wait;
    end process;
    

end architecture;