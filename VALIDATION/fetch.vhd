library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
    port( 
        clk                 : in std_logic;
        rst                 : in std_logic;
        rd_rom              : in std_logic;
        wr_pc               : in std_logic;
        jump_en             : in std_logic;
        instruction         : out unsigned(16 downto 0);
        blo                 : in std_logic;
        ble                 : in std_logic
    );
end entity;

architecture a_fetch of fetch is

    signal data_in_pc                      : unsigned(6 downto 0) := "0000000";
    signal data_out_pc                     : unsigned(6 downto 0);
    signal instruction_s                   : unsigned(16 downto 0);
    signal wr_pc_s                         : std_logic;                

    component rom is port (
        clk:        in std_logic;
        address:    in unsigned(6 downto 0);
        rd_rom:     in std_logic;
        data:       out unsigned(16 downto 0)
    );
    end component;

    component pc is port (
        clk:        in std_logic;
        rst:        in std_logic;
        wr_en:      in std_logic;
        data_in:    in unsigned(6 downto 0);
        data_out:   out unsigned(6 downto 0)
    );
    end component;

begin

    rom_uut: rom port map (
        clk => clk,
        address => data_out_pc,
        data => instruction_s,
        rd_rom => rd_rom
    );

    pc_uut: pc port map (
        clk => clk,
        rst => rst,
        wr_en => wr_pc_s,
        data_in => data_in_pc,
        data_out => data_out_pc
    );

    instruction <= instruction_s;
    wr_pc_s <= '1' when (wr_pc='1' or jump_en='1' or ble='1' or blo='1') else '0';

    -- TODO: otimizar o uso do ble e blo(subir somente 1 pino)
    data_in_pc <=   instruction_s(6 downto 0) when jump_en='1' else
                    data_out_pc + instruction_s(6 downto 0) when (ble='1' or blo='1') else 
                    data_out_pc + "0000001";
end architecture;