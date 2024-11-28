library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode is
    port( 
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
end entity;

architecture a_decode of decode is

    component uc is port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(16 downto 0);
        rd_rom          : out std_logic;
        wr_banco        : out std_logic;
        wr_pc           : out std_logic;
        mov_a_reg       : out std_logic;
        mov_reg_a       : out std_logic;
        op_ula          : out std_logic;
        jump_en         : out std_logic;
        operation       : out unsigned(1 downto 0);
        is_nop          : out std_logic
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

    signal mov_a_reg, mov_reg_a: std_logic;
    signal banco_out: unsigned(15 downto 0);
    signal data_in_ula: unsigned(15 downto 0);
    signal value_wr_banco: unsigned(15 downto 0);
    signal op_ula : std_logic;
    signal wr_acum, wr_banco : std_logic;
    signal acum_in, acum_out: unsigned(15 downto 0);
    signal is_nop: std_logic;

begin

    uc_uut : uc port map(
        clk => clk,
        rst => rst,
        instruction => instruction,
        rd_rom => rd_rom,
        wr_banco => wr_banco,
        wr_pc => wr_pc,
        mov_a_reg => mov_a_reg,
        mov_reg_a => mov_reg_a,
        op_ula => op_ula,
        jump_en => jump_en,
        operation => operation,
        is_nop => is_nop
    );

    value_wr_banco <= acum_out when mov_reg_a = '1' else "000000000" & instruction(6 downto 0);

    banco_uut : banco_regs port map (
        clk => clk,
        rst => rst,
        wr_en => wr_banco,
        data_wr => value_wr_banco,
        reg_wr => instruction(11 downto 8),
        sel_reg => instruction(11 downto 8),
        data_out => banco_out
    );

    acum_in <= banco_out when mov_a_reg = '1' else ula_out;
    wr_acum <= '1' when ((mov_a_reg = '1' or op_ula = '1') and is_nop = '0') else '0';

    acum_uut : acumulador port map (
        clk => clk,
        rst => rst,
        wr_en => wr_acum,
        data_in => acum_in,
        data_out => acum_out
    );

    entr0 <= banco_out when op_ula = '1' else "0000000000000000";
    entr1 <= acum_out when op_ula = '1' else "0000000000000000";

end architecture;