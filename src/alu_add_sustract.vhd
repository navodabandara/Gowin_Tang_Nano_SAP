library ieee;
USE ieee.std_logic_1164.ALL;

entity full_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           sum : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end full_adder;

architecture behavioral of full_adder is
begin
  sum <= a xor b xor cin;
  cout <= (a and b) or (cin and (a xor b));
end behavioral;

library ieee;
USE ieee.std_logic_1164.ALL;

entity eight_bit_adder is
    Port ( a : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
           cin : in  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (7 downto 0);
           cout : out  STD_LOGIC);
end eight_bit_adder;

library ieee;
USE ieee.std_logic_1164.ALL;

architecture behavioral of eight_bit_adder is
component full_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           sum : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end component;

signal temp_cout, temp_sum : STD_LOGIC_VECTOR (7 downto 0);

begin
  full_adder_0 : full_adder
    port map (a(0), b(0), cin, temp_sum(0), temp_cout(0));

  full_adder_1 : full_adder
    port map (a(1), b(1), temp_cout(0), temp_sum(1), temp_cout(1));

  full_adder_2 : full_adder
    port map (a(2), b(2), temp_cout(1), temp_sum(2), temp_cout(2));

  full_adder_3 : full_adder
    port map (a(3), b(3), temp_cout(2), temp_sum(3), temp_cout(3));

  full_adder_4 : full_adder
    port map (a(4), b(4), temp_cout(3), temp_sum(4), temp_cout(4));

  full_adder_5 : full_adder
    port map (a(5), b(5), temp_cout(4), temp_sum(5), temp_cout(5));

  full_adder_6 : full_adder
    port map (a(6), b(6), temp_cout(5), temp_sum(6), temp_cout(6));

  full_adder_7 : full_adder
    port map (a(7), b(7), temp_cout(6), temp_sum(7), cout);

  sum <= temp_sum;
end behavioral;

library ieee;
USE ieee.std_logic_1164.ALL;

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

signal b_in, b_to_adder, temp_out: std_logic_vector(7 downto 0) := "00000000";
signal w_carry_out, w_carry_in: std_logic;

begin

    b_to_adder <= i_reg_b when i_sub='0' else (i_reg_b XOR "11111111");
    w_carry_in <= i_sub;

    ADDER : ENTITY work.eight_bit_adder PORT MAP (
            a => i_reg_a,
            b  => b_to_adder,
            cin  => w_carry_in,
            sum  => temp_out,
            cout => w_carry_out
        );

  
    sum : process (i_out, o_carry, o_result, temp_out, w_carry_out, o_zero_flag)
    begin
        if (i_out = '1')  then
            o_result <= temp_out;
            o_zero_flag <= '1' when temp_out(7 downto 0)="00000000" else '0';
            o_carry <= w_carry_out;
        else
            o_zero_flag <= '0'; --NOTE: Flag is not output when out or sub is high
            o_result <= "ZZZZZZZZ";
            o_carry <= '0';
        end if;
    end process sum;

end adder_substractor_8bit_rtl;