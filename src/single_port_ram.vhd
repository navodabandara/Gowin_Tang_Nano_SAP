library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_RAM is
    port(
        o_data_out : out std_logic_vector (7 downto 0);
        i_data_in : in std_logic_vector (7 downto 0);
        i_clk : in std_logic;
        i_address : in std_logic_vector (3 downto 0);
        i_load : in std_logic;
        i_dump : in std_logic
    );
end single_port_RAM;

architecture single_port_RAM_rtl of single_port_RAM is
    signal r_data_out_direct : std_logic_vector (7 downto 0);
begin
    RAM_A : entity work.Gowin_SP port map (
        dout => r_data_out_direct,
        clk => i_clk,
        oce => '0',
        ce => '1',
        reset => '0',
        wre => i_load,
        ad => i_address,
        din => i_data_in
    );

    o_data_out <= r_data_out_direct when (i_dump = '1') else "ZZZZZZZZ";

end single_port_RAM_rtl;