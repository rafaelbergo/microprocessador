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
-- 1100
-- 1101
-- 1110
-- 1111


architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant content_rom: mem := (
        -- INICIALIZA OS VALORES DE R0 E R1 E A MEMORIA
        0   =>  B"0010_0_0000_00000000", -- LD R0,0     -- VALOR 1
        1   =>  B"0010_0_0001_00000001", -- LD R1,1     -- VALOR 2
        2   =>  B"0010_0_0010_00000000", -- LD R2,0     -- POSICAO
        3   =>  B"0010_0_0011_00000001", -- LD R3,1     -- INCREMENTADOR
        4   =>  B"0011_1_0000_00000000", -- MOV A,R0
        5   =>  B"0001_1_0010_00000000", -- SW A,0(R2)  -- armazena valor 1 posição
        6   =>  B"0011_1_0001_00000000", -- MOV A,R1
        7   =>  B"0001_1_0010_00000001", -- SW A,1(R2)  -- armazena valor 2 posição
        8   =>  B"1010_0_0000_00001110", -- JUMP 14
        
        -- FUNCAO QUE PEGA OS VALORES DA MEMORIA E GUARDA NOS REGISTRADORES R0 E R1
        9   =>  B"0111_1_0010_00000000", -- LW A,0(R2)
        10  =>  B"0011_0_0000_00000000", -- MOV R0,A
        11  =>  B"0111_1_0010_00000001", -- LW A,1(R2)
        12  =>  B"0011_0_0001_00000000", -- MOV R1,A
        13  =>  B"1010_0_0000_00001111", -- JUMP 15

        -- FUNCAO QUE FAZ A SOMA DE FIBONACII
        14  =>  B"1010_0_0000_00001001", -- JUMP 9      -- LOOP 
        15  =>  B"0011_1_0000_00000000", -- MOV A,R0
        16  =>  B"0100_1_0001_00000000", -- ADD A,R1
        17  =>  B"0001_0_0010_00000010", -- SW A,2(R2)  -- ARMAZENA O RESULTADO NA MEMORIA
        18  =>  B"0011_1_0010_00000000", -- MOV A,R2
        19  =>  B"0100_0_0011_00000000", -- ADD A,R3
        20  =>  B"0011_0_0010_00000000", -- MOV R2,A
        21  =>  B"0101_1_0000_00011110", -- SUBI A,30
        22  =>  B"1011_0_0000_11110111", -- BLO (A < 0) -> (volta 9 endereços) -- BRANCH

        --21  =>  B"1010_0_0000_0000____", -- JUMP

        -- 3   =>  B"0100_1_0100_00000000", -- ADD A,R4
        -- 4   =>  B"0011_0_0100_00000000", -- MOV R4,A
        -- 5   =>  B"0011_1_0011_00000000", -- MOV A,R3
        -- 6   =>  B"0010_0_0011_00000001", -- LD R3,1
        -- 7   =>  B"0100_1_0011_00000001", -- ADD A,R3
        -- 8   =>  B"0011_0_0011_00000000", -- MOV R3,A
        -- 9   =>  B"0101_1_0000_00011110", -- SUBI A,30
        -- 10  =>  B"1011_0_0011_11110111", -- BLO (A < 0),-9(volta 9 endereços) -- BRANCH
        -- 11  =>  B"1000_0_0100_01010000", -- MOV R5,R4
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