library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is port (
    entr0:      in unsigned(15 downto 0);
    entr1:      in unsigned(15 downto 0);
    operation:  in unsigned(2 downto 0);
    saida:      out unsigned(15 downto 0);
    overflow_flag : out std_logic;
    carry_flag : out std_logic;
    zero_flag : out std_logic
    cmp_maior_flag : out std_logic
    cmp_menor_flag : out std_logic
    cmp_igual_flag : out std_logic
);
end entity;

architecture a_ula of ula is

signal soma, subtracao, op_compl2, op_and, cmpr : unsigned(15 downto 0);
signal entr0, entr1 : unsigned(15 downto 0);
signal zero:                                unsigned(15 downto 0) := (others => '0');
signal sum_17_bits, sub_17_bits:            unsigned(16 downto 0) := (others => '0');
signal carry_sum, carry_sub:                std_logic := '0';

begin
    -- Operacoes com valores unsigned
    soma = entr0 + entr1;
    subtracao = entr0 - entr1;
    op_compl2 = not (entr1) + 1;
    op_and = entr0 and entr1;
    cmpr = entr0 - entr1;

    saida <= soma when operation = "000" else
             subtracao when operation = "001" else
             op_compl2 when operation = "010" else
             op_and when operation = "011" else
             cmpr when operation = "100" else
             "0000000000000000"
             
    -- Flags

    sum_17_bits <= ('0' & entr1) + ('0' & entr0);
    sub_17_bits <= ('0' & entr1) - ('0' & entr0);

    carry_sum <= sum_17_bits(16);
    carry_sub <= '0' when entr1 <= entr0 else '1'; 

    carry_flag <=   carry_sum when operation = "00" else
                    carry_sub when operation = "01" else
                    '0';

    overflow_flag <= '1' when (entr0(15)='1' and entr1(15)='1') or (entr0(15)='0' and entr1(15)='0') else '0';

    -- Flags para o compare
    cmp_maior_flag <= '1' when cmpr > "0000000000000000" else '0'; -- Entr0 > Entr1
    cmp_menor_flag <= '1' when cmpr < "0000000000000000" else '0'; -- Entr0 < Entr1
    cmp_igual_flag <= '1' when cmpr = "0000000000000000" else '0'; -- Entr0 == Entr1
  
    zero_flag <= '1' when saida = "0000000000000000" else '0';
end architecture;