library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is 
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(15 downto 0);
        wr_en_regs      : out std_logic;
        rd_rom          : out std_logic;
        rd_banco_regs   : out std_logic;
        load_reg        : out std_logic;
        operation       : out unsigned(1 downto 0)
    );
end entity;

architecture a_uc of uc is

    component state_machine is port (
        clk:        in std_logic;
        rst:        in std_logic;
        state:      out unsigned(1 downto 0)
    );
    end component;

    signal state : unsigned(1 downto 0);
    signal opcode: unsigned(3 downto 0);

begin

    state_machine_uut: state_machine port map(
        clk => clk,
        rst => rst,
        state => state
    );

    opcode <= instruction(15 downto 12);

    -- fetch
    rd_rom <= '1' when state = "00" else '0';
    -- decode
    rd_banco_regs <= '1' when state = "01" else '0';
    -- execute
    wr_en_regs <= '1' when state = "10" else '0';

    load_reg <= '1' when opcode = "0010" and state = "01" else '0';


    operation <=    "00" when opcode = "0100" and state = "10" else -- ADD
                    "01" when opcode = "0100" and state = "10" else -- SUB
                    "10" when opcode = "0101" and state = "10" else -- SUBI
                    "11";                                           -- CMPR

    


    

end architecture;