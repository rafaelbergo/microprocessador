library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
    port( 
        clk             : in std_logic;
        rst             : in std_logic;
        entr0           : in unsigned(15 downto 0);
        entr1           : in unsigned(15 downto 0);
        operation       : in unsigned(1 downto 0);
        result          : out unsigned(15 downto 0);
        wr_ram          : in std_logic;
        data_out_ram    : out unsigned(15 downto 0);
        endereco_ram    : in unsigned(6 downto 0);
        carry_flag      : out std_logic;
        zero_flag       : out std_logic;
        wr_flag         : in std_logic
    );
end entity;

architecture a_execute of execute is
    
    signal overflow_flag_s, carry_flag_s, zero_flag_s: std_logic;
    signal overflow_flag: std_logic;

    component ula is port (
        entr0:              in unsigned(15 downto 0);
        entr1:              in unsigned(15 downto 0);
        operation:          in unsigned(1 downto 0);
        result:             out unsigned(15 downto 0);
        overflow_flag:      out std_logic;
        carry_flag:         out std_logic;
        zero_flag:          out std_logic
    );
    end component;

    component ram is port (
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        wr_en    : in std_logic;
        dado_in  : in unsigned(15 downto 0);
        dado_out : out unsigned(15 downto 0) 
    );
    end component;

    component regsflag is port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in std_logic;
        data_out:   out std_logic
    );
    end component;

begin

    ula_uut: ula port map (
        entr0 => entr0,
        entr1 => entr1,
        operation => operation,
        result => result,
        overflow_flag => overflow_flag_s,
        carry_flag => carry_flag_s,
        zero_flag => zero_flag_s
    );

    ram_uut: ram port map (
        clk         => clk,
        endereco    => endereco_ram,
        wr_en       => wr_ram,
        dado_in     => entr0,
        dado_out    => data_out_ram
    );

    regs_carry_flag: regsflag port map(
        clk         => clk,
        rst         => rst,
        wr_en       => wr_flag,
        data_in     => carry_flag_s,
        data_out    => carry_flag
    );

    regs_overflow_flag: regsflag port map(
        clk         => clk,
        rst         => rst,
        wr_en       => wr_flag,
        data_in     => overflow_flag_s,
        data_out    => overflow_flag
    );

    regs_zero_flag: regsflag port map(
        clk         => clk,
        rst         => rst,
        wr_en       => wr_flag,
        data_in     => zero_flag_s,
        data_out    => zero_flag
    );

end architecture;