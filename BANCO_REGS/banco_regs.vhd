library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is 
    port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_wr:        in unsigned(15 downto 0);
        reg_wr:         in unsigned(3 downto 0); -- escolhe em qual registrador escrever
        sel_reg_r1:     in unsigned(3 downto 0); -- escolhe qual registrador ler 1
        sel_reg_r2:     in unsigned(3 downto 0); -- escolhe qual registrador ler 2
        data_out_r1:    out unsigned(15 downto 0) -- saida do registrador 1
        data_out_r2:    out unsigned(15 downto 0) -- saida do registrador 2
    );
end entity;

architecture a_banco_regs of banco_regs is

    component regs16bits is
        port (
            clk:        in std_logic;
            rst:        in std_logic;
            wr_en:      in std_logic;
            data_in:    in unsigned(15 downto 0);
            data_out:   out unsigned(15 downto 0)
        );
    end component;
    
    signal wr_en_regs : std_logic_vector(8 downto 0);
    signal r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out, r8_out : unsigned(15 downto 0);

begin

    wr_en_regs(0) <= '1' when reg_wr = "0000" else '0';
    wr_en_regs(1) <= '1' when reg_wr = "0001" else '0';
    wr_en_regs(2) <= '1' when reg_wr = "0010" else '0';
    wr_en_regs(3) <= '1' when reg_wr = "0011" else '0';
    wr_en_regs(4) <= '1' when reg_wr = "0100" else '0';
    wr_en_regs(5) <= '1' when reg_wr = "0101" else '0';
    wr_en_regs(6) <= '1' when reg_wr = "0110" else '0';
    wr_en_regs(7) <= '1' when reg_wr = "0111" else '0';
    wr_en_regs(8) <= '1' when reg_wr = "1000" else '0';

    reg0: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(0),
        data_in => "0000000000000000",
        data_out => r0_out
    );

    reg1: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(1),
        data_in => data_wr,
        data_out => r1_out
    );

    reg2: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(2),
        data_in => data_wr,
        data_out => r2_out
    );

    reg3: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(3),
        data_in => data_wr,
        data_out => r3_out
    );

    reg4: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(4),
        data_in => data_wr,
        data_out => r4_out
    );

    reg5: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(5),
        data_in => data_wr,
        data_out => r5_out
    );

    reg6: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(6),
        data_in => data_wr,
        data_out => r6_out
    );

    reg7: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(7),
        data_in => data_wr,
        data_out => r7_out
    );

    reg8: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(8),
        data_in => data_wr,
        data_out => r8_out
    );

    data_out_r1 <= r0_out when sel_reg_r1 = "0000" else
                   r1_out when sel_reg_r1 = "0001" else
                   r2_out when sel_reg_r1 = "0010" else
                   r3_out when sel_reg_r1 = "0011" else
                   r4_out when sel_reg_r1 = "0100" else
                   r5_out when sel_reg_r1 = "0101" else
                   r6_out when sel_reg_r1 = "0110" else
                   r7_out when sel_reg_r1 = "0111" else
                   r8_out when sel_reg_r1 = "1000" else
                   "0000000000000000";

    data_out_r2 <= r0_out when sel_reg_r2 = "0000" else
                    r1_out when sel_reg_r2 = "0001" else
                    r2_out when sel_reg_r2 = "0010" else
                    r3_out when sel_reg_r2 = "0011" else
                    r4_out when sel_reg_r2 = "0100" else
                    r5_out when sel_reg_r2 = "0101" else
                    r6_out when sel_reg_r2 = "0110" else
                    r7_out when sel_reg_r2 = "0111" else
                    r8_out when sel_reg_r2 = "1000" else
                    "0000000000000000";

end architecture;