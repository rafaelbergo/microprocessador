library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is 
    port (
        clk:            in std_logic;
        rst:            in std_logic;
        wr_en:          in std_logic;
        data_wr:        in unsigned(15 downto 0);
        reg_wr:         in unsigned(1 downto 0);
        reg_r1:         in unsigned(1 downto 0);
        data_out:       out unsigned(15 downto 0)
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
    
    signal wr_en_regs : std_logic_vector(3 downto 0);
    signal r0_out, r1_out, r2_out, r3_out :  unsigned(15 downto 0);

begin

    wr_en_regs(0) <= '1' when reg_wr = "00" and wr_en = '1' else '0';
    wr_en_regs(1) <= '1' when reg_wr = "01" and wr_en = '1' else '0';
    wr_en_regs(2) <= '1' when reg_wr = "10" and wr_en = '1' else '0';
    wr_en_regs(3) <= '1' when reg_wr = "11" and wr_en = '1' else '0';

    reg0: regs16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_regs(0),
        data_in => data_wr,
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

    data_out <= r0_out when reg_r1 = "00" else
                r1_out when reg_r1 = "01" else
                r2_out when reg_r1 = "10" else
                r3_out;

end architecture;