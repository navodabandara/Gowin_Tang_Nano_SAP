LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY counter IS
    PORT (
        i_clock, i_reset : IN STD_LOGIC;
        o_counter_drive : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000"
    );
END counter;

ARCHITECTURE behavioral OF counter IS
    SIGNAL decimal_counter : INTEGER := 0; --init counter to 0 (seems like this doesn't matter. Starts from the else in p_increment)

    --stuff related to clock driving
    CONSTANT c_clock_multiplier : NATURAL := 2700000; --clock frequency
    SIGNAL r_clock_counter : NATURAL RANGE 0 TO c_clock_multiplier; --max range is clock cycles per second

BEGIN

    p_increment : PROCESS (i_clock, i_reset) IS
    BEGIN
        IF rising_edge (i_clock) THEN --on the rising edge of clock
            IF r_clock_counter = c_clock_multiplier - 1 THEN --if the clock is about to overflow
                r_clock_counter <= 0; --set the clock counter back to 0
                --do stuff here
                decimal_counter <= decimal_counter + 1; --increment the other counter
            ELSE
                r_clock_counter <= r_clock_counter + 1; --else increment the clock counter by 1
            END IF;
        END IF;

        IF i_reset = '0' THEN --if the reset button is 0
            r_clock_counter <= 0; --reset both counters
            decimal_counter <= 0;
        END IF;

    END PROCESS p_increment;

    o_counter_drive <= conv_std_logic_vector(decimal_counter, o_counter_drive'length); --set the counter driver as the value in counter