library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.Types.all;

package VgaPack is 	
	constant hsync_end  : positive := 95;
	constant hdat_begin : positive := 143;
	constant hdat_end   : positive := 783;
	constant hpixel_end : positive := 799;
	--
	constant vsync_end  : positive := 1;
	constant vdat_begin : positive := 34;
	constant vdat_end   : positive := 514;
	constant vline_end  : positive := 524;

	constant VgaClkFreq : integer  := 25000000;

	constant VgaHFrontPorch  : positive := 22;
	constant VgaHVideo       : positive := 640;
	constant VgaHVideoW      : positive := bits(VgaHVideo);
	constant VgaHBackPorch   : positive := 42;
	--	
	constant VgaHPreHSync    : positive := VgaHFrontPorch + VgaHVideo + VgaHBackPorch;	
	--
	constant VgaHSync        : positive := 96;
	--
	constant VgaHLine        : positive := VgaHPreHSync + VgaHSync;
	constant VgaHLineW       : positive := bits(VgaHLine);
	--
	constant VgaVFrontPorch   : positive := 30;
	constant VgaVVideo        : positive := 480;
   constant VgaVVideoW      : positive := bits(VgaVVideo);
	constant VgaVBackPorch    : positive := 12;
	--
	constant VgaVPreVSync      : positive := VgaVFrontPorch + VgaVVideo + VgaVBackPorch;
	--
	constant VgaVSync         : positive := 2;
	--
	constant VgaVLine         : positive := VgaVPreVSync + VgaVSync;

   constant HCnt       : positive := VgaHLine; -- 800
	constant HCntW      : positive := bits(HCnt);
	
	constant VCnt       : positive := VgaVLine; -- 524
	constant VCntW      : positive := bits(VCnt);														 
end package;
	
package body VgaPack is 

end package body VgaPack;