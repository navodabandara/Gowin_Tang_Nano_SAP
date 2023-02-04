library ieee;
use ieee.std_logic_1164.all;

entity register_8bit is
    port(
        i_clk       : in std_logic;
        i_input     : in std_logic_vector (7 downto 0);  --inputs of the register from bus
        i_read      : in std_logic; -- pulling high will read the contects of input
        i_write     : in std_logic; -- pulling high will write the content of the register to the output
        o_output_direct  : out std_logic_vector (7 downto 0); -- direct output with no tri state high impedance for ALUs
        o_output    : out std_logic_vector (7 downto 0) -- output to bus
    );
end register_8bit;

architecture register_8bit_rtl of register_8bit is

    signal r_register : std_logic_vector (7 downto 0); -- register to store 8 bit value

begin

    process (i_clk) is
    begin
        if rising_edge (i_clk) then -- on rising_edge of enabling read
            if (i_read = '1') then  -- load contents of inputs to register
                r_register <= i_input ;
            end if;
        end if;
    end process;
    o_output_direct <= r_register;
    o_output <= r_register when (i_write = '1') else "ZZZZZZZZ"; --when write is enabled, load contents of register to bus, else output will be in tri-state

end register_8bit_rtl;