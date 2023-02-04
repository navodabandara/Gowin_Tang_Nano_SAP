--TODO find a way to remove unused ports

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.std_logic_unsigned.all;

entity top_level is
    port(
        i_clock, i_reset : in std_logic;
        o_sysclk, o_led2 : out std_logic;
        o_data_bus : out std_logic_vector(7 downto 0)
    );
end top_level;

architecture behavioral of top_level is
    --stuff related to clock driving
    constant c_clock_multiplier :  natural := 2700000; --clock frequency
    signal r_clock_counter : natural range 0 to c_clock_multiplier; --max range is clock cycles per second
    signal w_sysclk, w_led2 : std_logic := '0'; --system clock that the SAP 1 operates at

    signal r_data_bus : std_logic_vector(7 downto 0) := "LLLLLLLL"; --data bus --Note: should be pulled down to gnd hence weak low

--***********************************CONTROL BUS****************************************
--declaring all the control bus lines and setting their default states
--############PC##############
    signal w_reset_pc, w_load_pc, w_enable_pc: std_logic  := '0';
    signal w_dump_pc: std_logic := '1';

--############General Register A##############
    signal w_write_A, w_read_A: std_logic  := '0';
    signal w_output_direct_A: std_logic_vector(7 downto 0);

--############General Register A##############
    signal w_write_B, w_read_B: std_logic  := '0';
    signal w_output_direct_B: std_logic_vector(7 downto 0);

--############General Register A##############
    signal w_read_MA, w_write_MA: std_logic  := '0'; --write     is unused
    signal w_MA_out_tristate: std_logic_vector(7 downto 0);
    signal w_MA_out: std_logic_vector(3 downto 0);
    signal w_MA_out_H: std_logic_vector(3 downto 0);


--############Instruction Register##############
    signal w_read_INS, w_write_INS: std_logic  := '0';
    signal w_INS_out_L: std_logic_vector(3 downto 0);
    signal w_INS_decoder_in: std_logic_vector(3 downto 0);

--###############Output Register################
    signal w_read_ROUT, w_write_ROUT: std_logic  := '0'; --write is unused
    signal w_ROUT,w_ROUT_tristate: std_logic_vector(7 downto 0); --w_ROUT_tristate is unused


begin
--*********************************SYSCLK DIVIDER***************************************

    sysclk_div : process (i_clock, i_reset) is
    begin
            if rising_edge (i_clock) then --on the rising edge of clock
                if r_clock_counter = c_clock_multiplier - 1 then --if the clock is about to overflow
                    r_clock_counter <= 0; --set the clock counter back to 0
                    w_sysclk <= not w_sysclk; --toggle sysclk every c_clock_multiplier clock cycles
                else
                    r_clock_counter <= r_clock_counter + 1; --else increment the clock counter by 1
                end if;
            end if;

            if i_reset = '0' then --if the reset button is 0
                r_clock_counter <= 0; --reset both counters
            end if;
    end process sysclk_div;

    o_sysclk <= not w_sysclk; -- show the sysclk on PIN10_IOL15A_LED1

--***********************************SYSCLK******************************************

--sysclk process which is the main clock for the SAP 1 architecture
   sysclk : process (w_sysclk) is
    begin
            if rising_edge (w_sysclk) then --on the rising edge of clock
                w_led2 <= not w_led2;
            end if;
    end process sysclk;

    o_led2 <= not w_led2; -- show the sysclk on PIN10_IOL15A_LED1


--******************************ENTITY DECLARATIONS***********************************
--~~~~~~~~~~~~~~~~~~~~PC~~~~~~~~~~~~~~~~~~~~
    PC : entity work.program_counter  port map(
        i_clock     => w_sysclk,
        i_reset     => w_reset_pc, --needs to be changed to pcs own reset
        i_enable    => w_enable_pc,
        i_dump      => w_dump_pc,
        i_load      => w_load_pc,
        i_data_in   => r_data_bus,
        o_counter_output=> r_data_bus
    );

    REG_A : entity work.register_8bit port map (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_A,
        i_write => w_write_A,
        o_output => r_data_bus,
        o_output_direct => w_output_direct_A
    );

    REG_B : entity work.register_8bit port map (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_B,
        i_write => w_write_B,
        o_output => r_data_bus,
        o_output_direct => w_output_direct_B
    );

    REG_MA : entity work.register_8bit port map (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_MA,
        i_write => w_write_MA, --UNUSED
        o_output => w_MA_out_tristate,
        o_output_direct(3 downto 0) => w_MA_out,
        o_output_direct(7 downto 4) => w_MA_out_H
    );

    REG_INS : entity work.register_8bit port map (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_INS,
        i_write => w_write_INS,
        o_output => r_data_bus,
        o_output_direct(3 downto 0) => w_INS_out_L,
        o_output_direct(7 downto 4) => w_INS_decoder_in
    );

    REG_OUT : entity work.register_8bit port map (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_ROUT, 
        i_write => w_write_ROUT,--UNUSED,
        o_output => w_ROUT_tristate,  --UNUSED
        o_output_direct => w_ROUT
    );

  o_data_bus <= r_data_bus; -- output the data bus

end behavioral;