library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is 
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(16 downto 0);
        rd_rom          : out std_logic;
        wr_banco        : out std_logic;
        wr_pc           : out std_logic;
        mov_a_reg       : out std_logic;
        mov_reg_a       : out std_logic;
        op_ula          : out std_logic;
        jump_en         : out std_logic;
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
    signal mov_reg_a_s : std_logic;

begin

    state_machine_uut: state_machine port map(
        clk => clk,
        rst => rst,
        state => state
    );

    opcode <= instruction(16 downto 13);

    -- fetch
    rd_rom <= '1' when state = "00" else '0';

    mov_a_reg <= '1' when opcode = "0011" and state = "01" and instruction(12) = '1' and rst = '0' else '0';
    mov_reg_a_s <= '1' when opcode = "0011" and state = "01" and instruction(12) = '0' and rst = '0' else '0';
    mov_reg_a <= mov_reg_a_s;

    op_ula <= '1' when (opcode = "0100" and state = "10") or (opcode = "0110" and state = "10") else '0';

    wr_banco <= '1' when (opcode = "0010" and state = "01" and rst = '0') or mov_reg_a_s = '1' else '0';
    wr_pc <= '1' when state = "00" and rst = '0' else '0';

    jump_en <= '1' when opcode = "1010" and state = "01" else '0';

    operation <=    "00" when opcode = "0100" and state = "10" else -- ADD
                    "01" when opcode = "0110" and state = "10" else -- SUB
                    "10" when opcode = "0101" and state = "10" else -- SUBI
                    "11";                                           -- CMPR

    


    

end architecture;