library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top level is
    port(clk : in std_logic;
        rst : in std_logic;
        estado : in unsigned(1 downto 0);
        data_out_pc : out unsigned(6 downto 0); -- saida do pc
        data_instr_out : out unsigned(16 downto 0); -- saida do registrador de instrucao
        data_out_banco_reg : out unsigned(15 downto 0); -- saida do reg  do banco de registradores
        data_out_acumulador : out unsigned(15 downto 0); -- saida do acumulador
        data_out_ula : out unsigned(15 downto 0) -- saida da ula
    );
    end entity;

architecture a_top_level of top_level is
    component pc is port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in unsigned(6 downto 0);
        data_out:   out unsigned(6 downto 0)
        );
    end component;

    component registrador_instrucao is
        port (
            clk:            in std_logic;
            wr_en:          in std_logic;
            instr_in:        in unsigned(16 downto 0);
            instr_out:       out unsigned(16 downto 0)
        );
    end component;

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
    
    component acumulador is
        port(
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
            zero_flag:          out std_logic
        );
    end component;

    -- pc
    signal wr_en_pc : std_logic;
    signal data_in_pc, data_out_pc : unsigned(6 downto 0); -- sinal de entrada e saida do pc

    -- registrador de instrucao
    signal wr_en_reg_instr : std_logic;
    signal instr_in_reg_instr, instr_out_reg_instr : unsigned(16 downto 0); -- sinal de entrada e saida do registrador de instrucao

    -- banco de registradores
    signal wr_en_banco_regs : std_logic;
    signal data_wr_banco_regs, data_out_banco_regs : unsigned(15 downto 0); -- sinal de entrada e saida do banco de registradores
    signal reg_wr_banco_regs, sel_reg_banco_regs : unsigned(3 downto 0); -- sinal de escrita e selecao do banco de registradores
    
    -- acumulador
    signal wr_en_acumulador : std_logic;
    signal data_in_acumulador, data_out_acumulador : unsigned(15 downto 0); -- sinal de entrada e saida do acumulador

    -- ula
    signal flag_overflow_ula, flag_carry_ula, flag_zero_ula : std_logic;
    signal data_out_ula : unsigned(15 downto 0); -- sinal de saida da ula

begin
    pc_tl: pc port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_pc,
        data_in => data_in_pc,
        data_out => data_out_pc
    );

    registrador_instrucao_tl: registrador_instrucao port map(
        clk => clk,
        wr_en => wr_en_reg_instr,
        instr_in => instr_in_reg_instr,
        instr_out => instr_out_reg_instr
    );

    banco_regs_tl: banco_regs port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_banco_regs,
        data_wr => data_wr_banco_regs,
        reg_wr => reg_wr_banco_regs,
        sel_reg => sel_reg_banco_regs,
        data_out => data_out_banco_regs
    );

    acumulador_tl: acumulador port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_acumulador,
        data_in => data_in_acumulador,
        data_out => data_out_acumulador
    );
    
    ula_tl: ula port map(
        entr0 => data_out_banco_regs,
        entr1 => data_out_acumulador,
        operation => "00",
        result => data_out_ula,
        overflow_flag => flag_overflow_ula,
        carry_flag => flag_carry_ula,
        zero_flag => flag_zero_ula 
    );

-- Sinais visiveis no GTKwave
--reset; --
--•clock; --
--•estado; --
--•PC;
--•instrução (saída do Registrador de Instrução); --
--•saídas do banco de registradores (valores de Reg1 e Reg2) e acumulador  ou então  valores --
--internos de todos os registradores, em ordem; -- 
--•saída da ULA. --