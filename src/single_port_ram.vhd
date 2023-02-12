LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY single_port_RAM IS
    PORT (
        o_data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        i_data_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        i_clk : IN STD_LOGIC;
        i_address : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        i_load : IN STD_LOGIC;
        i_dump : IN STD_LOGIC
    );
END single_port_RAM;

ARCHITECTURE single_port_RAM_rtl OF single_port_RAM IS
    SIGNAL r_data_out_direct : STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN
    RAM_A : ENTITY work.Gowin_SP PORT MAP (
        dout => r_data_out_direct,
        clk => NOT i_clk,
        oce => '0',
        ce => '1',
        reset => '0',
        wre => i_load,
        ad => i_address,
        din => i_data_in
        );

    o_data_out <= r_data_out_direct WHEN (i_dump = '1') ELSE
        "ZZZZZZZZ";

END single_port_RAM_rtl;