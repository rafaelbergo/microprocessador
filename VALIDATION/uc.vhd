library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is 
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        instruction     : in unsigned(16 downto 0);
        acum            : in unsigned(15 downto 0);
        rd_rom          : out std_logic;
        wr_banco        : out std_logic;
        wr_pc           : out std_logic;
        mov_reg         : out std_logic_vector(2 downto 0);
        jump_abs        : out std_logic;
        op_const        : out std_logic;
        operation       : out unsigned(1 downto 0);
        is_nop          : out std_logic;
        wr_ram          : out std_logic;
        wr_acum         : out std_logic;
        mov_a_ram       : out std_logic;
        carry_flag      : in std_logic;
        zero_flag       : in std_logic;
        jump_re         : out std_logic;
        wr_flag         : out std_logic
    );
end entity;

architecture a_uc of uc is

    component state_machine is port (
        clk:        in std_logic;
        rst:        in std_logic;
        state:      out unsigned(1 downto 0)
    );
    end component;

    signal state                                    : unsigned(1 downto 0);
    signal opcode                                   : unsigned(3 downto 0);
    signal mov_reg_a_s, mov_reg_reg, mov_a_reg_s    : std_logic;
    signal is_nop_s, op_ula_s, blo_s, ble_s         : std_logic;

begin

    state_machine_uut: state_machine port map(
        clk => clk,
        rst => rst,
        state => state
    );

    opcode <= instruction(16 downto 13);

    wr_ram <= '1' when state = "10" and opcode = "0001" else '0';
    wr_acum <= '1' when (((mov_a_reg_s='1' or op_ula_s='1') and is_nop_s='0') or ((opcode="0001" or opcode="0111") and state="10")) else '0';
    wr_flag <= '1' when ((opcode="0100" or opcode="0101" or opcode="0110" or opcode="1100") and state="10") else '0';
    wr_banco <= '1' when ((opcode = "0010" and state = "01" and rst = '0') or mov_reg_a_s = '1' or mov_reg_reg = '1') and is_nop_s = '0' else '0';
    wr_pc <= '1' when state = "00" and rst = '0' else '0';

    -- fetch
    is_nop_s <= '1' when opcode = "0000" and state = "01" else '0';
    rd_rom <= '1' when state = "00" else '0';

    mov_reg_a_s <= '1' when opcode = "0011" and state = "01" and instruction(12) = '0' and rst = '0' else '0';
    mov_reg_reg <= '1' when state = "01" and opcode = "1000" else '0';
    mov_a_reg_s <= '1' when (opcode = "0011" and state = "01" and instruction(12) = '1' and rst = '0') else '0';
    mov_a_ram   <= '1' when (opcode = "0111" and state = "10") else '0'; 

    -- mov reg -> reg
    mov_reg(0) <= mov_reg_reg;
    -- mov a -> reg
    mov_reg(1) <= mov_reg_a_s;
    -- mov reg -> a
    mov_reg(2) <= mov_a_reg_s;

    op_ula_s <= '1' when state = "10" and (opcode = "0100" or opcode = "0110" or opcode = "0101") else '0';
    op_const <= '1' when opcode = "0101" else '0';

    -- salto condicional
    blo_s <= '1' when (opcode="1011" and carry_flag = '1' and state="10") else '0';
    ble_s <= '1' when (opcode="1001" and (carry_flag = '1' or zero_flag='1') and state="10") else '0';

    -- jumps enable
    jump_abs <= '1' when (state = "01" and opcode = "1010") else '0';
    jump_re <= '1' when (blo_s='1' or ble_s='1') else '0';

    operation <=    "00" when opcode = "0100" and state = "10" else -- ADD
                    "01" when (opcode = "0110" or opcode="1100" or opcode="0101") and state = "10" else -- SUB, CMPR
                    "10" when opcode = "1101" and state = "10" else -- AND
                    "11";

    is_nop <= is_nop_s;

end architecture;