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
        jump_abs         : out std_logic;
        operation       : out unsigned(1 downto 0);
        entr1           : out unsigned(15 downto 0);
        entr0           : out unsigned(15 downto 0);
        ula_out         : in unsigned(15 downto 0);
        wr_ram          : out std_logic;
        data_out_ram    : in unsigned(15 downto 0);
        carry_flag      : in std_logic;
        zero_flag       : in std_logic;
        jump_re         : out std_logic;
        wr_flag         : out std_logic
    );
end entity;

architecture a_decode of decode is

    component uc is port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(16 downto 0);
        acum            : in unsigned(15 downto 0);
        rd_rom          : out std_logic;
        wr_banco        : out std_logic;
        wr_pc           : out std_logic;
        mov_reg         : out std_logic_vector(2 downto 0);
        op_const        : out std_logic;
        jump_abs         : out std_logic;
        operation       : out unsigned(1 downto 0);
        is_nop          : out std_logic;
        wr_ram          : out std_logic;
        wr_acum         : out std_logic;
        mov_a_ram       : out std_logic;
        carry_flag      : in std_logic;
        zero_flag       : in std_logic;
        jump_re         : out std_logic;
        wr_flag         : out std_logic
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

    signal mov_reg: std_logic_vector(2 downto 0);
    signal banco_out: unsigned(15 downto 0);
    signal value_wr_banco: unsigned(15 downto 0);
    signal wr_acum, op_const : std_logic;
    signal wr_banco : std_logic;
    signal acum_in, acum_out: unsigned(15 downto 0);
    signal is_nop, mov_a_ram: std_logic;
    signal reg_wr: unsigned(3 downto 0);
    signal msb_entr1 : unsigned(8 downto 0);

begin

    uc_uut : uc port map(
        clk => clk,
        rst => rst,
        instruction => instruction,
        acum => acum_out,
        rd_rom => rd_rom,
        wr_banco => wr_banco,
        wr_pc => wr_pc,
        mov_reg => mov_reg,
        op_const => op_const,
        jump_abs => jump_abs,
        operation => operation,
        is_nop => is_nop,
        wr_ram => wr_ram,
        wr_acum => wr_acum,
        mov_a_ram => mov_a_ram,
        carry_flag => carry_flag,
        zero_flag => zero_flag,
        jump_re => jump_re,
        wr_flag => wr_flag
    );

    value_wr_banco <=   acum_out when mov_reg(1) = '1' else 
                        banco_out when mov_reg(0) = '1' else
                        "000000000" & instruction(6 downto 0) when instruction(7)='0' else
                        "111111111" & instruction(6 downto 0);

    reg_wr <= instruction(11 downto 8) when mov_reg(0) = '0' else instruction(7 downto 4);

    banco_uut : banco_regs port map (
        clk => clk,
        rst => rst,
        wr_en => wr_banco,
        data_wr => value_wr_banco,
        reg_wr => reg_wr,
        sel_reg => instruction(11 downto 8),
        data_out => banco_out
    );

    acum_in <=  banco_out when mov_reg(2) = '1' else 
                data_out_ram when mov_a_ram = '1' else 
                ula_out;

    acum_uut : acumulador port map (
        clk => clk,
        rst => rst,
        wr_en => wr_acum,
        data_in => acum_in,
        data_out => acum_out
    );

    msb_entr1 <= "000000000" when (op_const='1' and instruction(7)='0') else "111111111";

    entr0 <= acum_out;
    entr1 <= msb_entr1 & instruction(6 downto 0) when op_const = '1' else banco_out;

end architecture;