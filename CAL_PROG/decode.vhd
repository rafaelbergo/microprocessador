library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode is
    port( 
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(15 downto 0);
        rd_rom          : out std_logic;
        operation       : out unsigned(1 downto 0)
    );
end entity;

architecture a_decode of decode is

    component uc is port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(15 downto 0);
        wr_en_regs      : out std_logic;
        rd_rom          : out std_logic;
        rd_banco_regs   : out std_logic;
        load_reg        : out std_logic;
        operation       : out unsigned(1 downto 0)
    );
    end component;

    component banco_regs is port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_wr:        in unsigned(15 downto 0);
        reg_wr:         in unsigned(3 downto 0);
        sel_reg:        in unsigned(3 downto 0);
        data_out:       out unsigned(15 downto 0)
    );
    end component;

    component acumulador is port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_in:        in unsigned(15 downto 0);
        data_out:       out unsigned(15 downto 0)
    );
    end component;

    signal wr_en_regs, rd_banco_regs, load_reg: std_logic;
    signal data_out: unsigned(15 downto 0);
    signal data_in_ula: unsigned(15 downto 0);

begin

    uc_uut : uc port map(
        clk => clk,
        rst => rst,
        instruction => instruction,
        wr_en_regs => wr_en_regs,
        rd_rom => rd_rom,
        rd_banco_regs => rd_banco_regs,
        load_reg => load_reg,
        operation => operation
    );

    banco_uut : banco_regs port map (
        clk => clk,
        rst => rst,
        wr_en => load_reg,
        data_wr => instruction,
        reg_wr => instruction(11 downto 8),
        sel_reg => instruction(11 downto 8),
        data_out => data_out
    );

    --acum_uut : acumulador port map (
    --    clk => clk,
    --    rst => rst,
    --    wr_en => wr_en_acum,
    --    data_in => 
    --    data_out => 
    --);

end architecture;