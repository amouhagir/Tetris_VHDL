----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2018 09:39:58
-- Design Name: 
-- Module Name: Total - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Tetris_biblio.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Total is
      generic(pixel : integer range 1 to 12 :=3); 
      Port (Clock: in std_logic;
            Reset: in std_logic;
            BUT_LEFT : in STD_LOGIC;
            BUT_RIGHT : in STD_LOGIC;
            BUT_DOWN : in STD_LOGIC;
            BUT_ROTATE : in STD_LOGIC; 
            BUT_PAUSE : in STD_LOGIC; 
            Hsync    : out std_logic;                    
            Vsync    : out std_logic;                     
            vgaRed   : out std_logic_vector(3 downto 0);  
            vgaGreen : out std_logic_vector(3 downto 0); 
            vgaBlue  : out std_logic_vector(3 downto 0);
            
            DP: out STD_LOGIC;
            Sept_segments : out STD_LOGIC_VECTOR(6 downto 0);
            AN: out STD_LOGIC_VECTOR(7 downto 0)               
         );
end Total;

architecture Behavioral of Total is

signal LEFT,RIGHT,DOWN,ROTATE,PA: std_logic;
signal LEFT_POS, RIGHT_POS, DOWN_POS, ROTATE_POS: std_logic; 
signal GO_LEFT, GO_RIGHT, GO_DOWN, ROT, DRAW,PL_PA: std_logic;
signal data: std_logic_vector(pixel-1 downto 0);
signal addr: std_logic_vector(13 downto 0);
signal rand: std_logic_vector(2 downto 0);
signal dw,New_piece, move_down,Ce,Fin,LIGNE_COMPLETE,REMOVE:  std_logic;
signal type_piece, rand_p: piece;
signal NUM_LIGNE:integer range 0 to (Board_ligne-1);
signal CELL_OUT: board_array_type;
signal CELL: Blck;
signal BD: board_type;
signal NReset: std_logic;
signal Score: std_logic_vector(9 downto 0);
signal ce_perc: std_logic;


begin

NReset<= not(Reset);

Anti_Rebonds: ENTITY WORK.Anti_reponds
    PORT MAP(
                Clock      => Clock,
                BUT_LEFT   => BUT_LEFT, 
                BUT_RIGHT  => BUT_RIGHT, 
                BUT_DOWN   => BUT_DOWN, 
                BUT_ROTATE => BUT_ROTATE, 
                BUT_PAUSE  => BUT_PAUSE,
                LEFT       => LEFT,
                RIGHT      => RIGHT,
                DOWN       => DOWN,
                ROTATE     => ROTATE,
                PA         => PA
           );                          
           
                          
Gestion_temps: entity work.Gestion_temps
    Port map(
            Clock => Clock,
            Reset => NReset,
            
            BUT_DOWN => DOWN,
            NEW_PIECE => New_piece,
            MOVE_DOWN => move_down,
            RAND_PIECE => rand_p,
            CE_perception => Ce_perc,
            CE => Ce
           );
Controller: entity work.Controller
    Port map(
       Clock => Clock ,
       Reset => NReset,
       OVER => Fin,
       RAND_PIECE => rand_p,
       MOVE_DOWN => move_down,   
       BUT_LEFT => LEFT, 
       BUT_RIGHT => RIGHT,
       BUT_DOWN => DOWN,
       BUT_ROTATE => ROTATE,
       BUT_PAUSE => PA,
       GO_DOWN_POS => DOWN_POS,
       GO_LEFT_POS => LEFT_POS,
       GO_RIGHT_POS => RIGHT_POS,
       ROTATE_POS =>  ROTATE_POS,
       LIGNE_COMPLETE => LIGNE_COMPLETE,
       GO_LEFT => GO_LEFT,
       GO_RIGHT => GO_RIGHT,
       GO_DOWN => GO_DOWN,
       ROTATE => ROT,
       PLAY_PAUSE => PL_PA,
        
       NEW_PIECE => New_piece, 
       TYPE_NEW_PIECE => type_piece,
       REMOVE_ROW => REMOVE,
       Result => Score,
       NUM_LIGNE => NUM_LIGNE
    );
    
Board_Controller: entity work.Board_Controller
     Port map ( 
           Clock => Clock,
           Reset => NReset,
           OVER => Fin,                
           GO_LEFT => GO_LEFT,
           GO_RIGHT => GO_RIGHT,
           GO_DOWN => GO_DOWN,
           ROTATE => ROT,     
           NEW_PIECE => New_piece,
           TYPE_NEW_PIECE => type_piece,
           REMOVE_ROW => REMOVE,
           NUM_LIGNE => NUM_LIGNE,
           CELL => CELL ,
           CELL_OUT => CELL_OUT,
           
           GO_DOWN_POS => DOWN_POS,
           GO_LEFT_POS => LEFT_POS,
           GO_RIGHT_POS => RIGHT_POS,
           ROTATE_POS => ROTATE_POS,
           LIGNE_COMPLETE => LIGNE_COMPLETE 
         );
         
         
Affichage: entity work.Affichage
           generic map(bit_per_pixel=> 3)
           port map(
               Clock => Clock,
               Reset => NReset,
               
               OVER => Fin,
               PLAY_PAUSE => PL_PA,
               NEW_PIECE => New_piece,
               TYPE_NEW_PIECE => type_piece,
               CELL_OUT => CELL_OUT,
               CELL => CELL ,
               
               ADDR => addr,
               DATA => data,
               DATA_WRITE => dw            
           );            
    


VGA: ENTITY WORK.VGA_bitmap_160x100
		GENERIC MAP(bit_per_pixel => 3, grayscale => false)
		PORT    MAP(
			clk        => Clock,
			reset      => NReset,
			VGA_hs     => Hsync,
			VGA_vs     => Vsync,
			VGA_red    => vgaRed,
			VGA_green  => vgaGreen,
			VGA_blue   => vgaBlue,
			ADDR       => addr,
			data_in    => data,
			data_write => dw,
			data_out   => open
		);


Afficheur: ENTITY WORK.Afficheur_7SEG 
           PORT MAP(
            Clock          => Clock,
            Reset          => NReset,
            Ce_perception  => Ce_perc,
            Score          => Score,
            DP             => DP,
            Sept_segments  => Sept_segments,
            AN             => AN
            );  

end Behavioral;
