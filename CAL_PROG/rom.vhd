library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk:        in std_logic;
        address:    in unsigned(6 downto 0);
        data:       out unsigned(16 downto 0);
        rd_rom:     in std_logic
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant content_rom: mem := (
        0  => B"0010_0_0011_00000101", --LD R3, 5
        1  => B"0010_0_0100_00001000", --LD R4, 8
        2  => B"0011_1_0011_00000000", --MOV A, R3
        3  => B"0100_1_0100_00000000", --ADD A, R4
        4  => B"0011_0_0101_00000000", --MOV R5, A
        5  => B"0010_0_0111_00000001", --LD R7, 1
        6  => B"0110_1_0111_00000000", --SUB A, R7
        7  => B"0011_0_0101_00000000", --MOV R5, A
        8  => B"1010_0_00000_0010100", --JUMP 20
        9  => B"0010_0_0101_00000000", --LD R5, 0
        20 => B"0011_1_0101_00000000", --MOV A, R5
        21 => B"0011_0_0011_00000000", --MOV R3, A
        22 => B"1010_0_00000_0000010", --JUMP 2
        23 => B"0010_0_0011_00000000", --LD R3, 0
        others => (others => '0')
    );

begin
    process(clk)
    begin
        if rising_edge(clk) and rd_rom = '1' then 
            data <= content_rom(to_integer(address));
        end if;
    end process;
end architecture;