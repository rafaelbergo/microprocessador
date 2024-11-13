library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regs16bits_tb is
end;

architecture a_regs16bits_tb of regs16bits_tb is 
    component regs16bits is port(
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal data_in, data_out  : unsigned(15 downto 0);
    signal clk, rst, wr_en    : std_logic;       

begin
    uut: regs16bits port map(
        data_in => data_in,
        data_out => data_out,
        clk => clk,
        rst => rst,
        wr_en => wr_en
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

   process -- sinais dos casos de teste 
   begin
        wait for 200 ns;
        wr_en <= '0';
        data_in <= "1111111111111111";

        wait for 200 ns;
        data_in <= "1000110111100001";

        wait for 200 ns; 
        wr_en <= '1';
        data_in <= "0100100100011011";

        wait for 200 ns;
        wr_en <= '1';
        data_in <= "1111111111111111";

        wait for 200 ns; -- tenta escrever com wr_en = 0
        wr_en <= '0';
        data_in <= "1111111111111111"; -- esperado: 0000000000000000

        wait for 200 ns; -- tenta escrever com wr_en = 0
        wr_en <= '0';
        data_in <= "1111111111111111"; -- esperado: 0000000000000000

        wait for 200 ns;
        wr_en <= '1';
        data_in <= "1111111111111111";

        wait for 200 ns;
        wr_en <= '0';
        data_in <= "0000111111111111";
        
        wait;
   end process;
end architecture a_regs16bits_tb;