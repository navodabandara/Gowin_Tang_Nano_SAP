--Copyright (C)2014-2022 Gowin Semiconductor Corporation.
--All rights reserved.
--File Title: IP file
--GOWIN Version: V1.9.8.05
--Part Number: GW1NR-LV9QN88PC6/I5
--Device: GW1NR-9C
--Created Time: Sun Feb 12 01:16:57 2023

library IEEE;
use IEEE.std_logic_1164.all;

entity Gowin_SP_TM1637 is
    port (
        dout: out std_logic_vector(27 downto 0);
        clk: in std_logic;
        oce: in std_logic;
        ce: in std_logic;
        reset: in std_logic;
        wre: in std_logic;
        ad: in std_logic_vector(8 downto 0);
        din: in std_logic_vector(27 downto 0)
    );
end Gowin_SP_TM1637;

architecture Behavioral of Gowin_SP_TM1637 is

    signal sp_inst_0_dout_w: std_logic_vector(3 downto 0);
    signal gw_vcc: std_logic;
    signal gw_gnd: std_logic;
    signal sp_inst_0_BLKSEL_i: std_logic_vector(2 downto 0);
    signal sp_inst_0_AD_i: std_logic_vector(13 downto 0);
    signal sp_inst_0_DI_i: std_logic_vector(31 downto 0);
    signal sp_inst_0_DO_o: std_logic_vector(31 downto 0);

    --component declaration
    component SP
        generic (
            READ_MODE: in bit := '0';
            WRITE_MODE: in bit_vector := "00";
            BIT_WIDTH: in integer := 32;
            BLK_SEL: in bit_vector := "000";
            RESET_MODE: in string := "SYNC";
            INIT_RAM_00: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_01: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_02: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_03: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_04: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_05: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_06: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_07: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_08: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_09: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_0F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_10: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_11: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_12: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_13: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_14: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_15: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_16: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_17: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_18: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_19: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_1F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_20: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_21: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_22: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_23: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_24: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_25: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_26: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_27: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_28: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_29: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_2F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_30: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_31: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_32: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_33: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_34: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_35: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_36: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_37: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_38: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_39: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3A: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3B: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3C: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3D: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3E: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
            INIT_RAM_3F: in bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000"
        );
        port (
            DO: out std_logic_vector(31 downto 0);
            CLK: in std_logic;
            OCE: in std_logic;
            CE: in std_logic;
            RESET: in std_logic;
            WRE: in std_logic;
            BLKSEL: in std_logic_vector(2 downto 0);
            AD: in std_logic_vector(13 downto 0);
            DI: in std_logic_vector(31 downto 0)
        );
    end component;

begin
    gw_vcc <= '1';
    gw_gnd <= '0';

    sp_inst_0_BLKSEL_i <= gw_gnd & gw_gnd & gw_gnd;
    sp_inst_0_AD_i <= ad(8 downto 0) & gw_gnd & gw_vcc & gw_vcc & gw_vcc & gw_vcc;
    sp_inst_0_DI_i <= gw_gnd & gw_gnd & gw_gnd & gw_gnd & din(27 downto 0);
    dout(27 downto 0) <= sp_inst_0_DO_o(27 downto 0) ;
    sp_inst_0_dout_w(3 downto 0) <= sp_inst_0_DO_o(31 downto 28) ;

    sp_inst_0: SP
        generic map (
            READ_MODE => '0',
            WRITE_MODE => "00",
            BIT_WIDTH => 32,
            RESET_MODE => "SYNC",
            BLK_SEL => "000",
            INIT_RAM_00 => X"0E1FBF7E0BFFBF7E0B7FBF7E067FBF7E0F3FBF7E0DBFBF7E061FBF7E0FDFBF7E",
            INIT_RAM_01 => X"0B6C3F7E066C3F7E0F2C3F7E0DAC3F7E060C3F7E0FCC3F7E0F7FBF7E0FFFBF7E",
            INIT_RAM_02 => X"0F3B7F7E0DBB7F7E061B7F7E0FDB7F7E0F6C3F7E0FEC3F7E0E0C3F7E0BEC3F7E",
            INIT_RAM_03 => X"061E7F7E0FDE7F7E0F7B7F7E0FFB7F7E0E1B7F7E0BFB7F7E0B7B7F7E067B7F7E",
            INIT_RAM_04 => X"0F7E7F7E0FFE7F7E0E1E7F7E0BFE7F7E0B7E7F7E067E7F7E0F3E7F7E0DBE7F7E",
            INIT_RAM_05 => X"0E0CFF7E0BECFF7E0B6CFF7E066CFF7E0F2CFF7E0DACFF7E060CFF7E0FCCFF7E",
            INIT_RAM_06 => X"0B76FF7E0676FF7E0F36FF7E0DB6FF7E0616FF7E0FD6FF7E0F6CFF7E0FECFF7E",
            INIT_RAM_07 => X"0F37FF7E0DB7FF7E0617FF7E0FD7FF7E0F76FF7E0FF6FF7E0E16FF7E0BF6FF7E",
            INIT_RAM_08 => X"061C3F7E0FDC3F7E0F77FF7E0FF7FF7E0E17FF7E0BF7FF7E0B77FF7E0677FF7E",
            INIT_RAM_09 => X"0F7C3F7E0FFC3F7E0E1C3F7E0BFC3F7E0B7C3F7E067C3F7E0F3C3F7E0DBC3F7E",
            INIT_RAM_0A => X"0E1FFF7E0BFFFF7E0B7FFF7E067FFF7E0F3FFF7E0DBFFF7E061FFF7E0FDFFF7E",
            INIT_RAM_0B => X"0B7EFF7E067EFF7E0F3EFF7E0DBEFF7E061EFF7E0FDEFF7E0F7FFF7E0FFFFF7E",
            INIT_RAM_0C => X"0F3F987E0DBF987E061F987E0FDF987E0F7EFF7E0FFEFF7E0E1EFF7E0BFEFF7E",
            INIT_RAM_0D => X"060C187E0FCC187E0F7F987E0FFF987E0E1F987E0BFF987E0B7F987E067F987E",
            INIT_RAM_0E => X"0F6C187E0FEC187E0E0C187E0BEC187E0B6C187E066C187E0F2C187E0DAC187E",
            INIT_RAM_0F => X"0E1B587E0BFB587E0B7B587E067B587E0F3B587E0DBB587E061B587E0FDB587E",
            INIT_RAM_10 => X"0B7E587E067E587E0F3E587E0DBE587E061E587E0FDE587E0F7B587E0FFB587E",
            INIT_RAM_11 => X"0F2CD87E0DACD87E060CD87E0FCCD87E0F7E587E0FFE587E0E1E587E0BFE587E",
            INIT_RAM_12 => X"0616D87E0FD6D87E0F6CD87E0FECD87E0E0CD87E0BECD87E0B6CD87E066CD87E",
            INIT_RAM_13 => X"0F76D87E0FF6D87E0E16D87E0BF6D87E0B76D87E0676D87E0F36D87E0DB6D87E",
            INIT_RAM_14 => X"0E17D87E0BF7D87E0B77D87E0677D87E0F37D87E0DB7D87E0617D87E0FD7D87E",
            INIT_RAM_15 => X"0B7C187E067C187E0F3C187E0DBC187E061C187E0FDC187E0F77D87E0FF7D87E",
            INIT_RAM_16 => X"0F3FD87E0DBFD87E061FD87E0FDFD87E0F7C187E0FFC187E0E1C187E0BFC187E",
            INIT_RAM_17 => X"061ED87E0FDED87E0F7FD87E0FFFD87E0E1FD87E0BFFD87E0B7FD87E067FD87E",
            INIT_RAM_18 => X"0F7ED87E0FFED87E0E1ED87E0BFED87E0B7ED87E067ED87E0F3ED87E0DBED87E",
            INIT_RAM_19 => X"0E1FB6FE0BFFB6FE0B7FB6FE067FB6FE0F3FB6FE0DBFB6FE061FB6FE0FDFB6FE",
            INIT_RAM_1A => X"0B6C36FE066C36FE0F2C36FE0DAC36FE060C36FE0FCC36FE0F7FB6FE0FFFB6FE",
            INIT_RAM_1B => X"0F3B76FE0DBB76FE061B76FE0FDB76FE0F6C36FE0FEC36FE0E0C36FE0BEC36FE",
            INIT_RAM_1C => X"061E76FE0FDE76FE0F7B76FE0FFB76FE0E1B76FE0BFB76FE0B7B76FE067B76FE",
            INIT_RAM_1D => X"0F7E76FE0FFE76FE0E1E76FE0BFE76FE0B7E76FE067E76FE0F3E76FE0DBE76FE",
            INIT_RAM_1E => X"0E0CF6FE0BECF6FE0B6CF6FE066CF6FE0F2CF6FE0DACF6FE060CF6FE0FCCF6FE",
            INIT_RAM_1F => X"0B76F6FE0676F6FE0F36F6FE0DB6F6FE0616F6FE0FD6F6FE0F6CF6FE0FECF6FE",
            INIT_RAM_20 => X"061B58010DBB58010F3B5801067B58010B7B58010BFB58010E1B58010FFB5801",
            INIT_RAM_21 => X"0F2C1801066C18010B6C18010BEC18010E0C18010FEC18010F6C18010FDB5801",
            INIT_RAM_22 => X"0B7F98010BFF98010E1F98010FFF98010F7F98010FCC1801060C18010DAC1801",
            INIT_RAM_23 => X"0E1EFF010FFEFF010F7EFF010FDF9801061F98010DBF98010F3F9801067F9801",
            INIT_RAM_24 => X"0F7FFF010FDEFF01061EFF010DBEFF010F3EFF01067EFF010B7EFF010BFEFF01",
            INIT_RAM_25 => X"061FFF010DBFFF010F3FFF01067FFF010B7FFF010BFFFF010E1FFF010FFFFF01",
            INIT_RAM_26 => X"0F3C3F01067C3F010B7C3F010BFC3F010E1C3F010FFC3F010F7C3F010FDFFF01",
            INIT_RAM_27 => X"0B77FF010BF7FF010E17FF010FF7FF010F77FF010FDC3F01061C3F010DBC3F01",
            INIT_RAM_28 => X"0E16FF010FF6FF010F76FF010FD7FF010617FF010DB7FF010F37FF010677FF01",
            INIT_RAM_29 => X"0F6CFF010FD6FF010616FF010DB6FF010F36FF010676FF010B76FF010BF6FF01",
            INIT_RAM_2A => X"060CFF010DACFF010F2CFF01066CFF010B6CFF010BECFF010E0CFF010FECFF01",
            INIT_RAM_2B => X"0F3E7F01067E7F010B7E7F010BFE7F010E1E7F010FFE7F010F7E7F010FCCFF01",
            INIT_RAM_2C => X"0B7B7F010BFB7F010E1B7F010FFB7F010F7B7F010FDE7F01061E7F010DBE7F01",
            INIT_RAM_2D => X"0E0C3F010FEC3F010F6C3F010FDB7F01061B7F010DBB7F010F3B7F01067B7F01",
            INIT_RAM_2E => X"0F7FBF010FCC3F01060C3F010DAC3F010F2C3F01066C3F010B6C3F010BEC3F01",
            INIT_RAM_2F => X"061FBF010DBFBF010F3FBF01067FBF010B7FBF010BFFBF010E1FBF010FFFBF01",
            INIT_RAM_30 => X"0E1FBF7E0BFFBF7E0B7FBF7E067FBF7E0F3FBF7E0DBFBF7E061FBF7E0FDFBF7E",
            INIT_RAM_31 => X"0B6C3F7E066C3F7E0F2C3F7E0DAC3F7E060C3F7E0FCC3F7E0F7FBF7E0FFFBF7E",
            INIT_RAM_32 => X"0F3B7F7E0DBB7F7E061B7F7E0FDB7F7E0F6C3F7E0FEC3F7E0E0C3F7E0BEC3F7E",
            INIT_RAM_33 => X"061E7F7E0FDE7F7E0F7B7F7E0FFB7F7E0E1B7F7E0BFB7F7E0B7B7F7E067B7F7E",
            INIT_RAM_34 => X"0F7E7F7E0FFE7F7E0E1E7F7E0BFE7F7E0B7E7F7E067E7F7E0F3E7F7E0DBE7F7E",
            INIT_RAM_35 => X"0E0CFF7E0BECFF7E0B6CFF7E066CFF7E0F2CFF7E0DACFF7E060CFF7E0FCCFF7E",
            INIT_RAM_36 => X"0B76FF7E0676FF7E0F36FF7E0DB6FF7E0616FF7E0FD6FF7E0F6CFF7E0FECFF7E",
            INIT_RAM_37 => X"0F37FF7E0DB7FF7E0617FF7E0FD7FF7E0F76FF7E0FF6FF7E0E16FF7E0BF6FF7E",
            INIT_RAM_38 => X"061C3F7E0FDC3F7E0F77FF7E0FF7FF7E0E17FF7E0BF7FF7E0B77FF7E0677FF7E",
            INIT_RAM_39 => X"0F7C3F7E0FFC3F7E0E1C3F7E0BFC3F7E0B7C3F7E067C3F7E0F3C3F7E0DBC3F7E",
            INIT_RAM_3A => X"0E1FFF7E0BFFFF7E0B7FFF7E067FFF7E0F3FFF7E0DBFFF7E061FFF7E0FDFFF7E",
            INIT_RAM_3B => X"0B7EFF7E067EFF7E0F3EFF7E0DBEFF7E061EFF7E0FDEFF7E0F7FFF7E0FFFFF7E",
            INIT_RAM_3C => X"0F3F987E0DBF987E061F987E0FDF987E0F7EFF7E0FFEFF7E0E1EFF7E0BFEFF7E",
            INIT_RAM_3D => X"060C187E0FCC187E0F7F987E0FFF987E0E1F987E0BFF987E0B7F987E067F987E",
            INIT_RAM_3E => X"0F6C187E0FEC187E0E0C187E0BEC187E0B6C187E066C187E0F2C187E0DAC187E",
            INIT_RAM_3F => X"0E1B587E0BFB587E0B7B587E067B587E0F3B587E0DBB587E061B587E0FDB587E"
        )
        port map (
            DO => sp_inst_0_DO_o,
            CLK => clk,
            OCE => oce,
            CE => ce,
            RESET => reset,
            WRE => wre,
            BLKSEL => sp_inst_0_BLKSEL_i,
            AD => sp_inst_0_AD_i,
            DI => sp_inst_0_DI_i
        );

end Behavioral; --Gowin_SP_TM1637