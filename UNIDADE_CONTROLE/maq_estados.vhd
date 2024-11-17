library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados is
   port( clk    : in std_logic;
         rst    : in std_logic;
         estado : out std_logic
   );
end entity;

architecture a_maq_estados of maq_estados is
      signal estado_s : std_logic;
      signal ff_t_s : std_logic;

      component ff_t is
            port( clk    : in std_logic;
                  rst    : in std_logic;
                  t      : in std_logic;
                  q      : out std_logic
            );
      end component;

begin
      ff_t_uut: ff_t port map(
            clk => clk,
            rst => rst,
            t   => '1',
            q   => estado_s
      );

      estado <= estado_s;
 
end architecture;