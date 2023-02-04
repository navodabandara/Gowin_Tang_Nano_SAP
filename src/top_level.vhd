library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.std_logic_unsigned.all;

entity top_level is
    port(
        i_clock, i_reset : in std_logic;
        o_sysclk : out std_logic
    );
end top_level;

architecture behavioral of top_level is
    --stuff related to clock driving
    constant c_clock_multiplier :  natural := 2700000; --clock frequency
    signal r_clock_counter : natural range 0 to c_clock_multiplier; --max range is clock cycles per second
    signal w_sysclk : std_logic := '0'; --system clock that the SAP 1 operates at

begin
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


end behavioral;