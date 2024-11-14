library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ff_t is
    port( clk    : in std_logic;
          rst    : in std_logic;
          t      : in std_logic;
          q      : out std_logic;
          q_not  : out std_logic
    );
end entity;

architecture a_ff_t of ff_t is
    signal q_out : std_logic;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            q_out <= '0';
        elsif rising_edge(clk) then
            if t = '1' then
                q_out <= not t;
            else
                q_out <= not q_out;
            end if;
        end if;
        end process;
        q <= q_out;
        q_not <= not q_out;
end architecture;