--TODO find a way to remove unused ports
--TODO implement reset (perhaps add a rising edge clock independant reset to submodules)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY top_level IS
    PORT (
        i_clock, i_reset : IN STD_LOGIC;
        o_sysclk, o_led2 : OUT STD_LOGIC;
        o_data_bus : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END top_level;

ARCHITECTURE behavioral OF top_level IS
    --stuff related to clock driving
    CONSTANT c_clock_multiplier : NATURAL := 1000000; --clock frequency --27000000 max
    SIGNAL r_clock_counter : NATURAL RANGE 0 TO c_clock_multiplier; --max range is clock cycles per second
    SIGNAL w_sysclk : STD_LOGIC := '0'; --system clock that the SAP 1 operates at
    SIGNAL w_led2 : STD_LOGIC := '0';

    SIGNAL r_data_bus : STD_LOGIC_VECTOR(7 DOWNTO 0) := "LLLLLLLL"; --data bus --Note: should be pulled down to gnd hence weak low

    SIGNAL r_debug : NATURAL RANGE 0 TO 31 := 0; --for testing
    SIGNAL w_halt : STD_LOGIC := '0';

    --***********************************CONTROL BUS****************************************
    --declaring all the control bus lines and setting their default states
    --############PC##############
    SIGNAL w_reset_pc, w_load_pc, w_enable_pc : STD_LOGIC := '0';
    SIGNAL w_dump_pc : STD_LOGIC := '0';

    --############General Register A##############
    SIGNAL w_write_A, w_read_A : STD_LOGIC := '0';
    SIGNAL w_output_direct_A : STD_LOGIC_VECTOR(7 DOWNTO 0);

    --############General Register B##############
    SIGNAL w_write_B, w_read_B : STD_LOGIC := '0';
    SIGNAL w_output_direct_B : STD_LOGIC_VECTOR(7 DOWNTO 0);

    --############Memory Address Register##############
    SIGNAL w_read_MA, w_write_MA : STD_LOGIC := '0'; --write     is unused
    SIGNAL w_MA_out_tristate : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL w_MA_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL w_MA_out_H : STD_LOGIC_VECTOR(3 DOWNTO 0);

    --############Instruction Register##############
    SIGNAL w_read_INS, w_write_INS : STD_LOGIC := '0';
    SIGNAL w_INS_out_L : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL w_INS_decoder_in : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL w_INS_output_direct_H : STD_LOGIC_VECTOR(3 DOWNTO 0); --UNUSED

    --###############Output Register################
    SIGNAL w_read_ROUT, w_write_ROUT : STD_LOGIC := '0'; --write is unused
    SIGNAL w_ROUT, w_ROUT_tristate : STD_LOGIC_VECTOR(7 DOWNTO 0); --w_ROUT_tristate is unused

    --###############RAM################
    SIGNAL w_ram_load, w_ram_dump : STD_LOGIC := '0';

    --###########ADD SUB A and B registers#############
    SIGNAL w_out_reg_A_B, w_sub_reg_A_B : STD_LOGIC := '0';
    SIGNAL w_carry_A_B : STD_LOGIC := '0';

    --###############Microinstruction counter################
    SIGNAL control_bus : STD_LOGIC_VECTOR(15 DOWNTO 0) := "LLLLLLLLLLLLLLLL";
    SIGNAL microinstruction_counter : STD_LOGIC_VECTOR(2 DOWNTO 0); --3 bit counter

    --############CPU FLAGS##############
    SIGNAL w_read_flags : STD_LOGIC := '0';
    SIGNAL r_carry_flag : STD_LOGIC;

BEGIN
    --*********************************SYSCLK DIVIDER***************************************

    sysclk_div : PROCESS (i_clock, i_reset) IS
    BEGIN
        IF rising_edge (i_clock) THEN --on the rising edge of clock
            IF r_clock_counter = c_clock_multiplier - 1 THEN --if the clock is about to overflow
                r_clock_counter <= 0; --set the clock counter back to 0
                w_sysclk <=(NOT w_sysclk) when (w_halt='0') else '0'; --toggle sysclk every c_clock_multiplier clock cycles
            ELSE
                r_clock_counter <= r_clock_counter + 1; --else increment the clock counter by 1
            END IF;
        END IF;

        IF i_reset = '0' THEN --if the reset button is 0
            r_clock_counter <= 0; --reset both counters
        END IF;
    END PROCESS sysclk_div;

    o_sysclk <= w_sysclk; -- show the sysclk on PIN10_IOL15A_LED1
    --***********************************SYSCLK******************************************

    --sysclk process which is the main clock for the SAP 1 architecture
    sysclk : PROCESS (w_sysclk) IS
    BEGIN
        IF falling_edge (w_sysclk) THEN --on the falling edge of clock
            --do stuff
            microinstruction_counter <= microinstruction_counter + 1;

        END IF;
    END PROCESS sysclk;

    o_led2 <= NOT w_led2; -- show the sysclk on PIN10_IOL15A_LED1
    --******************************ENTITY DECLARATIONS***********************************
    --~~~~~~~~~~~~~~~~~~~~PC~~~~~~~~~~~~~~~~~~~~
    PC : ENTITY work.program_counter PORT MAP(
        i_clock => w_sysclk,
        i_reset => w_reset_pc, --needs to be changed to pcs own reset
        i_enable => w_enable_pc,
        i_dump => w_dump_pc,
        i_load => w_load_pc,
        i_data_in => r_data_bus,
        o_counter_output => r_data_bus
        );

    REG_A : ENTITY work.register_8bit PORT MAP (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_A,
        i_write => w_write_A,
        o_output => r_data_bus,
        o_output_direct => w_output_direct_A
        );

    REG_B : ENTITY work.register_8bit PORT MAP (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_B,
        i_write => w_write_B,
        o_output => r_data_bus,
        o_output_direct => w_output_direct_B
        );

    REG_MA : ENTITY work.register_8bit PORT MAP (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_MA,
        i_write => w_write_MA, --UNUSED
        o_output => w_MA_out_tristate,
        o_output_direct(3 DOWNTO 0) => w_MA_out,
        o_output_direct(7 DOWNTO 4) => w_MA_out_H
        );

    REG_INS : ENTITY work.register_8bit PORT MAP (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_INS,
        i_write => w_write_INS,
        o_output(3 DOWNTO 0) => r_data_bus(3 DOWNTO 0),
        o_output(7 DOWNTO 4) => w_INS_output_direct_H, --UNSUSED
        o_output_direct(3 DOWNTO 0) => w_INS_out_L, --UNUSED
        o_output_direct(7 DOWNTO 4) => w_INS_decoder_in
        );

    REG_OUT : ENTITY work.register_8bit PORT MAP (
        i_clk => w_sysclk,
        i_input => r_data_bus,
        i_read => w_read_ROUT,
        i_write => w_write_ROUT, --UNUSED,
        o_output => w_ROUT_tristate, --UNUSED
        o_output_direct => w_ROUT
        );

    SP_RAM : ENTITY work.single_port_RAM PORT MAP (
        o_data_out => r_data_bus,
        i_data_in => r_data_bus,
        i_clk => w_sysclk,
        i_address => w_MA_out,
        i_load => w_ram_load,
        i_dump => w_ram_dump
        );

    ADD_SUB_REG_A_B : ENTITY work.adder_substractor_8bit PORT MAP (
        i_reg_a => w_output_direct_A,
        i_reg_b => w_output_direct_B,
        i_out => w_out_reg_A_B,
        i_sub => w_sub_reg_A_B,
        o_result => r_data_bus,
        o_carry => w_carry_A_B
        
        );

    MICROCODE_LUT : ENTITY work.microcode_lut PORT MAP (
        --~~~~~~~~~~ATTACHING CONTROL BUS TO MICROCODE_LUT~~~~~~~~~~~~~~
        dout(15) => w_halt,
        dout(14) => w_read_MA,
        dout(13) => w_ram_load,
        dout(12) => w_ram_dump,
        dout(11) => w_write_INS,
        dout(10) => w_read_INS,
        dout(9) => w_read_A,
        dout(8) => w_write_A,
        dout(7) => w_out_reg_A_B,
        dout(6) => w_sub_reg_A_B,
        dout(5) => w_read_B,
        dout(4) => w_read_ROUT,
        dout(3) => w_enable_pc,
        dout(2) => w_dump_pc,
        dout(1) => w_load_pc,
        dout(0) => w_read_flags,        

        clk => NOT w_sysclk,
        oce => '0',
        ce => '1',
        reset => '0',
        wre => '0',
        ad(6 DOWNTO 3) => w_INS_decoder_in,
        ad(2 DOWNTO 0) => microinstruction_counter,
        din => "XXXXXXXXXXXXXXXX"
        );

    REG_FLAGS : ENTITY work.register_8bit PORT MAP (
        i_clk => w_sysclk,
        i_input(7 downto 2) => "XXXXXX",
        i_input(1) => 'X',
        i_input(0) => w_carry_A_B,
        i_read => w_read_flags,
        i_write => 'X', --UNUSED
        --o_output => "XXXXXXXX", --UNUSED
        o_output_direct(0) => r_carry_flag
        );


    w_led2 <= r_carry_flag;
    o_data_bus <= w_ROUT; -- output the data bus 

END behavioral;