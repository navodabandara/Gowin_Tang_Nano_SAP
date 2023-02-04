library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
    port(
        i_clock, i_reset, i_enable, i_dump, i_load : in std_logic;
        i_data_in : in std_logic_vector (7 downto 0);
        o_counter_output : out std_logic_vector(7 downto 0)
    );
end program_counter;

architecture program_counter_rtl of program_counter is
    signal r_counter : std_logic_vector(7 downto 0) := "00000000";

begin

    p_increment : process (i_clock) is
    begin
            if rising_edge (i_clock) then
				
                if i_enable = '1' then
							if r_counter = "00001111" then
								r_counter <= "00000000";
							else
								r_counter <= std_logic_vector(unsigned(r_counter) + 1);
							end if;
                end if;

                if i_reset = '1' then
                    r_counter <= "00000000";
                end if;

                if i_load = '1' then
                    r_counter <= i_data_in;
                end if;
            end if;

    end process p_increment;

    o_counter_output <= r_counter when (i_dump = '1') else "ZZZZZZZZ";

end program_counter_rtl;