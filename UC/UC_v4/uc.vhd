library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is 
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(16 downto 0);
        pc_wr_en        : out std_logic;
        rom_rd_en       : out std_logic;
        jump_en         : out std_logic
    );
end entity;

architecture a_uc of uc is

    component state_machine is port (
        clk:        in std_logic;
        rst:        in std_logic;
        toggle:     in std_logic;
        state:      out std_logic
    );
    end component;

    signal state : std_logic;
    signal toggle : std_logic := '1';
    signal opcode: unsigned(3 downto 0);

begin

    state_machine_uut: state_machine port map(
        clk => clk,
        rst => rst,
        toggle => toggle,
        state => state
    );

    pc_wr_en <= state;
    rom_rd_en <= not state;
    opcode <= instruction(16 downto 13);
    jump_en <= '1' when opcode = "1111" else '0';

end architecture;