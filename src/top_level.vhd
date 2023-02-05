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
    constant c_clock_multiplier :  natural := 10000000; --clock frequency --27000000 max
    signal r_clock_counter : natural range 0 to c_clock_multiplier; --max range is clock cycles per second
    signal w_sysclk : std_logic := '0'; --system clock that the SAP 1 operates at
    signal w_led2 : std_logic := '0';

    signal r_data_bus : std_logic_vector(7 downto 0) := "LLLLLLLL"; --data bus --Note: should be pulled down to gnd hence weak low

    signal r_debug : natural range 0 to 31 := 0; --for testing
    signal w_halt : std_logic := '0';

--***********************************CONTROL BUS****************************************
--declaring all the control bus lines and setting their default states
--############PC##############
    signal w_reset_pc, w_load_pc, w_enable_pc: std_logic  := '0';
    signal w_dump_pc: std_logic := '0';

--############General Register A##############
    signal w_write_A, w_read_A: std_logic  := '0';
    signal w_output_direct_A: std_logic_vector(7 downto 0);

--############General Register A##############
    signal w_write_B, w_read_B: std_logic  := '0';
    signal w_output_direct_B: std_logic_vector(7 downto 0);

--############Memory Address Register##############
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

--###############RAM################
    signal w_ram_load, w_ram_dump: std_logic  := '0';

--###########ADD SUB A and B registers#############
    signal w_add_reg_A_B, w_sub_reg_A_B: std_logic  := '0';

--###############Microinstruction counter################
    signal control_bus : std_logic_vector(15 downto 0):= "LLLLLLLLLLLLLLLL";
    signal microinstruction_counter: std_logic_vector(2 downto 0); --3 bit counter

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
            if falling_edge (w_sysclk) then --on the falling edge of clock
                microinstruction_counter <= microinstruction_counter + 1;
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
        o_output(3 downto 0) => r_data_bus(3 downto 0),
        o_output_direct(3 downto 0) => w_INS_out_L, --UNUSED
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

    SP_RAM : entity work.single_port_RAM  port map (
        o_data_out => r_data_bus,
        i_data_in => r_data_bus,
        i_clk => w_sysclk,
        i_address => w_MA_out,
        i_load => w_ram_load,
        i_dump => w_ram_dump
    );

    ADD_SUB_REG_A_B : entity work.adder_substractor_8bit  port map (
        i_reg_a => w_output_direct_A,
        i_reg_b => w_output_direct_B,
        i_add => w_add_reg_A_B,
        i_sub => w_sub_reg_A_B,
        o_result => r_data_bus
    );

    MICROCODE_LUT : entity work.microcode_lut  port map (
        dout => control_bus,
        clk => not w_sysclk,
        oce => '0',
        ce => '1',
        reset => '0',
        wre => '0',
        ad(6 downto 3) => w_INS_decoder_in,
        ad(2 downto 0) => microinstruction_counter,
        din => "XXXXXXXXXXXXXXXX"
    );

--****************************ATTACHING CONTROL BUS TO MICROCODE_LUT*************************
    control_bus(15) <= w_halt;
    control_bus(14) <= w_read_MA;
    control_bus(13) <= w_ram_load;
    control_bus(12) <= w_ram_dump;
    control_bus(11) <= w_write_INS;
    control_bus(10) <= w_read_INS;
    control_bus(9) <= w_read_A;
    control_bus(8) <= w_write_A;
    control_bus(7) <= w_add_reg_A_B;
    control_bus(6) <= w_sub_reg_A_B;
    control_bus(5) <= w_read_B;
    control_bus(4) <= w_read_ROUT;
    control_bus(3) <= w_enable_pc;
    control_bus(2) <= w_dump_pc;
    control_bus(1) <= w_load_pc;

  w_led2 <= '0';
  o_data_bus <= w_ROUT; -- output the data bus 

end behavioral;