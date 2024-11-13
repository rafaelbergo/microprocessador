-- Giovane Limas Salvi - 2355841 - s71
-- Rafael Carvalho Bergo - 2387190 - s71
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_ula is
    port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_wr:        in unsigned(15 downto 0);
        reg_wr:         in unsigned(3 downto 0);
        sel_reg:        in unsigned(3 downto 0); 
        ula_operation_sel: in unsigned(1 downto 0);
        operando_cte:   in unsigned(15 downto 0);
        operando_selector: in std_logic; -- define se o operando e uma constante ou um registrador
        out_ula:        out unsigned(15 downto 0)
    );
end entity;

architecture a_banco_regs_ula of banco_regs_ula is
    component banco_regs is
        port (
            clk:            in std_logic;
            rst:            in std_logic;
            wr_en:          in std_logic;
            data_wr:        in unsigned(15 downto 0);
            reg_wr:         in unsigned(3 downto 0);
            sel_reg:     in unsigned(3 downto 0); 
            data_out:    out unsigned(15 downto 0)
        );
    end component;

    component acumulador is port(
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_in:        in unsigned(15 downto 0);
        data_out:       out unsigned(15 downto 0)
    );
    end component;

    component ula is
        port (
            entr0:              in unsigned(15 downto 0);
            entr1:              in unsigned(15 downto 0);
            operation:          in unsigned(1 downto 0);
            result:             out unsigned(15 downto 0);
            overflow_flag:      out std_logic;
            carry_flag:         out std_logic;
            zero_flag:          out std_logic;
            greater_than_flag:  out std_logic;
            less_than_flag :    out std_logic;
            equal_to_flag :     out std_logic
        );
    end component;

    signal data_out_reg, data_out_acumulador : unsigned(15 downto 0);
    signal operando_banco, operando_acumulador : unsigned(15 downto 0);
    signal ula_result  : unsigned(15 downto 0);

begin
    banco_regs_uut: banco_regs port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_wr => ula_result,
        reg_wr => reg_wr,
        sel_reg => sel_reg,
        data_out => data_out_reg
    ); 

    ula_uut: ula port map(
        entr0 => data_out_acumulador, -- primeira entrada vai ser a saida do acumulador
        entr1 => operando_banco, -- segunda entrada vai ser a constante ou a saida do registrador 2
        operation => ula_operation_sel, 
        result => ula_result
    );

    acumulador_uut: acumulador port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_in => ula_result,
        data_out => data_out_acumulador
    );

    -- Operando 1 = Acumulador
    --operando_acumulador <= out_ula;

    -- Operando 2 = Banco de registradores
    operando_banco <= operando_cte when operando_selector = '0' else -- se o operando_selector for 0, o operando vai ser a constante 
                data_out_reg when operando_selector = '1' else -- se o operando_selector for 1, o operando vai ser a saida do registrador
                "0000000000000000";    

    -- pino de saida extra para debug
    out_ula <= ula_result;

end architecture;