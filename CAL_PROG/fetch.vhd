library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
    port( 
        clk                 : in std_logic;
        rst                 : in std_logic;
        pc_wr_en            : in std_logic
    );
end entity;

architecture a_fetch of fetch is

    signal instruction                     : unsigned(15 downto 0);
    signal data_in_pc                      : unsigned(6 downto 0) := "0000000";
    signal data_out_pc                     : unsigned(6 downto 0);

    component rom is port (
        clk:        in std_logic;
        address:    in unsigned(6 downto 0);
        data:       out unsigned(15 downto 0)
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

begin

    rom_uut: rom port map (
        clk => clk,
        address => data_out_pc,
        data => instruction
    );

    pc_uut: pc port map (
        clk => clk,
        rst => rst,
        wr_en => pc_wr_en,
        data_in => data_in_pc,
        data_out => data_out_pc
    );

    data_in_pc <= data_out_pc + "0000001";
end architecture;