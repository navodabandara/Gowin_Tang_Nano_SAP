library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_blinker is
  port (
    i_clock      : in  std_logic;
    o_led_drive  : out std_logic
    );
end led_blinker;

architecture rtl of led_blinker is
 
  -- Constants to create the frequencies needed:
  -- Formula is: (27 MHz / 0.5 Hz * 50% duty cycle)
  -- So for 0.5 Hz: 27,000,000 / 0.5 * 0.5 = 27,000,000
  constant c_COUNT   : natural := 27000000;
 
  -- These signals will be the counters:
  signal r_COUNT   : natural range 0 to c_COUNT;
   
  -- These signals will toggle at the frequencies needed:
  signal r_TOGGLE   : std_logic := '0';
 
begin
 
  -- All processes toggle a specific signal at a different frequency.
  -- They all run continuously even if the switches are
  -- not selecting their particular output.
      
  p_half_HZ : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      if r_COUNT = c_COUNT-1 then  -- -1, since counter starts at 0 , when it reaches 27M counts
        r_TOGGLE <= not r_TOGGLE; --toggle signal toggle
        r_COUNT    <= 0; --reset counter
      else --if counter not full
        r_COUNT <= r_COUNT + 1;  --increment counter
      end if;
    end if;
  end process p_half_HZ;
 
  o_led_drive <= r_TOGGLE;
 
end rtl;