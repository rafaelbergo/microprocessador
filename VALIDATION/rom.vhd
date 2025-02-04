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
-- 0001 SW
-- 0010 LD
-- 0011 MOV (A,R) or (R,A)
-- 0100 ADD
-- 0101 SUBI
-- 0110 SUB
-- 0111 LW
-- 1000 MOV (R,R)
-- 1001 BLE
-- 1010 JUMP
-- 1011 BLO
-- 1100 CMPR
-- 1101
-- 1110
-- 1111

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant content_rom: mem := (
         -- INICIALIZACAO
        0   =>  B"0010_0_0000_00000010", -- LD R0,2
        1   =>  B"0010_0_0001_00000001", -- LD R1,1
        2   =>  B"0010_0_0010_00100001", -- LD R2,33
        3   =>  B"0010_0_0011_00000010", -- LD R3,2
        4   =>  B"0010_0_0100_00000100", -- LD R4,4
        5   =>  B"0010_0_1000_00000000", -- LD R8,0
        6   =>  B"0011_1_0000_00000000", -- MOV A,R0

         -- POPULA OS 32 PRIMEIROS BITS
        7   =>  B"0001_0_0000_00000000", -- SW A,0(R0)
        8   =>  B"0100_0_0001_00000000", -- ADD A,R1
        9   =>  B"0011_0_0000_00000000", -- MOV R0,A
        10  =>  B"1100_0_0010_00000000", -- CMPR A,R2
        11  =>  B"1011_0_0000_11111010", -- BLO -5
        12  =>  B"1010_0_0000_00011101", -- JUMP 29

         -- FUNCAO QUE INCREMENTA R3
        13  =>  B"0011_1_0011_00000000", -- MOV A,R3
        14  =>  B"0100_0_0001_00000000", -- ADD A,R1
        15  =>  B"0011_0_0011_00000000", -- MOV R3,A
        16  =>  B"1010_0_0000_00101000", -- JUMP 40

        -- FUNCAO QUE INCREMENTA R4
        17  =>  B"0011_1_0100_00000000", -- MOV A,R4
        18  =>  B"0100_0_0001_00000000", -- ADD A,R1
        19  =>  B"0011_0_0100_00000000", -- MOV R4,A
        20  =>  B"1010_0_0000_00011111", -- JUMP 31

         -- ZERA O NUMERO NAO PRIMO
        21  =>  B"0011_1_1000_00000000", -- MOV A,R8
        22  =>  B"0001_0_0100_00000000", -- SW A,0(R4)
        23  =>  B"1010_0_0000_00100010", -- JUMP 34

         -- FUNCAO QUE DIVIDE
        24  =>  B"0110_0_0101_00000000", -- SUB A,R5
        25  =>  B"1100_0_0111_00000000", -- CMPR A,R5
        26  =>  B"1011_0_0000_00000111", -- BLO 7
        27  =>  B"1001_0_0000_11111001", -- BLE -7
        28  =>  B"1010_0_0000_00011000", -- JUMP 24

        29  =>  B"0111_0_0011_00000000", -- LW A,0(R3)
        30  =>  B"0011_0_0101_00000000", -- MOV R5,A
        31  =>  B"0111_0_0100_00000000", -- LW A,0(R4)
        32  =>  B"0011_0_0110_00000000", -- MOV R6,A
        33  =>  B"1010_0_0000_00011000", -- JUMP 24
        34  =>  B"0011_1_0110_00000000", -- MOV A,R6
        35  =>  B"0100_0_0001_00000000", -- ADD A,R1
        36  =>  B"0011_0_0110_00000000", -- MOV R6,A
        37  =>  B"1100_0_0010_00000000", -- CMPR A,R2
        38  =>  B"1011_0_0000_11101011", -- BLO -21

        39  =>  B"1010_0_0000_00001101", -- JUMP 13
        40  =>  B"1100_0_0010_00000000", -- CMPR A,R2
        41  =>  B"1011_0_0000_11110011", -- BLO -13

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