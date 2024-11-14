library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_ula_tb is
end;

architecture a_banco_regs_ula_tb of banco_regs_ula_tb is 
    component banco_regs_ula is port(
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_wr:        in unsigned(15 downto 0);
        reg_wr:         in unsigned(3 downto 0);
        sel_reg:     in unsigned(3 downto 0); 
        ula_operation_sel: in unsigned(1 downto 0);
        operando_cte:   in unsigned(15 downto 0);
        operando_selector: in std_logic;
        out_ula:        out unsigned(15 downto 0)
    );
    end component;

    constant period_time:                   time := 100 ns; 
    signal finished:                        std_logic := '0';

    signal clk, rst, wr_en:                 std_logic;
    signal data_wr:                         unsigned(15 downto 0);
    signal reg_wr:                          unsigned(3 downto 0);
    signal sel_reg:                      unsigned(3 downto 0);
    signal ula_operation_sel:               unsigned(1 downto 0);
    signal operando_cte:                    unsigned(15 downto 0);
    signal operando_selector:               std_logic;
    signal out_ula:                         unsigned(15 downto 0);

begin

    uut: banco_regs_ula port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_wr => data_wr,
        reg_wr => reg_wr,
        sel_reg => sel_reg,
        ula_operation_sel => ula_operation_sel,
        operando_cte => operando_cte,
        operando_selector => operando_selector,
        out_ula => out_ula
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
        wait for 200 ns;
        
         -- adiciona o valor 2 no registrador r1
        sel_reg <= "0001";
        operando_selector <= '0'; -- operando = reg
        operando_cte <= "0000000000000011"; -- 3
        ula_operation_sel <= "00"; -- operacao = soma

        wr_en <= '1';
        reg_wr <= "0001"; -- escreve no r1
        data_wr <= "0000000000000111"; -- 2

        wait for 100 ns;

        sel_reg <= "0001";
        operando_selector <= '1';
        wr_en <= '0';
        
        wait for 100 ns;

        wr_en <= '1';
        data_wr <= "0000000000001000";
        reg_wr <= "0101";
        
        wait for 100 ns;
        wr_en <= '0';
        sel_reg <= "0101";

        wait;
    end process;
    
end architecture;