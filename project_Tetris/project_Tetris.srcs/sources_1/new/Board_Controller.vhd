----------------------------------------------------------------------------------
-- Company: Enseirb-Matmeca
-- Engineer: MOUHAGIR_OUANNAS
-- 
-- Create Date: 19.11.2018 18:28:02
-- Design Name: 
-- Module Name: Board_Controller - Behavioral
-- Project Name: Jeu Tetris
-- Target Devices: Nexys 4 xc7a100tcsg324-3 
-- Description: Ce bloc gere le deroulement du jeu, tout ce qui concerne la mise � jour de la table du jeu en fonction de donn�es entr�es par le joueur et leurs possibilit�e d'etre affectu�es.
--              En plus, il permet d'envoyer les donn�es � afficher sur l'�cran
-----------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Tetris_biblio.ALL;


entity Board_Controller is

    Port ( Clock : in STD_LOGIC;
           Reset : in STD_LOGIC;
           OVER : out STD_LOGIC;
                
           GO_LEFT : in STD_LOGIC;
           GO_RIGHT : in STD_LOGIC;
           GO_DOWN : in STD_LOGIC;
           ROTATE : in STD_LOGIC;     
           NEW_PIECE : in STD_LOGIC;
           TYPE_NEW_PIECE: in piece;
           REMOVE_ROW : in STD_LOGIC;
           NUM_LIGNE: in integer range 0 to (Board_ligne-1);
           CELL: in Blck;
           CELL_OUT: out board_array_type;
           GO_DOWN_POS: out STD_LOGIC;
           GO_LEFT_POS: out STD_LOGIC;
           GO_RIGHT_POS: out STD_LOGIC;
           ROTATE_POS: out STD_LOGIC;
           LIGNE_COMPLETE: out STD_LOGIC);
end Board_Controller;

architecture Behavioral of Board_Controller is

       signal board  : board_type;
	   signal piece_desc, piece_desc_suiv: piece;
	   type   BRD  is array(natural range <>, natural range <>) of std_logic;
       signal table  : BRD(0 to Board_col-1, 0 to Board_ligne-1);
       signal dow_pos,ov: std_logic;
begin

Nouvelle_Piece_Descendente: process (Clock, Reset)
    
	begin
        if (Reset = '1') then
            
            piece_desc <= Piece_SQUARE;
            
       elsif (rising_edge(Clock)) then
                        
            if (NEW_PIECE = '1') then
            
               piece_desc.shape_P <= TYPE_NEW_PIECE.shape_P;
               piece_desc.Color <= TYPE_NEW_PIECE.Color;
                for i in 0 to 3 loop
                    piece_desc.Blocks(i).ligne <= TYPE_NEW_PIECE.Blocks(i).ligne;
                    piece_desc.Blocks(i).col <= TYPE_NEW_PIECE.Blocks(i).col + (Board_col/2-2); --pour faire l'apparaitre au milieu du tableau
               end loop;
               
            else
               piece_desc<= piece_desc_suiv;
            end if;
       end if;
 end process;



      
Piece_Descendente: process(piece_desc, GO_DOWN, GO_LEFT, GO_RIGHT, ROTATE)
          variable pivot_rot : Blck; 
	begin
	    piece_desc_suiv <= piece_desc;
	    pivot_rot := piece_desc.Blocks(0);
        
		for i in 0 to 3 loop
            if (GO_DOWN = '1') then
                piece_desc_suiv.Blocks(i).ligne <= piece_desc.Blocks(i).ligne + 1;
            end if;
            if (GO_LEFT = '1') then
                  piece_desc_suiv.Blocks(i).col <= piece_desc.Blocks(i).col - 1;
            end if;        
            if (GO_RIGHT = '1') then
                  piece_desc_suiv.Blocks(i).col <= piece_desc.Blocks(i).col + 1; 
                          
            end if;
            if (ROTATE = '1') then
                  for j in 1 to 3 loop
                        piece_desc_suiv.Blocks(j).col <= pivot_rot.col - piece_desc.Blocks(j).ligne + pivot_rot.ligne;
                    
                        piece_desc_suiv.Blocks(j).ligne <= pivot_rot.ligne + piece_desc.Blocks(j).col - pivot_rot.col;
                  end loop;
                       
            end if;
        end loop;
    end process; 


Mouvements_possibles: process ( piece_desc, board)
    variable pivot: Blck;
    begin
         pivot := piece_desc.Blocks(0);
         
         GO_RIGHT_POS <= '1';
         GO_LEFT_POS <= '1';
         GO_DOWN_POS <= '1';
         ROTATE_POS<= '1';
         dow_pos <='1';
         
     for i in 0 to 3 loop
            
            --Descente:
            
        if (piece_desc.Blocks(i).ligne = Board_ligne-1) then
           GO_DOWN_POS <= '0';
           dow_pos <='0';
        else
          if (board.cells((piece_desc.Blocks(i).col),piece_desc.Blocks(i).ligne+1).rempli = '1') then
              GO_DOWN_POS <= '0';
              dow_pos <='0';
          end if;
        end if;                   
         
         --Mouvement à gauche:
         if (piece_desc.Blocks(i).col = 0) then
            GO_LEFT_POS <= '0';
         else
           if (board.cells((piece_desc.Blocks(i).col)-1,piece_desc.Blocks(i).ligne).rempli = '1') then
               GO_LEFT_POS <= '0';
           end if;
         end if;
         
         --Mouvement à droite:
         if (piece_desc.Blocks(i).col = Board_col-1) then
            GO_RIGHT_POS <= '0';
         else
           if (board.cells((piece_desc.Blocks(i).col)+1,piece_desc.Blocks(i).ligne).rempli = '1') then
               GO_RIGHT_POS <= '0';
           end if;
         end if; 
         
         --Rotation
        for j in 1 to 3 loop
          if ((pivot.col-piece_desc.Blocks(j).ligne+pivot.ligne) <0 or (pivot.col-piece_desc.Blocks(j).ligne + pivot.ligne) >= Board_col or (pivot.ligne + piece_desc.Blocks(j).col - pivot.col) >= Board_ligne) then
              ROTATE_POS<='0';
          else
           if(board.cells(pivot.col-piece_desc.Blocks(j).ligne +pivot.ligne , pivot.ligne + piece_desc.Blocks(j).col - pivot.col).rempli='1') then
              ROTATE_POS<='0';
           end if;
          end if;
            
         end loop;
       end loop;   
      end process;   
 
Ligne_verification: process(board, NUM_LIGNE)
            begin
                LIGNE_COMPLETE <= '1';
                for j in 0 to (Board_col-1) loop
                    if(board.cells(j,NUM_LIGNE).rempli = '0') then
                        LIGNE_COMPLETE <= '0';
                    end if;
                end loop;

            end process;  
              
      
Board_control: process(Clock, Reset)
      begin
          if (Reset = '1') then
              
              for j in 0 to Board_col-1 loop
                  for i in 0 to Board_ligne-1 loop
                      board.cells(j,i).rempli <= '0';
                  end loop;
              end loop;
              
          elsif rising_edge(Clock) then
          
              for i in 0 to Board_ligne-1 loop
                  for j in 0 to Board_col-1 loop
  
                      --if (ov= '1') then
                        --board.cells(j,i).rempli <= '0';
                          
                      if (NEW_PIECE = '1') then
                            if (table(j,i)='1') then
                                board.cells(j,i).rempli<= '1';
                                board.cells(j,i).Color <= piece_desc.Color;
                            end if;
                                
                      elsif (REMOVE_ROW = '1') then
                          if (i = 0) then
                              board.cells(j, 0).rempli <= '0';
                          elsif (i <= NUM_LIGNE) then
                              board.cells(j, i) <= board.cells(j, i-1);
                          end if; 
                      end if;
                             
                    end loop;
              end loop; 
          end if;         
      
      end process;
      
      
Cellules_occupees_par_la_piece: process(board, piece_desc)
      begin
          table <= ((others=> (others=>'0')));
          
          for i in 0 to 3 loop    
              table(piece_desc.Blocks(i).col,piece_desc.Blocks(i).ligne) <= '1';
          end loop;
  
      end process; 
 
     
Affichage: process(board, CELL, piece_desc, ov)
begin
    CELL_OUT.rempli <= '0';
    CELL_OUT.Color <= "000";
    
    CELL_OUT <= board.cells(CELL.col, CELL.ligne);
	
	  for i in 0 to 3 loop
         if(piece_desc.Blocks(i) = CELL) then
            CELL_OUT.rempli <= '1';
            CELL_OUT.Color  <= piece_desc.Color;
         end if;
      end loop;
      
end process;

GAME_OVER: process(table, dow_pos)
begin
ov <='0';
for j in 0 to Board_col-1 loop
  if(table(j,0) = '1' and dow_pos='0') then
    ov<= '1';   
  end if;
end loop;

end process;  
OVER<=ov;

      
end Behavioral;
