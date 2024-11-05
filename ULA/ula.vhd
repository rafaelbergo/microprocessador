library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is port (
    entr0:      in unsigned(15 downto 0);
    entr1:      in unsigned(15 downto 0);
    valor_imm:  in unsigned(15 downto 0);
    operation:  in unsigned(2 downto 0);
    saida:      out unsigned(15 downto 0);
    overflow_flag : out std_logic;
    carry_flag : out std_logic
);
end entity;

architecture a_ula of ula is

signal soma, subtracao_reg, subtracao_imm, op_compl2, op_and : unsigned(15 downto 0);
signal entr0, entr1 : unsigned(15 downto 0);

begin
    -- Operacoes com valores unsigned
    soma = entr0 + entr1;
    subtracao_reg = entr0 - entr1;
    subtracao_imm = entr0 - valor_imm;
    op_compl2 = not (entr1) + 1;
    op_and = entr0 and entr1;

    saida <= soma when operation = "000" else
             subtracao_reg when operation = "001" else
             subtracao_imm when operation = "010" else
             op_compl2 when operation = "011" else
             op_and when operation = "100" else
             "0000000000000000"
             



  
end architecture;