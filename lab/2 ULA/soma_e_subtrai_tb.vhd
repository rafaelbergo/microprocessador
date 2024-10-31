library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soma_e_subtrai_tb is
end;

architecture a_soma_e_subtrai_tb of soma_e_subtrai_tb is
   component soma_e_subtrai
      port( x,y :  in  unsigned(7 downto 0);
      soma,subt :  out unsigned(7 downto 0);
      maior,x_negativo : out std_logic);
   end component;
   signal maior, x_negativo : std_logic;
   signal x, y, soma, subt : unsigned(7 downto 0);

begin
   uut: soma_e_subtrai port map( x => x,
                            y => y,
                            soma => soma,
                            subt => subt,
                            maior => maior,
                            x_negativo => x_negativo);

   process
   begin
        x <= "00011110";
        y <= "00000111";
        wait for 50 ns;

        x <= "01100100";
        y <= "01100100";
        wait for 50 ns;

        x <= "00010010";
        y <= "11111101";
        wait for 50 ns;

wait;
   end process;
end architecture;