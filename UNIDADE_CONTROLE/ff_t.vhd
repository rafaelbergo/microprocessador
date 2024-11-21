library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ff_t is
    port( 
        clk    : in std_logic;
        rst    : in std_logic;
        t      : in std_logic;
        q      : out std_logic
    );
end entity;

architecture a_ff_t of ff_t is
    signal q_s : std_logic;
    -- t = 1 -> q = mantem
    -- t = 0 -> q = not q
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q_s <= '0';
        elsif t = '1' then
            if rising_edge(clk) then
                q_s <= not q_s;
            end if;
        end if;
    end process;
    q <= q_s;
end architecture;