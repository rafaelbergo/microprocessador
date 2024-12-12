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

-- OPCODES:

-- 0000 NOP
-- 0001 
-- 0010 LD
-- 0011 MOV (A,R) or (R,A)
-- 0100 ADD
-- 0101 SUBI
-- 0110 SUB
-- 0111
-- 1000 MOV (R,R)
-- 1001
-- 1010 JUMP
-- 1011 BLO
-- 1100
-- 1101
-- 1110
-- 1111

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant content_rom: mem := (
        0   =>  B"0010_0_0011_00000000", -- LD R3,0
        1   =>  B"0010_0_0100_00000000", -- LD R4,0
        2   =>  B"0011_1_0011_00000000", -- MOV A,R3 -- BRANCH
        3   =>  B"0100_1_0100_00000000", -- ADD A,R4
        4   =>  B"0011_0_0100_00000000", -- MOV R4,A
        5   =>  B"0011_1_0011_00000000", -- MOV A,R3
        6   =>  B"0010_0_0011_00000001", -- LD R3,1
        7   =>  B"0100_1_0011_00000001", -- ADD A,R3
        8   =>  B"0011_0_0011_00000000", -- MOV R3,A
        9   =>  B"0101_1_0000_00011110", -- SUBI A,30
        10  =>  B"1011_0_0011_11110111", -- BLO (A < 0),-9(volta 9 endereços) -- BRANCH
        11  =>  B"1000_0_0100_01010000", -- MOV R5,R4
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