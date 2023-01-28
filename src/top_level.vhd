library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_blinker is
  port (
    i_clock      : in  std_logic;
    o_led_0      : out std_logic;
    o_led_1      : out std_logic;
    o_led_2      : out std_logic;
    o_led_3      : out std_logic;
    o_led_4      : out std_logic;
    o_led_5      : out std_logic;
    o_led_6      : out std_logic;
    o_led_7      : out std_logic

    );
end led_blinker;

architecture rtl of led_blinker is
 
  -- Constants to create the frequencies needed:
  -- Formula is: (27 MHz / 0.5 Hz * 50% duty cycle)
  -- So for 0.5 Hz: 27,000,000 / 0.5 * 0.5 = 27,000,000
  constant c_COUNT   : natural := 27000000;
  constant c_COUNT_9 : natural := 10;
 
  -- These signals will be the counters:
  signal r_COUNT   : natural range 0 to c_COUNT;
  signal r_COUNT_9 : natural range 0 to c_COUNT_9;
   
  -- These signals will toggle at the frequencies needed:
  signal r_led_0      :  std_logic  := '1';
  signal r_led_1      :  std_logic  := '0';
  signal r_led_2      :  std_logic  := '0';
  signal r_led_3      :  std_logic  := '0';
  signal r_led_4      :  std_logic  := '0';
  signal r_led_5      :  std_logic  := '0';
  signal r_led_6      :  std_logic  := '0';
  signal r_led_7      :  std_logic  := '0';
 
begin
 
  -- All processes toggle a specific signal at a different frequency.
  -- They all run continuously even if the switches are
  -- not selecting their particular output.
      
  p_half_HZ : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      if r_COUNT = c_COUNT-1 then  -- -1, since counter starts at 0 , when it reaches 27M counts
        r_COUNT_9 <= r_COUNT_9 + 1; --increment second counter
        r_COUNT    <= 0; --reset counter
        r_led_1 <= r_led_0;
        r_led_2 <= r_led_1;
        r_led_3 <= r_led_2;
        r_led_4 <= r_led_3;
        r_led_5 <= r_led_4;
        r_led_6 <= r_led_5;
        r_led_7 <= r_led_6;
      else --if counter not full
        r_COUNT <= r_COUNT + 1;  --increment counter
      end if;

      if r_COUNT_9 = c_COUNT_9-1 then
        r_COUNT_9 <= 0;
        r_led_0 <= '1';
        r_led_1 <= '0';
        r_led_2 <= '0';
        r_led_3 <= '0';
        r_led_4 <= '0';
        r_led_5 <= '0';
        r_led_6 <= '0';
        r_led_7 <= '0';
      end if;

    end if;
  end process p_half_HZ;
 
  o_led_0 <= r_led_0;
  o_led_1 <= r_led_1;
  o_led_2 <= r_led_2;
  o_led_3 <= r_led_3;
  o_led_4 <= r_led_4;
  o_led_5 <= r_led_5;
  o_led_6 <= r_led_6;
  o_led_7 <= r_led_7;
 
end rtl;