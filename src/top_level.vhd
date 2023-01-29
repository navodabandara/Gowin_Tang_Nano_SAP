library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.std_logic_unsigned.all;

entity counter is
    port(
        i_clock, i_reset : in std_logic;
        o_counter_drive : out std_logic_vector(7 downto 0) := "00000000"
    );
end counter;

architecture behavioral of counter is
    signal decimal_counter  : integer := 0 ; --init counter to 0 (seems like this doesn't matter. Starts from the else in p_increment)

    --stuff related to clock driving
    constant c_clock_multiplier :  natural := 2700000; --clock frequency
    signal r_clock_counter : natural range 0 to c_clock_multiplier; --max range is clock cycles per second

begin

    p_increment : process (i_clock, i_reset) is
    begin
            if rising_edge (i_clock) then --on the rising edge of clock
                if r_clock_counter = c_clock_multiplier - 1 then --if the clock is about to overflow
                    r_clock_counter <= 0; --set the clock counter back to 0
                    --do stuff here
                    decimal_counter <= decimal_counter + 1; --increment the other counter
                else
                    r_clock_counter <= r_clock_counter + 1; --else increment the clock counter by 1
                end if;
            end if;

            if i_reset = '0' then --if the reset button is 0
                r_clock_counter <= 0; --reset both counters
                decimal_counter <= 0;
            end if;

    end process p_increment;

    o_counter_drive <= conv_std_logic_vector(decimal_counter, o_counter_drive'length); --set the counter driver as the value in counter

end behavioral;