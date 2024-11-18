library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is
   port( clk    : in std_logic;
         rst    : in std_logic
   );

end entity;

architecture a_unidade_controle of unidade_controle is
    component pc is
        port(
            clk    : in std_logic;
            rst    : in std_logic;
            wr_en  : in std_logic;
            data_in: in unsigned(6 downto 0);
            data_out: out unsigned(6 downto 0)
        );
    end component;

        signal data_in, data_out : unsigned(6 downto 0);
        signal wr_en : std_logic := '1';

begin
    pc_inst: pc
        port map(
            clk => clk,
            rst => rst,
            wr_en => wr_en,
            data_in => data_in,
            data_out => data_out
        );
    
        process(clk, rst, wr_en)
        begin
            if rst = '1' then
                data_in <= "0000000";
            else
                data_in <= data_out + "0000001";
            end if;
        end process;
end architecture;