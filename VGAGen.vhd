library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.Types.all;
use work.VgaPack.all;

entity VGAGen is
	generic (
		ClkDiv : boolean
	);
	port (
	RstN     : in bit1;
	Clk      : in bit1;
	--
	RedOut   : out word(3-1 downto 0);
	GreenOut : out word(3-1 downto 0);
	BlueOut  : out word(3-1 downto 0);
	HSync    : out bit1;
	VSync    : out bit1;
	--
	InView   : out bit1
	);
end entity;

architecture rtl of VGAGen is		
	signal hCount : word(10-1 downto 0);
	signal vCount : word(10-1 downto 0);
	signal data : word(3-1 downto 0);
	signal h_dat : word(3-1 downto 0);
	signal v_dat : word(3-1 downto 0);
	signal hCount_ov : bit1;
	signal vCount_ov : bit1;
	--
	signal dat_act : bit1;
	signal DivClk : bit1;
	--
	signal Cnt_D : word(9-1 downto 0);

begin
	HasClkDiv : if ClkDiv generate
		ClkDivProc : process (RstN, Clk)
		begin
			if RstN = '0' then
				DivClk <= '0';
			elsif rising_edge(Clk) then
				DivClk <= not DivClk;
			end if;
		end process;
	end generate;
	
	NoClkDiv : if not ClkDiv generate
		DivClk <= Clk;
	end generate;
	
	hcount_ov <= '1' when hcount = hpixel_end else '0';
	HCnt : process (DivClk)
	begin
		if rising_edge(DivClk) then
			if (hcount_ov = '1') then
				hcount <= (others => '0');
			else
				hcount <= hcount + 1;
			end if;
		end if;
	end process;
	
	vcount_ov <= '1' when vcount = vline_end else '0';
	VCnt : process (DivClk)
	begin
		if rising_edge(DivClk) then
			if (hcount_ov = '1') then
				if (vcount_ov = '1') then
						vcount <= (others => '0');
				else
					vcount <= vcount + 1;
				end if;
			end if;
		end if;
	end process;
	
	InView <= dat_act;
	dat_act <= '1' when ((hcount >= hdat_begin) and (hcount < hdat_end)) and ((vcount >= vdat_begin) and (vcount < vdat_end)) else '0';
	Hsync <= '1' when hcount > hsync_end else '0';
	Vsync <= '1' when vcount > vsync_end else '0';
	--
	OutputGen : process (RstN, DivClk)
	begin
		if RstN = '0' then
			RedOut <= (others => '0');
			GreenOut <= (others => '0');
			BlueOut <= (others => '0');
			Cnt_D <= (others => '0');
		elsif rising_edge(DivClk) then
			RedOut <= (others => '0');
			GreenOut <= (others => '0');
			BlueOut <= (others => '0');
			
			if (vcount = vdat_begin and hcount = hdat_begin) then
				Cnt_D <= Cnt_D + 1;
			end if;

			if dat_act = '1' then
				RedOut <= Cnt_D(3-1 downto 0);
				GreenOut <= Cnt_D(6-1 downto 3);
				BlueOut <= Cnt_D(9-1 downto 6);
			end if;
		end if;
	end process;
end architecture rtl;