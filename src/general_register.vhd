LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY register_8bit IS
    PORT (
        i_clk : IN STD_LOGIC;
        i_input : IN STD_LOGIC_VECTOR (7 DOWNTO 0); --inputs of the register from bus
        i_read : IN STD_LOGIC; -- pulling high will read the contects of input
        i_write : IN STD_LOGIC; -- pulling high will write the content of the register to the output
        o_output_direct : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- direct output with no tri state high impedance for ALUs
        o_output : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) -- output to bus
    );
END register_8bit;

ARCHITECTURE register_8bit_rtl OF register_8bit IS

    SIGNAL r_register : STD_LOGIC_VECTOR (7 DOWNTO 0); -- register to store 8 bit value

BEGIN

    PROCESS (i_clk) IS
    BEGIN
        IF rising_edge (i_clk) THEN -- on rising_edge of enabling read
            IF (i_read = '1') THEN -- load contents of inputs to register
                r_register <= i_input;
            END IF;
        END IF;
    END PROCESS;
    o_output_direct <= r_register;
    o_output <= r_register WHEN (i_write = '1') ELSE
        "ZZZZZZZZ"; --when write is enabled, load contents of register to bus, else output will be in tri-state

END register_8bit_rtl;