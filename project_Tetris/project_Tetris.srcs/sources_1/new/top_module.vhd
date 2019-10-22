-------------------------------------------------------------------------------
-- Bitmap VGA display with 640x480 pixel resolution
-------------------------------------------------------------------------------
-- V 1.1.1 (2015/07/28)
-- Yannick Bornat (yannick.bornat@enseirb-matmeca.fr)
--
-- For more information on this module, refer to module page :
--  http://bornat.vvv.enseirb.fr/wiki/doku.php?id=en202:vga_bitmap
-- 
-- V1.1.1 :
--   - Comment additions
--   - Code cleanup
-- V1.1.0 :
--   - added capacity above 3bpp
--   - ability to display grayscale pictures
--   - Module works @ 100MHz clock frequency
-- V1.0.1 :
--   - Fixed : image not centered on screen
-- V1.0.0 :
--   - Initial release
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity top_module is
  port(
		clk      : in  std_logic;
		reset    : in  std_logic;
      Hsync    : out std_logic;                     -- horisontal vga syncr.
      Vsync    : out std_logic;                     -- vertical vga syncr.
      vgaRed   : out std_logic_vector(3 downto 0);  -- red output
      vgaGreen : out std_logic_vector(3 downto 0);  -- green output
      vgaBlue  : out std_logic_vector(3 downto 0)   -- blue output
	);
end top_module;

architecture Behavioral of top_module is

signal data: std_logic_vector(0 downto 0);
signal addr: integer range 0 to 63999 := 0;
signal dw: std_logic;
signal i,j:integer :=0;


begin

process(clk,reset)
begin
     if (reset='1') then
        dw<='0';
        i<=0;
        j<=0;
     elsif rising_edge(clk) then
            
               dw<='1';  
               if j = 319 then
                     j <= 0;
                     if i = 199 then
                        i <= 0;
                     else
                        i <= i + 1;
                     end if;
               else
                     j <= j +1;      
               end if;
   
            
            if ( 0 <= i and i <= 150 and j >= 0 and j <= 180 ) then 
                if ( 5 <= i and i <= 145 and j >= 5 and j <= 175 ) then 
                  data <= '0';
                else
                  data <= '1';
                end if;
          else 
                data <= '0';
            end if; 
            
            addr <= 320*i+j;    
            
     end if;       
end process;


UUT: ENTITY WORK.VGA_bitmap_320x200
		GENERIC MAP(bit_per_pixel => 1, grayscale => false)
		PORT    MAP(
			clk        => clk,
			reset      => reset,
			VGA_hs     => Hsync,
			VGA_vs     => Vsync,
			VGA_red    => vgaRed,
			VGA_green  => vgaGreen,
			VGA_blue   => vgaBlue,
			ADDR       => std_logic_vector(to_unsigned(addr,16)),
			data_in    => data,
			data_write => dw,
			data_out   => open
		);

end Behavioral;