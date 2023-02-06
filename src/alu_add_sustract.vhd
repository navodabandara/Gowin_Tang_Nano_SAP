library ieee;
use ieee.std_logic_1164.all;
--use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;
--this block is asyncronous

entity adder_substractor_8bit is
    port(
        i_reg_a : in std_logic_vector (7 downto 0);
        i_reg_b : in std_logic_vector (7 downto 0);
        i_out   : in std_logic;
        i_sub   : in std_logic;
        o_carry : out std_logic;
        o_result: out std_logic_vector (7 downto 0);
        o_zero_flag: out std_logic
    );
end adder_substractor_8bit;

architecture adder_substractor_8bit_rtl of adder_substractor_8bit is

signal temp: unsigned(8 downto 0);
begin

    sum : process (i_reg_a, i_reg_b, i_out, i_sub, o_carry, o_result, temp)
    begin
        if (i_out = '1' and i_sub = '0')  then
            temp <=  '0' & unsigned(i_reg_a) + unsigned(i_reg_b);
            o_result <= std_logic_vector(temp(7 downto 0));
            o_carry <= temp(8);
            o_zero_flag <= '1' when temp(7 downto 0)=0 else '0';
        elsif (i_out = '1' and i_sub = '1') then
             temp <=  '0' & unsigned(i_reg_a) - unsigned(i_reg_b);
             o_result <= std_logic_vector(temp(7 downto 0));
             o_carry <= temp(8);
             o_zero_flag <= '1' when temp(7 downto 0)=0 else '0';
        else
            o_zero_flag <= '0'; --NOTE: Flag is not output when out or sub is high
            temp <= "ZZZZZZZZZ";
            o_result <= "ZZZZZZZZ";
            o_carry <= '0';
        end if;
    end process sum;

end adder_substractor_8bit_rtl;