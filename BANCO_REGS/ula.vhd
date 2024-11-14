-- Giovane Limas Salvi - 2355841 - s71
-- Rafael Carvalho Bergo - 2387190 - s71

------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is port (
    entr0:              in unsigned(15 downto 0);
    entr1:              in unsigned(15 downto 0);
    operation:          in unsigned(1 downto 0);
    result:             out unsigned(15 downto 0);

    overflow_flag:      out std_logic;
    carry_flag:         out std_logic;
    zero_flag:          out std_logic
);
end entity;

architecture a_ula of ula is

signal sum, sub, op_and, op_or:            unsigned(15 downto 0) := (others => '0');
signal zero:                                unsigned(15 downto 0) := (others => '0');
signal sum_17_bits, sub_17_bits:            unsigned(16 downto 0) := (others => '0');
signal carry_sum, carry_sub:                std_logic := '0';

begin
    -- operacoes com valores unsigned
    sum <= entr0 + entr1;
    sub <= entr0 + (not(entr1) + "0000000000000001");
    op_and <= entr0 and entr1;
    op_or <= entr0 or entr1;

    -- resultado da operação
    result <=   sum when operation = "00" else -- soma
                sub when operation = "01" else -- subtração
                op_and when operation = "10" else -- and
                op_or when operation = "11" else -- or
                "0000000000000000";

    -- flag zero
    zero_flag <=    '1' when (
                        (operation = "00" and sum = zero) or
                        (operation = "01" and sub = zero) or
                        (operation = "10" and op_and = zero) or
                        (operation = "11" and op_or = zero)
                    ) else '0';
             
    -- flag carry
    sum_17_bits <= ('0' & entr0) + ('0' & entr1);
    sub_17_bits <= ('0' & entr0) - ('0' & entr1);

    carry_sum <= sum_17_bits(16);
    carry_sub <= sub_17_bits(16);

    carry_flag <=   carry_sum when operation = "00" else
                    carry_sub when operation = "01" else
                    '0';

    -- flag overflow
    overflow_flag <= '1' when (operation = "00" and 
                            ((entr0(15) = '0' and entr1(15) = '0' and sum(15) = '1') or 
                             (entr0(15) = '1' and entr1(15) = '1' and sum(15) = '0'))) or
                          (operation = "01" and 
                            ((entr0(15) = '0' and entr1(15) = '1' and sub(15) = '1') or 
                             (entr0(15) = '1' and entr1(15) = '0' and sub(15) = '0')))
                   else '0';

end architecture;