library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.Types.all;

entity VGA3BitTestPattern is 
	port (
	RstN     : in bit1;
	Clk      : in bit1;
	--
	Button  : in word(3-1 downto 0);
	--
	HSync    : out bit1;
	VSync    : out bit1;
	VgaRed   : out word(3-1 downto 0);
	VgaGreen : out word(3-1 downto 0);
	VgaBlue  : out word(3-1 downto 0)
	);
end entity;

architecture rtl of VGA3BitTestPattern is
	signal ButtonDB, Button_N, Button_D : word(Button'length-1 downto 0);
	signal Blue_D, Red_D, Green_D : word(3-1 downto 0);
	signal Blue_N, Red_N, Green_N : word(3-1 downto 0);
	
	signal InView : bit1;
begin
	Db0 : entity work.Debounce
	port map (
		Clk => Clk,
		x => Button(0),
		DBx => ButtonDB(0)
	);
	
	Db1 : entity work.Debounce
	port map (
		Clk => Clk,
		x => Button(1),
		DBx => ButtonDB(1)
	);

	Db2 : entity work.Debounce
	port map (
		Clk => Clk,
		x => Button(2),
		DBx => ButtonDB(2)
	);
	
	Sync : process (RstN, Clk)
	begin
		if RstN = '0' then
			Button_D <= (others => '1');
			Red_D <= (others => '0');
			Blue_D <= (others => '0');
			Green_D <= (others => '0');
		elsif rising_edge(Clk) then
			Button_D <= Button_N;

			Red_D <= Red_N;
			Green_D <= Green_N;
			Blue_D <= Blue_N;
		end if;
	end process;
	
	AsyncProc : process (Green_D, Blue_D, Red_D, Button_D, ButtonDB)
	begin
		Red_N <= Red_D;
		Green_N <= Green_D;
		Blue_N <= Blue_D;
		Button_N <= ButtonDB;
		
		if (ButtonDB(0) = '0' and Button_D(0) = '1') then
			Red_N <= Red_D + 1;
		end if;
		
		if (ButtonDB(1) = '0' and Button_D(1) = '1') then
			Blue_N <= Blue_D + 1;
		end if;
		
		if (ButtonDB(2) = '0' and Button_D(2) = '1') then
			Green_N <= Green_D + 1;
		end if;
	end process;
	
	VgaRed <= Red_D when inView = '1' else (others => '0');
	VgaBlue <= Blue_D when inView = '1' else (others => '0');
	VgaGreen <= Green_D when inView = '1' else (others => '0');
	
	VgaGen : entity work.VGAGen
	generic map (
		ClkDiv => true
	)
	port map (
		RstN     => RstN,
		Clk      => Clk,
		--
		HSync    => HSync,
		VSync    => VSync,
		RedOut   => open,
		GreenOut => open,
		BlueOut  => open,
		--
		InView   => InView
	);

end architecture rtl;
