LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY program_counter IS
    PORT (
        i_clock, i_reset, i_enable, i_dump, i_load, i_load_2 : IN STD_LOGIC;
        i_data_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        o_counter_output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END program_counter;

ARCHITECTURE program_counter_rtl OF program_counter IS
    SIGNAL r_counter : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

BEGIN

    p_increment : PROCESS (i_clock) IS
    BEGIN
        IF rising_edge (i_clock) THEN

            IF i_enable = '1' THEN
                IF r_counter = "00001111" THEN
                    r_counter <= "00000000";
                ELSE
                    r_counter <= STD_LOGIC_VECTOR(unsigned(r_counter) + 1);
                END IF;
            END IF;

            IF i_reset = '1' THEN
                r_counter <= "00000000";
            END IF;

            IF (i_load = '1' OR i_load_2 = '1') THEN
                r_counter <= i_data_in;
            END IF;
        END IF;

    END PROCESS p_increment;

    o_counter_output <= r_counter WHEN (i_dump = '1') ELSE
        "ZZZZZZZZ";

END program_counter_rtl;