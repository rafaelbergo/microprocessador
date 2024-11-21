library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is port(
    clk                 : in std_logic;
    rst                 : in std_logic
);
end entity;

architecture a_top_level of top_level is

    component uc is port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(16 downto 0);
        pc_wr_en        : out std_logic;
        rom_rd_en       : out std_logic;
        jump_en         : out std_logic
    );
    end component;

    component rom is port (
        clk:        in std_logic;
        address:    in unsigned(6 downto 0);
        rd_en:      in std_logic;
        data:       out unsigned(16 downto 0)
    );
    end component;

    component pc is port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in unsigned(6 downto 0);
        data_out:   out unsigned(6 downto 0)
    );
    end component;

    signal instruction                     : unsigned(16 downto 0);
    signal pc_wr_en, rom_rd_en, jump_en    : std_logic;
    signal data_in_pc                      : unsigned(6 downto 0) := "0000000";
    signal data_out_pc, jump_address       : unsigned(6 downto 0);

begin

    rom_uut: rom port map (
        clk => clk,
        address => data_out_pc,
        rd_en => rom_rd_en,
        data => instruction
    );

    uc_uut: uc port map (
        clk => clk,
        rst => rst,
        instruction => instruction,
        pc_wr_en => pc_wr_en,
        rom_rd_en => rom_rd_en,
        jump_en => jump_en
    );

    pc_uut: pc port map (
        clk => clk,
        rst => rst,
        wr_en => pc_wr_en,
        data_in => data_in_pc,
        data_out => data_out_pc
    );

    data_in_pc <= data_out_pc + "0000001";
    jump_address <= instruction(6 downto 0) when jump_en = '1' else "0000000";

end architecture;