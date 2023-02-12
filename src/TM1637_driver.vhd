--Based on the work of https://github.com/mongoq/tm1637-fpga
--Changed the output from 16 bit hex to 8 bit decimal representation
--Using Gowin SP core to store a LUT with the segment configuration for every 8 bit number signed and unsigned
--Removed the tri state values on SDA on start/stop sequences and made minor adjustments to the timing
--Changed divider to work with 3KHz
--Removed ready flag

--TODO: Add an input to control brightness
--TODO: Try to get the SDA and SCLK transitions on a memory core and perhaps reduce LUT utilization...
--by using shift registers?

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tm1637_standalone IS

	GENERIC (divider : INTEGER := 4000); -- the divider must be set so that the result is a frequency of 3 kHz
	PORT (
		clk25 : IN STD_LOGIC;
		signedEnable : IN STD_LOGIC;
		data : STD_LOGIC_VECTOR(7 DOWNTO 0);
		scl : OUT STD_LOGIC;
		sda : OUT STD_LOGIC
	);

END tm1637_standalone;

ARCHITECTURE Behavioral OF tm1637_standalone IS
	SIGNAL clkdiv : INTEGER RANGE 0 TO divider - 1 := 0;
	SIGNAL ce : STD_LOGIC := '0';
	SIGNAL sm_counter : INTEGER := 0;
	SIGNAL clk_divided : STD_LOGIC := '0';
	SIGNAL lut_clock : STD_LOGIC := '0';
	SIGNAL dout_lut : STD_LOGIC_VECTOR(27 DOWNTO 0);
	------------------------------------------------------------------------------------------------------------------------------------
BEGIN
	SEGMENT_LUT : ENTITY work.Gowin_SP_TM1637 PORT MAP(
		dout => dout_lut,
		clk => lut_clock,
		oce => '0',
		ce => '1',
		reset => '0',
		wre => '0',
		ad(8) => signedEnable,
		ad(7 DOWNTO 0) => data(7 DOWNTO 0),
		din => "0000000000000000000000000000"
		);
	------------------------------------------------------------------------------------------------------------------------------------
	PROCESS (ALL) BEGIN
		IF rising_edge(clk25) THEN
			IF (clkdiv < divider - 1) THEN
				clkdiv <= clkdiv + 1;
				ce <= '0';
			ELSE
				clkdiv <= 0;
				ce <= '1';
			END IF;
		END IF;
	END PROCESS;
	------------------------------------------------------------------------------------------------------------------------------------
	PROCESS (ALL)
	BEGIN
		IF rising_edge(clk25) THEN
			IF (ce = '1') THEN
				CASE sm_counter IS
					WHEN 0 => scl <= '1';
						sda <= '1';
						lut_clock <= '1';
					WHEN 1 => scl <= '1';
						sda <= '1';
						lut_clock <= '0'; -- start condition
					WHEN 2 => sda <= '0';
					WHEN 3 => scl <= '0'; -- command 1
					WHEN 4 => scl <= '1';
					WHEN 5 => scl <= '0';
						sda <= '0';
					WHEN 6 => scl <= '1';
					WHEN 7 => scl <= '0';
					WHEN 8 => scl <= '1';
					WHEN 9 => scl <= '0';
					WHEN 10 => scl <= '1';
					WHEN 11 => scl <= '0';
					WHEN 12 => scl <= '1';
					WHEN 13 => scl <= '0';
					WHEN 14 => scl <= '1';
					WHEN 15 => scl <= '0';
						sda <= '1';
					WHEN 16 => scl <= '1';
					WHEN 17 => scl <= '0';
						sda <= '0';
					WHEN 18 => scl <= '1';
					WHEN 19 => scl <= '0';
						sda <= '0';
					WHEN 20 => scl <= '1';
					WHEN 21 => scl <= '0';
						sda <= '0'; -- stop condition
					WHEN 22 => scl <= '1';
					WHEN 23 => sda <= '1'; -- start condition
					WHEN 24 => scl <= '1';
						sda <= '0'; -- command 2
					WHEN 25 => scl <= '0';
						sda <= '0';
					WHEN 26 => scl <= '1';
					WHEN 27 => scl <= '0';
					WHEN 28 => scl <= '1';
					WHEN 29 => scl <= '0';
						sda <= '0';
					WHEN 30 => scl <= '1';
						sda <= '0';
					WHEN 31 => scl <= '0';
						sda <= '0';
					WHEN 32 => scl <= '1';
						sda <= '0';
					WHEN 33 => scl <= '0';
						sda <= '0';
					WHEN 34 => scl <= '1';
						sda <= '0';
					WHEN 35 => scl <= '0';
						sda <= '0';
					WHEN 36 => scl <= '1';
						sda <= '0';
					WHEN 37 => scl <= '0';
						sda <= '1';
					WHEN 38 => scl <= '1';
						sda <= '1';
					WHEN 39 => scl <= '0';
						sda <= '1';
					WHEN 40 => scl <= '1';
						sda <= '1';
					WHEN 41 => scl <= '0';
						sda <= '0';
					WHEN 42 => scl <= '1';

						-- First digit (From Left)
					WHEN 43 => scl <= '0';
						sda <= dout_lut(6);
					WHEN 44 => scl <= '1';
					WHEN 45 => scl <= '0';
						sda <= dout_lut(5);
					WHEN 46 => scl <= '1';
					WHEN 47 => scl <= '0';
						sda <= dout_lut(4);
					WHEN 48 => scl <= '1';
					WHEN 49 => scl <= '0';
						sda <= dout_lut(3);
					WHEN 50 => scl <= '1';
					WHEN 51 => scl <= '0';
						sda <= dout_lut(2);
					WHEN 52 => scl <= '1';
					WHEN 53 => scl <= '0';
						sda <= dout_lut(1);
					WHEN 54 => scl <= '1';
					WHEN 55 => scl <= '0';
						sda <= dout_lut(0);
					WHEN 56 => scl <= '1';
					WHEN 57 => scl <= '0';
						sda <= '0';
					WHEN 58 => scl <= '1';

						-- Stop sequence
					WHEN 59 => scl <= '0';
						sda <= '0';
					WHEN 60 => scl <= '1';

						-- Second digit  
					WHEN 61 => scl <= '0';
						sda <= dout_lut(13);
					WHEN 62 => scl <= '1';
					WHEN 63 => scl <= '0';
						sda <= dout_lut(12);
					WHEN 64 => scl <= '1';
					WHEN 65 => scl <= '0';
						sda <= dout_lut(11);
					WHEN 66 => scl <= '1';
					WHEN 67 => scl <= '0';
						sda <= dout_lut(10);
					WHEN 68 => scl <= '1';
					WHEN 69 => scl <= '0';
						sda <= dout_lut(9);
					WHEN 70 => scl <= '1';
					WHEN 71 => scl <= '0';
						sda <= dout_lut(8);
					WHEN 72 => scl <= '1';
					WHEN 73 => scl <= '0';
						sda <= dout_lut(7);
					WHEN 74 => scl <= '1';
					WHEN 75 => scl <= '0';
						sda <= '0';
					WHEN 76 => scl <= '1';

						-- Stop sequence
					WHEN 77 => scl <= '0';
						sda <= '0';
					WHEN 78 => scl <= '1';

						-- Third digit	  
					WHEN 79 => scl <= '0';
						sda <= dout_lut(20);
					WHEN 80 => scl <= '1';
					WHEN 81 => scl <= '0';
						sda <= dout_lut(19);
					WHEN 82 => scl <= '1';
					WHEN 83 => scl <= '0';
						sda <= dout_lut(18);
					WHEN 84 => scl <= '1';
					WHEN 85 => scl <= '0';
						sda <= dout_lut(17);
					WHEN 86 => scl <= '1';
					WHEN 87 => scl <= '0';
						sda <= dout_lut(16);
					WHEN 88 => scl <= '1';
					WHEN 89 => scl <= '0';
						sda <= dout_lut(15);
					WHEN 90 => scl <= '1';
					WHEN 91 => scl <= '0';
						sda <= dout_lut(14);
					WHEN 92 => scl <= '1';
					WHEN 93 => scl <= '0';
						sda <= '0';
					WHEN 94 => scl <= '1';

						-- Stop sequence
					WHEN 95 => scl <= '0';
						sda <= '0';
					WHEN 96 => scl <= '1';

						-- Digit Four
					WHEN 97 => scl <= '0';
						sda <= dout_lut(27);
					WHEN 98 => scl <= '1';
					WHEN 99 => scl <= '0';
						sda <= dout_lut(26);
					WHEN 100 => scl <= '1';
					WHEN 101 => scl <= '0';
						sda <= dout_lut(25);
					WHEN 102 => scl <= '1';
					WHEN 103 => scl <= '0';
						sda <= dout_lut(24);
					WHEN 104 => scl <= '1';
					WHEN 105 => scl <= '0';
						sda <= dout_lut(23);
					WHEN 106 => scl <= '1';
					WHEN 107 => scl <= '0';
						sda <= dout_lut(22);
					WHEN 108 => scl <= '1';
					WHEN 109 => scl <= '0';
						sda <= dout_lut(21);
					WHEN 110 => scl <= '1';
					WHEN 111 => scl <= '0';
						sda <= '0';
					WHEN 112 => scl <= '1';

						-- Brightness setting command
					WHEN 113 => scl <= '0';
						sda <= '0';
					WHEN 114 => scl <= '1';
					WHEN 115 => scl <= '0';
						sda <= '0';
					WHEN 116 => scl <= '1';
					WHEN 117 => scl <= '1';
						sda <= '1'; -- Command 3
					WHEN 118 => scl <= '1';
						sda <= '0';
					WHEN 119 => scl <= '0';
					WHEN 120 => scl <= '1';
					WHEN 121 => scl <= '0';
					WHEN 122 => scl <= '1';
					WHEN 123 => scl <= '0';
						sda <= '1';
					WHEN 124 => scl <= '1';
					WHEN 125 => scl <= '0';
					WHEN 126 => scl <= '1';
					WHEN 127 => scl <= '0';
						sda <= '0';
					WHEN 128 => scl <= '1';
					WHEN 129 => scl <= '0';
					WHEN 130 => scl <= '1';
					WHEN 131 => scl <= '0';
					WHEN 132 => scl <= '1';
					WHEN 133 => scl <= '0';
						sda <= '1';
					WHEN 134 => scl <= '1';
					WHEN 135 => scl <= '0';
						sda <= '0';
					WHEN 136 => scl <= '1';
						sda <= '0';
					WHEN 137 => scl <= '1';
					WHEN 138 => scl <= '0';
						sda <= '0';
					WHEN 139 => scl <= '1';
						sda <= '0';
					WHEN 140 => scl <= '1';
						sda <= '1';
					WHEN 141 => scl <= '1';
						sda <= '1';
					WHEN 142 => scl <= '1';
						sda <= '1';
					WHEN OTHERS => NULL;
				END CASE;

				IF sm_counter = 1000 THEN
					sm_counter <= 0;
				ELSE
					sm_counter <= sm_counter + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;