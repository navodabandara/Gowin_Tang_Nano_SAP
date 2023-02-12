library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tm1637_standalone is

	 Generic (divider  : integer := 4000); -- the divider must be set so that the result is a frequency of 20 kHz
    Port (    clk25 	: in  std_logic;
                signedEnable : in std_logic;
				data 	: std_logic_vector(7 downto 0);
			    scl   : out std_logic;
			    sda   : out std_logic
          );
			 
end tm1637_standalone;

architecture Behavioral of tm1637_standalone is

------------------------------------------------------------------------------------------------------------------------------------

signal clkdiv : integer range 0 to divider-1 := 0;
signal ce: std_logic := '0';
signal sm_counter : integer := 0;
signal clk_divided : std_logic := '0';


signal lut_clock :  std_logic:= '0';	

-- DAS HIER RAUS !!!
signal display : integer;


signal dout_lut : std_logic_vector(27 downto 0);

begin
 
 process (all) begin
 if rising_edge(clk25) then
  if (clkdiv < divider-1) then   
    clkdiv <= clkdiv + 1;
    ce <= '0';
   else
    clkdiv <= 0;
    ce <= '1';
   end if;
  end if;
 end process;


  process(all)
  begin

  if rising_edge(clk25) then
   if (ce='1') then 
	case sm_counter is
     when 0 => scl <= '1'; sda <= '1'; lut_clock <= '1';
     when 1 => scl <= '1'; sda <= '1'; lut_clock<= '0'; -- start condition
	  when 2 =>             sda <= '0';
	  when 3 => scl <= '0'; -- command 1
	  when 4 => scl <= '1';
	  when 5 => scl <= '0'; sda <= '0';
	  when 6 => scl <= '1'; 
	  when 7 => scl <= '0'; 
	  when 8 => scl <= '1';
	  when 9 => scl <= '0'; 
	  when 10 => scl <= '1'; 
	  when 11 => scl <= '0'; 
	  when 12 => scl <= '1'; 
	  when 13 => scl <= '0'; 
	  when 14 => scl <= '1'; 
	  when 15 => scl <= '0';  sda <= '1';
	  when 16 => scl <= '1'; 
	  when 17 => scl <= '0';  sda <= '0';
	  when 18 => scl <= '1'; 
	  when 19 => scl <= '0'; sda <= '0';
	  when 20 => scl <= '1';
	  when 21 => scl <= '0'; sda <= '0'; -- stop condition
	  when 22 => scl <= '1';
     when 23 =>             sda <= '1'; -- start condition
 	  when 24 => scl <= '1'; sda <= '0'; -- command 2
	  when 25 => scl <= '0'; sda <= '0';
	  when 26 => scl <= '1'; 
	  when 27 => scl <= '0'; 
	  when 28 => scl <= '1'; 
	  when 29 => scl <= '0'; sda <= '0';
	  when 30 => scl <= '1'; sda <= '0';
	  when 31 => scl <= '0'; sda <= '0';
	  when 32 => scl <= '1'; sda <= '0';
	  when 33 => scl <= '0'; sda <= '0'; 
	  when 34 => scl <= '1'; sda <= '0';
	  when 35 => scl <= '0'; sda <= '0';
	  when 36 => scl <= '1'; sda <= '0';
	  when 37 => scl <= '0'; sda <= '1';
	  when 38 => scl <= '1'; sda <= '1';
	  when 39 => scl <= '0'; sda <= '1';
	  when 40 => scl <= '1'; sda <= '1';
	  when 41 => scl <= '0'; sda <= '0'; 
	  when 42 => scl <= '1'; 

-- Daten 1 bis 58
	  
	  when 43 => scl <= '0'; sda <= dout_lut(6);--(display, 4, 0, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 44 => scl <= '1'; 
	  when 45 => scl <= '0'; sda <= dout_lut(5);  --(display, 4, 1, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 46 => scl <= '1'; 
	  when 47 => scl <= '0'; sda <= dout_lut(4); --(display, 4, 2, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 48 => scl <= '1';
	  when 49 => scl <= '0'; sda <= dout_lut(3); --(display, 4, 3, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 50 => scl <= '1'; 
	  when 51 => scl <= '0'; sda <= dout_lut(2);--(display, 4, 4, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 52 => scl <= '1'; 
	  when 53 => scl <= '0'; sda <= dout_lut(1); --(display, 4, 5, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 54 => scl <= '1';
	  when 55 => scl <= '0'; sda <= dout_lut(0); --(display, 4, 6, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 56 => scl <= '1';
	  when 57 => scl <= '0'; sda <= '0'; --(display, 4, 7, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 58 => scl <= '1'; 

-- Daten 1 bis hier

	  when 59 => scl <= '0'; sda <= '0';
	  when 60 => scl <= '1';  
	  
-- Daten 2 61 bis 76	  

	  when 61 => scl <= '0'; sda <= dout_lut(13); --(display, 3, 0, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 62 => scl <= '1'; 
	  when 63 => scl <= '0'; sda <= dout_lut(12); --(display, 3, 1, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 64 => scl <= '1';
	  when 65 => scl <= '0'; sda <= dout_lut(11); --(display, 3, 2, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 66 => scl <= '1';
	  when 67 => scl <= '0'; sda <= dout_lut(10); --(display, 3, 3, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 68 => scl <= '1';
	  when 69 => scl <= '0'; sda <= dout_lut(9);--(display, 3, 4, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 70 => scl <= '1';
	  when 71 => scl <= '0'; sda <= dout_lut(8); --(display, 3, 5, reg_digit0, reg_digit1, reg_digit2, reg_digit3);  
	  when 72 => scl <= '1';
	  when 73 => scl <= '0'; sda <= dout_lut(7); --(display, 3, 6, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 74 => scl <= '1';
	  when 75 => scl <= '0'; sda <= '0'; --(display, 3, 7, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 76 => scl <= '1';

-- Daten 2 bis hier
	  
	  when 77 => scl <= '0'; sda <= '0';
	  when 78 => scl <= '1'; 

-- Daten 3 79 bis 94	  
	  when 79 => scl <= '0'; sda <= dout_lut(20); --(display, 2, 0, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 80 => scl <= '1';
	  when 81 => scl <= '0'; sda <= dout_lut(19); --(display, 2, 1, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 82 => scl <= '1'; 
	  when 83 => scl <= '0'; sda <= dout_lut(18); --(display, 2, 2, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 84 => scl <= '1';
	  when 85 => scl <= '0'; sda <= dout_lut(17); --(display, 2, 3, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 86 => scl <= '1';
	  when 87 => scl <= '0'; sda <= dout_lut(16); --(display, 2, 4, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 88 => scl <= '1';
	  when 89 => scl <= '0'; sda <= dout_lut(15); --(display, 2, 5, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 90 => scl <= '1';
	  when 91 => scl <= '0'; sda <= dout_lut(14); --(display, 2, 6, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 92 => scl <= '1';
	  when 93 => scl <= '0'; sda <= '0'; --(display, 2, 7, reg_digit0, reg_digit1, reg_digit2, reg_digit3); 
	  when 94 => scl <= '1';
-- Daten 3 bis hier
	  
	  when 95 => scl <= '0'; sda <= '0'; 
	  when 96 => scl <= '1';

-- Daten 4 97 bis 112

	  when 97 => scl <= '0'; sda <= dout_lut(27); --(display, 1, 0, reg_digit0, reg_digit1, reg_digit2, reg_digit3);
	  when 98 => scl <= '1';
	  when 99 => scl <= '0'; sda <= dout_lut(26); --(display, 1, 1, reg_digit0, reg_digit1, reg_digit2, reg_digit3);
	  when 100 => scl <= '1';  
	  when 101 => scl <= '0'; sda <= dout_lut(25); --(display, 1, 2, reg_digit0, reg_digit1, reg_digit2, reg_digit3);
	  when 102 => scl <= '1';
	  when 103 => scl <= '0'; sda <= dout_lut(24); --(display, 1, 3, reg_digit0, reg_digit1, reg_digit2, reg_digit3);
	  when 104 => scl <= '1';
	  when 105 => scl <= '0'; sda <= dout_lut(23); --(display, 1, 4, reg_digit0, reg_digit1, reg_digit2, reg_digit3);
	  when 106 => scl <= '1';
	  when 107 => scl <= '0'; sda <= dout_lut(22); --(display, 1, 5, reg_digit0, reg_digit1, reg_digit2, reg_digit3);
	  when 108 => scl <= '1';
	  when 109 => scl <= '0'; sda <= dout_lut(21); --(display, 1, 6, reg_digit0, reg_digit1, reg_digit2, reg_digit3);
	  when 110 => scl <= '1';
	  when 111 => scl <= '0'; sda <= '0'; --(display, 1, 7, reg_digit0, reg_digit1, reg_digit2, reg_digit3);
	  when 112 => scl <= '1';
	  
-- Daten 4 bis hier
	  
	  when 113 => scl <= '0'; sda <= '0'; 
	  when 114 => scl <= '1'; 
	  when 115 => scl <= '0'; sda <= '0'; 
	  when 116 => scl <= '1';
	  when 117 => scl <= '1'; sda <= '1'; -- Command 3
	  when 118 => scl <= '1'; sda <= '0'; 
	  when 119 => scl <= '0'; 
	  when 120 => scl <= '1'; 
	  when 121 => scl <= '0'; 
	  when 122 => scl <= '1'; 
	  when 123 => scl <= '0'; sda <= '1'; 
	  when 124 => scl <= '1'; 
	  when 125 => scl <= '0'; 
	  when 126 => scl <= '1'; 
	  when 127 => scl <= '0'; sda <= '0'; 
	  when 128 => scl <= '1'; 
	  when 129 => scl <= '0'; 
	  when 130 => scl <= '1'; 
	  when 131 => scl <= '0'; 
	  when 132 => scl <= '1'; 
	  when 133 => scl <= '0'; sda <= '1'; 
	  when 134 => scl <= '1'; 
	  when 135 => scl <= '0'; sda <= '0'; 
	  when 136 => scl <= '1'; sda <= '0';
      when 137 => scl <= '1'; 
	  when 138 => scl <= '0'; sda <= '0';
	  when 139 => scl <= '1'; sda <= '0';
	  when 140 => scl <= '1'; sda <= '1';
	  when 141 => scl <= '1'; sda <= '1';
	  when 142 => scl <= '1'; sda <= '1';
	  when others => null;
   end case;
	
	if sm_counter = 1000 then --250000 2sec
		sm_counter <= 0;
	else
		sm_counter <= sm_counter + 1;
	end if;	
   
  end if;
  end if;	
 end process;
 
    SEGMENT_LUT : ENTITY work.Gowin_SP_TM1637 PORT MAP(
        dout => dout_lut,
        clk  => lut_clock,
        oce  => '0',
        ce  => '1',
        reset  => '0',
        wre  => '0',
        ad(8)  => signedEnable,
        ad(7 downto 0) => data(7 downto 0),
        din  => "0000000000000000000000000000" 
    );

 
end Behavioral;