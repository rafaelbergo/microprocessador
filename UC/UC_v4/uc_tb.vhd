library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end;

architecture a_uc_tb of uc_tb is
    component uc is port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(15 downto 0);
        pc_wr_en        : out std_logic;
        rom_rd_en       : out std_logic;
        jump_en         : out std_logic
    );
    end component;

    constant period_time                        : time := 100 ns;
    signal finished                             : std_logic := '0';
    signal clk, rst                             : std_logic;
    signal pc_wr_en, rom_rd_en, jump_en  : std_logic;
    signal instruction                          : unsigned(15 downto 0);

begin

    uut : uc port map(
        clk => clk,
        rst => rst,
        instruction => instruction,
        pc_wr_en => pc_wr_en,
        rom_rd_en => rom_rd_en,
        jump_en => jump_en
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
        instruction <= "0000000000000000";

        wait for 100 ns;
        instruction <= "1111000000000000";

        wait for 300 ns;
        instruction <= "1101000011000000";

        wait;
    end process;
end architecture;