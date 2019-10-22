----------------------------------------------------------------------------------
-- Company: Enseirb-Matmeca
-- Engineer: MOUHAGIR_OUANNAS
-- 
-- Create Date: 19.11.2018 18:28:02
-- Design Name: 
-- Module Name: Affichage - Behavioral
-- Project Name: Jeu Tetris
-- Target Devices: Nexys 4 xc7a100tcsg324-3 
-- Description: Ce bloc permet de controller l'affichage sur l'écran 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Tetris_biblio.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Affichage is
  generic (bit_per_pixel : integer range 1 to 12 :=3);
  
  port(
      Clock      : in  std_logic;
      Reset    : in  std_logic;
      OVER: in STD_LOGIC;
      PLAY_PAUSE: in STD_LOGIC;
      NEW_PIECE: in STD_LOGIC;
      TYPE_NEW_PIECE : in piece;
      
      CELL_OUT : in board_array_type;
      CELL : out Blck;
      
      ADDR: out std_logic_vector(13 downto 0);
      DATA: out std_logic_vector(bit_per_pixel-1 downto 0);
      DATA_WRITE: out STD_LOGIC
      
  );
end Affichage;

architecture Behavioral of Affichage is

type ET is (START, FINGAME, DRAW_PIECE , DRAW_BOARD,DRAW_BORDURES); 
signal cellule: Blck := (0,0);

    signal etat: ET:= START;

    signal j: integer range 0 to 200:=0;
    signal i: integer range 0 to 200 :=0;
    signal cmpt, k: integer range 0 to 4:=0; 
    signal m,n: integer range 0 to 2 :=0;
begin

CELL <= cellule;

process(Clock, Reset)
    variable dt: std_logic :='0'; 
	begin
	
		if (Reset= '1') then
		
			cellule.col  <= 0;
			cellule.ligne  <= 0;
			ADDR <= (others => '0');
			etat <= START;
			DATA_WRITE <='0';
			i<=0; 
			j<=0;
			
			
			

		elsif (rising_edge(Clock)) then
		 
		  dt:= CELL_OUT.rempli;
		  
		  case (etat) is
		  
		        when START =>  if j < 160  then 
                                  j<= j+1;
                               else 
                                  j <= 0;
                                  if i <  100 then 
                                     i <= i+1;
                                  else
                                     i <= 0;
                                    
                                  end if;                                       
                               end if;
                               
                               --PRESS START
                               if ( ( (i>=47 and i <=51) and (j=60 or j=64 or j=68 or j=87 or j=91 or j=93 or j=95 or j=101)) or  ( ( i=47 or i=48 or i=49 or i=51 ) and (j=66 or j=72 or j=76 or j=81 or j=97 )) or ((i=47 or i=49 or i=51) and (j=69 or j=70 or j=73 or j=77 or j=82)) or ((i=47 or i=49 or i=50 or i=51) and (j=74 or j=78 or j=83)) or ((i=47 or i=49 or i=50) and (j=65 or j=96)) or (j=62 and (i=47 or i=48 or i=49)) or ((i=47 or i=49) and (j=61 or j=92)) or (((j>=85 and j<=89) or (j>=99 and j<=103)) and i=47) )  then 
                                   DATA<= "010";
                               else 
                                   DATA<= "000";    
                               end if;
                                
                               ADDR <= std_logic_vector(to_unsigned(i*160+j,14));
                               
                               if (PLAY_PAUSE ='0') then
                                   etat <= DRAW_BORDURES;
                                   i<=0;
                                   j<=0;
                               end if; 
                               
                               
		        when FINGAME =>               if j < 160  then 
                                                 j<= j+1;
                                              else 
                                                 j <= 0;
                                                 if i <  100 then 
                                                    i <= i+1;
                                                 else
                                                    i <= 0;
                                                    
                                                 end if;                                       
                                              end if;
                                               -- GAME OVER (avec un emoticon triste)
                                               
                                              if ( ( (i>=47 and i <=51) and (j=60 or j=65 or j=67 or j=69 or j=73 or j=75 or j=80 or j=83 or j= 91 or j=95)) or  ( ( i=47 or i=51 ) and (j=61 or j=81 or j=82) ) or ((i=47 or i=49 or i=51) and (j=62 or j=76 or j=77 or j=92 or j=93)) or ((i=47 or i=49 or i=50 or i=51) and j=63) or ((i=47 or i=49 ) and j=66) or (j=97 and (i=47 or i=48 or i=49 or i=51)) or ((i=47 or i=49 or i=50) and j=96) or ( (j=70 or j=72) and i=48) or (j=71 and i=49)  or ((i=47 or i=48 or i=49) and (j=85 or j=89)) or (i=50 and (j=86 or j=88)) or (i=51 and j=87) ) then 
                                                  DATA<= "100";
                                              elsif ( ((i=54 or i=62) and (j>=75 and j<=83)) or ((j=75 or j=83) and (i>=54 and i<=62)) or ((i=56 or i=60) and (j=77 or j=81)) or ( i=59 and (j=78 or j=79 or j=80)) ) then
                                                  DATA<= "110";    
                                              else 
                                                  DATA<= "000";    
                                              end if;
                                               
                                              ADDR <= std_logic_vector(to_unsigned(i*160+j,14));
                                              
                                             
                                              
		        when DRAW_BORDURES =>   if j < 160  then 
                                           j <= j+1;
                                        else 
                                           j <= 0;
                                           if i <  100 then 
                                              i <= i+1;
                                           else
                                              i <= 0;
                                              etat <= DRAW_PIECE;
                                           end if;                                       
                                       end if;
                                        -- Bordures du jeu
                                       if( ((j>=START_X-1 and j<=START_X+2*Board_col) and (i=START_Y-1 or i=START_Y+2*Board_ligne)) or ((i>=START_Y-1 and i<=START_Y+2*Board_ligne) and (j=START_X-1 or j=START_X+2*Board_col))) then  
                                            DATA<="111";
                                            
                                       
                                        --WELCOME TO TETRIS    
                                        
                                      elsif( ( (j=1 or j=5 or j=7 or j=10 or j=14 or j=18 or j=21 or j=23 or j=29 or j=31) and (i>=10 and i<= 14)) or (j=3 and (i>=12 and i<= 14)) ) then
                                            DATA<="010"; 
                                      elsif( (i=14 and (j>=1 and j<=5)) or (j=8 and (i=10 or i=12 or i=14)) or (i=14 and (j=11 or j=12)) or ((i=10 or i=14) and (j=15 or j=16)) or ((i=10 or i=14) and (j=19 or j=20)) or (i=10 and (j=24 or j=28)) or (i=11 and (j=25 or j=27)) or (i=12 and j =26) or (j=32 and (i=10 or i=12 or i=14)) ) then  --Word: WELCOME
                                            DATA <= "010";
                                      elsif ( ( (j=26 or j=30 or j=33) and (i>=17 and i<= 21) ) or ( i=17 and ((j>=24 and j<= 28) or (j>=30 and j<= 33)) ) or (i=21 and (j>=30 and j<= 33))) then --Word: TO 
                                            DATA <= "010";      
                                      elsif ( ((j=32 or j=36 or j=41 or j=45 or j=51 ) and (i>=24 and i<= 28) ) or ( i=24 and ((j>=30 and j<= 34) or (j>=39 and j<= 43) or (j>=49 and j<= 53))) or ( i=28 and ((j>=49 and j<= 53))) or ((j=37 or j=56) and (i=24 or i=26 or i=28 )) or ( j=46 and (i=24 or i=26 or i=27)) or ( (j=47 or j=55) and (i=24 or i=25 or i=26 or i=28)) or ( j=57 and (i=24 or i=26 or i=27 or i=28)) )  then --Word: TETRIS 
                                            DATA <= "010";
                                    
                                     -- ENSEIRB 
                                     elsif ( ((j=128 or j=132 or j=136 or j=142 or j=148 or j=152 or j=156) and (i>=10 and i<=14)) or ( (i=10 or i=12 or i=14) and (j=129 or j=130 or j=139 or j=143 or j=144 or j=157)) or (i=11 and j=133) or (i=12 and j=134) or (i=13 and j=135) or ( (i=10 or i=11 or i=12 or i=14) and (j=138 or j=154)) or ( (i=10 or i=12 or i=13 or i=14) and j=140) or ( (i=10 or i=11 or i=13 or i=14) and j=158) or ( (i=10 or i=12 or i=13) and j=153) or ( (i=10 or i=14) and (j=146 or j=147 or j=149 or j=150)) ) then
                                           DATA<="010";
                                     -- 2018
                                     elsif ( ((j=142 or j=144 or j=146 or j=148 or j=150) and (i>=17 and i<=21)) or ( (i=17 or i=19 or i=21) and (j=139 or j=149)) or ( (i=17 or i=21) and j=143) or ( (i=17 or i=19 or i=20 or i=21) and j=138) or ( (i=17 or i=18 or i=19 or i=21) and j=140) ) then
                                           DATA<="010";      
                                     
                                     -- F.P (FALLING PIECE) 
                                      
                                      elsif ( ((j=142 or j=148) and (i>=32 and i<=36)) or ((i=32 or i=34) and (j=143 or j=144 or j=149 or j=150)) or (i=33 and j=150) or (i=36 and j=146)) then  
                                            DATA<="100";
                                            
                                      elsif (((j>=141 and j<=152) and (i=38 or i=51)) or ((i>=38 and i<=51) and (j=141 or j=152))) then
                                             DATA<="111";    
                                      
                                      
                                      else
                                            DATA<= "000";
                                       end if;          
                                       ADDR <= std_logic_vector(to_unsigned((i*160+j),14));
                                       
		         
                  --Affichage de la table du jeu 
                                                       
		          when DRAW_BOARD => if cmpt<4 then
		          
		                              if (dt='1') then
		                                  DATA <= CELL_OUT.Color;
		                              else
		                                  DATA<="000";
		                              end if; 
		                              
		                              
		                               if n < 1 then
                                         n <= n+1;
                                       else 
                                         n <= 0;  
                                         if m < 1 then
                                            m <= m+1;
                                         else
                                            m <= 0; 
                                         end if;                                       
                                       end if;     
                                       
		                              ADDR <= std_logic_vector(to_unsigned((START_Y+2*cellule.ligne+m)*160+2*cellule.col+START_X+n,14));	          
		  	                          cmpt<= cmpt+1;
		  	                          
		  	                         else
		  	                          
	                                   if (cellule.col < Board_col-1) then
                                            cellule.col <= cellule.col + 1;
                                       else
                                            cellule.col <= 0;
                                            if (cellule.ligne < Board_ligne-1) then
                                                cellule.ligne <= cellule.ligne + 1;
                                            else
                                                cellule.ligne <= 0;
                                                                  
                                            end if;
                                        end if;
                                      cmpt<=0;
                                     end if;
                                     
                                     if (OVER='1') then
                                        etat <= FINGAME;    
                                     end if;
                                     
                                     if (NEW_PIECE ='1') then
                                        etat <= DRAW_PIECE;
                                        n<=0;
                                        m<=0;
                                        cmpt<=0;
                                     end if;   
                                     
                  when DRAW_PIECE =>   --Affichage de la piece descendante       
                                       if cmpt<4 then
                                          if n < 1 then
                                            n <= n+1;
                                          else 
                                            n <= 0;  
                                            if m < 1 then
                                               m <= m+1;
                                            else
                                               m <= 0; 
                                            end if;                                       
                                          end if;     
                                          
                                           ADDR <= std_logic_vector(to_unsigned((41+2*i+m)*160+2*j+144+n,14));              
                                           
                                           cmpt<= cmpt+1;  
                                       else 
                                              if j < 3  then 
                                                 j <= j+1;
                                              else 
                                                 j <= 0;
                                                 if i < 4 then 
                                                    i <= i+1;
                                                 else
                                                    i <= 0;
                                                    etat <= DRAW_BOARD;
                                                 end if;                                       
                                              end if; 
                                          cmpt<=0;
                                       end if; 
                                       
                                       DATA <= "000";                 
                                       for k in 0 to 3 loop
                                           if (TYPE_NEW_PIECE.Blocks(k).ligne = i and TYPE_NEW_PIECE.Blocks(k).col=j) then
                                               DATA<= TYPE_NEW_PIECE.Color;
                                           end if;
                                       end loop;
                                       
                                                                                                             
                                                                
	        end case; 
 
                DATA_WRITE <= '1';
	        end if;                  
	        
	end process;
	


end Behavioral;
