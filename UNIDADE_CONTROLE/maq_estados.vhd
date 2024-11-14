library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados is
   port( clk    : in std_logic;
         rst    : in std_logic;
         estado : out unsigned(1 downto 0) 
   );

architecture a_maq_estados of maq_estados is
    