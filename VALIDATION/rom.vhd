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
-- 1101 AND
-- 1110 OR
-- 1111

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant content_rom: mem := (
         -- INICIALIZACAO
        0   =>  B"0010_0_0000_00000010", -- LD R0,2
        1   =>  B"0010_0_0001_00000001", -- LD R1,1
        2   =>  B"0010_0_0011_00000010", -- LD R3,2
        3   =>  B"0010_0_0100_00000100", -- LD R4,4
        4   =>  B"0010_0_1000_00000000", -- LD R8,0
        5   =>  B"0011_1_0000_00000000", -- MOV A,R0

         -- POPULA OS 32 PRIMEIROS BITS
        6   =>  B"0001_0_0000_00000000", -- SW A,0(R0)
        7   =>  B"0100_0_0001_00000000", -- ADD A,R1
        8   =>  B"0011_0_0000_00000000", -- MOV R0,A
        9   =>  B"0101_0_0000_00100000", -- SUBI A,32
        10  =>  B"1001_0_0000_11111010", -- BLE -5
        11  =>  B"1010_0_0000_00010011", -- JUMP 19

         -- ZERA O NUMERO NAO PRIMO
        12  =>  B"0011_1_1000_00000000", -- MOV A,R8
        13  =>  B"0001_0_0100_00000000", -- SW A,0(R4)
        14  =>  B"1010_0_0000_00010111", -- JUMP 23

         -- FUNCAO QUE DIVIDE
        15  =>  B"0110_0_0101_00000000", -- SUB A,R5
        16  =>  B"1011_0_0000_00000110", -- BLO 6
        17  =>  B"1001_0_0000_11111010", -- BLE -6
        18  =>  B"1010_0_0000_00001111", -- JUMP 15

        -- LOOP PRINCIPAL
        19  =>  B"0111_0_0011_00000000", -- LW A,0(R3)
        20  =>  B"0011_0_0101_00000000", -- MOV R5,A
        21  =>  B"0111_0_0100_00000000", -- LW A,0(R4)
        22  =>  B"1010_0_0000_00001111", -- JUMP 15 (FUNCAO DIVISAO)

        -- INCREMENTA R4
        23  =>  B"0011_1_0100_00000000", -- MOV A,R4
        24  =>  B"0100_0_0001_00000000", -- ADD A,R1
        25  =>  B"0011_0_0100_00000000", -- MOV R4,A
        26  =>  B"0101_0_0000_00100000", -- SUBI A,32
        27  =>  B"1001_0_0000_11111001", -- BLE -7

        -- INCREMETA R3
        28  =>  B"0011_1_0011_00000000", -- MOV A,R3
        29  =>  B"0100_0_0001_00000000", -- ADD A,R1
        30  =>  B"0011_0_0011_00000000", -- MOV R3,A
        31  =>  B"0101_0_0000_00100000", -- SUBI A,32
        32  =>  B"1011_0_0000_00000001", -- BLO 1
        33  =>  B"1010_0_0000_00101010", -- JUMP 42 (SAI DO LOOP)
        34  =>  B"0111_0_0011_00000000", -- LW A,0(R3)
        35  =>  B"0101_0_0000_00000000", -- SUBI A,0 (VERIFICA SE O CONTEUDO NAO E 0)
        36  =>  B"1001_0_0000_11110111", -- BLE -9
        37  =>  B"0011_1_0011_00000000", -- MOV A,R3
        38  =>  B"0100_0_0001_00000000", -- ADD A,R1
        39  =>  B"0100_0_0001_00000000", -- ADD A,R1
        40  =>  B"0011_0_0100_00000000", -- MOV R4,A
        41  =>  B"1010_0_0000_00010011", -- JUMP 19
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