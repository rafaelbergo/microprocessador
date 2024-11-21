library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is 
    port (
        clk:        in std_logic;
        rst:        in std_logic;
        toggle:     in std_logic;
        state:      out std_logic
    );
end entity;

architecture a_state_machine of state_machine is

    component ff_t is
        port( 
            clk    : in std_logic;
            rst    : in std_logic;
            t      : in std_logic;
            q      : out std_logic
        );
    end component;

    signal q_state: std_logic := '0';

begin

    ff_t_uut: ff_t port map(
        clk => clk,
        rst => rst,
        t   => toggle,
        q   => q_state
    );

    state <= q_state;


end architecture;