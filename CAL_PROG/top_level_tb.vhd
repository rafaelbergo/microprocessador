library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end;

architecture a_top_level_tb of top_level_tb is
    
    component fetch is port (
        clk                 : in std_logic;
        rst                 : in std_logic;
        rd_rom              : in std_logic;
        wr_pc               : in std_logic;
        jump_en             : in std_logic;
        instruction         : out unsigned(16 downto 0)
    );
    end component;

    component decode is port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(16 downto 0);
        rd_rom          : out std_logic;
        wr_pc           : out std_logic;
        jump_en         : out std_logic;
        operation       : out unsigned(1 downto 0);
        entr1           : out unsigned(15 downto 0);
        entr0           : out unsigned(15 downto 0);
        ula_out         : in unsigned(15 downto 0)
    );
    end component;

    component execute is port (
        clk             : in std_logic;
        rst             : in std_logic;
        entr0           : in unsigned(15 downto 0);
        entr1           : in unsigned(15 downto 0);
        operation       : in unsigned(1 downto 0);
        result          : out unsigned(15 downto 0)
    );
    end component;

    constant period_time            : time := 100 ns;
    signal finished                 : std_logic := '0';
    signal clk, rst                 : std_logic;
    signal wr_pc, rd_rom            : std_logic;
    signal instruction              : unsigned(16 downto 0);
    signal result                   : unsigned(15 downto 0);
    signal operation                : unsigned(1 downto 0);
    signal entr1, entr0             : unsigned(15 downto 0);
    signal jump_en                  : std_logic;

begin

    fetch_uut : fetch port map(
        clk => clk,
        rst => rst,
        rd_rom => rd_rom,
        wr_pc => wr_pc,
        jump_en => jump_en,
        instruction => instruction
    );

    decode_uut : decode port map(
        clk => clk,
        rst => rst,
        rd_rom => rd_rom,
        wr_pc => wr_pc,
        jump_en => jump_en,
        instruction => instruction,
        operation => operation,
        entr1 => entr1,
        entr0 => entr0,
        ula_out => result
    );

    execute_uut : execute port map(
        clk => clk,
        rst => rst,
        entr0 => entr0,
        entr1 => entr1,
        operation => operation,
        result => result
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
        
        wait;
    end process;
end architecture;