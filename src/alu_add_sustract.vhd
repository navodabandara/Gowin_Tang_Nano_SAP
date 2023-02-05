library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

--this block is asyncronous

entity adder_substractor_8bit is
    port(
        i_reg_a : in std_logic_vector (7 downto 0);
        i_reg_b : in std_logic_vector (7 downto 0);
        i_add   : in std_logic;
        i_sub   : in std_logic;
        o_result: out std_logic_vector (7 downto 0)
    );
end adder_substractor_8bit;

architecture adder_substractor_8bit_rtl of adder_substractor_8bit is
begin

    addition : process (i_add, i_reg_a, i_reg_b)
    begin
        if i_add = '1' then
            o_result <= std_logic_vector(unsigned(i_reg_a) + unsigned(i_reg_b));
        else
            o_result <= "ZZZZZZZZ";
        end if;
    end process addition;

    substraction : process (i_sub, i_reg_a, i_reg_b)
    begin
        if i_sub = '1' then
            o_result <= std_logic_vector(unsigned(i_reg_a) - unsigned(i_reg_b));
        else
            o_result <= "ZZZZZZZZ";
        end if;
    end process substraction;


end adder_substractor_8bit_rtl;