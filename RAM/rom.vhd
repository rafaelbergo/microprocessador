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
        -- -- INICIALIZA OS VALORES DE R0 E R1 E A MEMORIA
        0   =>  B"0010_0_0000_00000000", -- LD R0,0     -- R0 = 1
        1   =>  B"0010_0_0001_00000001", -- LD R1,1     -- R1 = 1
        2   =>  B"0010_0_1000_00001111", -- LD R8,15    -- R7 = 15
        3   =>  B"0010_0_0010_00000000", -- LD R2,0     -- POSICAO
        4   =>  B"0010_0_0011_00000001", -- LD R3,1     -- INCREMENTADOR
        5   =>  B"0011_1_0000_00000000", -- MOV A,R0
        6   =>  B"0001_1_0010_00000000", -- SW A,0(R2)  -- armazena valor 1 posição
        7   =>  B"0011_1_0001_00000000", -- MOV A,R1
        8   =>  B"0001_1_0010_00000001", -- SW A,1(R2)  -- armazena valor 2 posição
        9   =>  B"1010_0_0000_00001111", -- JUMP 15
        
        -- FUNCAO QUE PEGA OS VALORES DA MEMORIA E GUARDA NOS REGISTRADORES R0 E R1
        10   =>  B"0111_1_0010_00000000", -- LW A,0(R2)
        11  =>  B"0011_0_0000_00000000", -- MOV R0,A
        12  =>  B"0111_1_0010_00000001", -- LW A,1(R2)
        13  =>  B"0011_0_0001_00000000", -- MOV R1,A
        14  =>  B"1010_0_0000_00010000", -- JUMP 16

        -- FUNCAO QUE FAZ A SOMA DE FIBONACII
        15  =>  B"1010_0_0000_00001010", -- JUMP 10     -- LOOP 
        16  =>  B"0011_1_0000_00000000", -- MOV A,R0
        17  =>  B"0100_1_0001_00000000", -- ADD A,R1
        18  =>  B"0001_0_0010_00000010", -- SW A,2(R2)  -- ARMAZENA O RESULTADO NA MEMORIA
        19  =>  B"0011_1_0010_00000000", -- MOV A,R2
        20  =>  B"0100_0_0011_00000000", -- ADD A,R3
        21  =>  B"0011_0_0010_00000000", -- MOV R2,A
        22  =>  B"1100_0_1000_00000000", -- CMPR A,R8
        23  =>  B"1011_0_0000_11110111", -- BLO -9
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