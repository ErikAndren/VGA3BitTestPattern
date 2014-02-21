library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.Types.all;
use work.VgaPack.all;

entity VGAVHDL is 
	port (
	Clk      : in bit1;
	--
	Red : in bit1;
	Green : in bit1;
	Blue : in bit1;
	--
	XCord : out word(10-1 downto 0);
	YCord : out word(10-1 downto 0);
	--
	RedOut   : out bit1;
	GreenOut : out bit1;
	BlueOut  : out bit1;
	HSync    : out bit1;
	VSync    : out bit1
	);
end entity;

architecture rtl of VGAVHDL is		
	signal hCount : word(10-1 downto 0);
	signal vCount : word(10-1 downto 0);
	signal data : word(3-1 downto 0);
	signal h_dat : word(3-1 downto 0);
	signal v_dat : word(3-1 downto 0);
	signal hCount_ov : bit1;
	signal vCount_ov : bit1;
	
	signal dat_act : bit1;
begin
	
	hcount_ov <= '1' when hcount = hpixel_end else '0';
	HCnt : process (Clk)
	begin
		if rising_edge(Clk) then
			if (hcount_ov = '1') then
				hcount <= (others => '0');
			else
				hcount <= hcount + 1;
			end if;
		end if;
	end process;
	
	vcount_ov <= '1' when vcount = vline_end else '0';
	VCnt : process (Clk)
	begin
		if rising_edge(Clk) then
			if (hcount_ov = '1') then
				if (vcount_ov = '1') then
						vcount <= (others => '0');
				else
					vcount <= vcount + 1;
				end if;
			end if;
		end if;
	end process;
	
	XCord <= hcount;
	YCord <= vcount;
	
	dat_act <= '1' when ((hcount >= hdat_begin) and (hcount < hdat_end)) and ((vcount >= vdat_begin) and (vcount < vdat_end)) else '0';
	Hsync <= '1' when hcount > hsync_end else '0';
	Vsync <= '1' when vcount > vsync_end else '0';
	--
	RedOut <= '0' when dat_act = '0' else Red;
	GreenOut <= '0' when dat_act = '0' else Green;
	BlueOut <= '0' when dat_act = '0' else Blue;

end architecture rtl;