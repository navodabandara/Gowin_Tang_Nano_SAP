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
    constant c_clock_multiplier :  natural := 27000000; --clock frequency
    signal r_clock_counter : natural range 0 to c_clock_multiplier; --max range is clock cycles per second
    signal w_sysclk, w_led2 : std_logic := '0'; --system clock that the SAP 1 operates at

    signal r_data_bus : std_logic_vector(7 downto 0) := "00000000"; --data bus

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


--sysclk process which is the main clock for the SAP 1 architecture
   sysclk : process (w_sysclk) is
    begin
            if rising_edge (w_sysclk) then --on the rising edge of clock
                w_led2 <= not w_led2;
            end if;
    end process sysclk;

    o_led2 <= not w_led2; -- show the sysclk on PIN10_IOL15A_LED1



--******************************ENTITY DECLARATIONS***********************************
--##########################PC##########################
    PC : entity work.program_counter  port map(
        i_clock => w_sysclk,
        i_reset => '0', --needs to be changed to pcs own reset
        i_enable => '1',
        i_dump => '1',
        i_load => '0',
        i_data_in => r_data_bus,
        o_counter_output=> r_data_bus
    );

    o_data_bus <= r_data_bus; -- output the data bus

end behavioral;