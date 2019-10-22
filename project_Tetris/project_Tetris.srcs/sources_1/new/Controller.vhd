----------------------------------------------------------------------------------
-- Company: Enseirb-Matmeca
-- Engineer: MOUHAGIR_OUANNAS
-- 
-- Create Date: 19.11.2018 18:28:02
-- Design Name: 
-- Module Name: Controller - Behavioral
-- Project Name: Jeu Tetris
-- Target Devices: Nexys 4 xc7a100tcsg324-3 
-- Description: Ce bloc gere l'interface homme/machine (Les boutons de controle, le score du joueur 
--              Puis, supprime des lignes compl�tes.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Tetris_biblio.ALL;



entity Controller is
    Port ( Clock : in STD_LOGIC;
           Reset : in STD_LOGIC;
           OVER : in STD_LOGIC;
           RAND_PIECE: in piece;
           MOVE_DOWN: in STD_LOGIC;    
           BUT_LEFT : in STD_LOGIC;
           BUT_RIGHT : in STD_LOGIC;
           BUT_DOWN : in STD_LOGIC;
           BUT_ROTATE : in STD_LOGIC;
           BUT_PAUSE: in STD_LOGIC;
           GO_DOWN_POS: in STD_LOGIC;
           GO_LEFT_POS: in STD_LOGIC;
           GO_RIGHT_POS: in STD_LOGIC;
           ROTATE_POS: in STD_LOGIC;
           LIGNE_COMPLETE: in STD_LOGIC;
           GO_LEFT : out STD_LOGIC;
           GO_RIGHT : out STD_LOGIC;
           GO_DOWN : out STD_LOGIC;
           ROTATE : out STD_LOGIC;
           PLAY_PAUSE : out STD_LOGIC;   
           NEW_PIECE : out STD_LOGIC;
           TYPE_NEW_PIECE: out Piece:=Piece_SQUARE;
           REMOVE_ROW : out STD_LOGIC;
           Result: out STD_LOGIC_VECTOR(9 downto 0);
           NUM_LIGNE: out integer range 0 to (Board_ligne-1));
end Controller;


architecture Behavioral of Controller is


    
    type etat_ligne_type is (Attente,verif_ligne, Attente_efface);
    signal etat_ligne: etat_ligne_type; 
    signal   Demande_ligneverif   : std_logic :='0';
    signal   Ligne_cmpt    : integer range 0 to Board_ligne-1 := Board_ligne-1 ;
    signal score: integer:=0;
    signal PAUSE: std_logic :='1';
    signal INCREASE_SCORE: std_logic;
    
    
    
    
    
begin

      
-- Ce processus gere les mouvements en fonction des buttons appuis et ses possibilitees puis il affecte les sorties
             
Control: process(Clock,Reset) 
             begin
                    if Reset='1' then
                       GO_DOWN <= '0';
                       GO_LEFT <= '0';
                       GO_RIGHT <= '0';
                       ROTATE <= '0';               
                       TYPE_NEW_PIECE <= Piece_SQUARE;
                       NEW_PIECE <= '0';
                       Demande_ligneverif <= '0';
                       
                    elsif rising_edge(Clock) then
                         GO_DOWN <= '0';
                         GO_LEFT <= '0';
                         GO_RIGHT <= '0';
                         ROTATE <= '0';
                         NEW_PIECE <= '0';
                         Demande_ligneverif <= '0'; 
                         
                         if MOVE_DOWN = '1' then
                            if(PAUSE='1') then
                               GO_DOWN <= '0';
                            elsif (GO_DOWN_POS = '1') then
                                GO_DOWN <= '1';        
                            else     
                               NEW_PIECE <= '1';
                               TYPE_NEW_PIECE <= RAND_PIECE;
                               Demande_ligneverif <= '1';                             
                            end if;    
                          end if;     
                                if(PAUSE='1') then
                                   GO_LEFT <= '0';
                                   Go_RIGHT <= '0';
                                   ROTATE <= '0';
                               elsif (BUT_LEFT ='1' and GO_LEFT_POS ='1') then
                                    GO_LEFT <= '1';
                               elsif  (BUT_RIGHT ='1' and GO_RIGHT_POS ='1') then
                                    GO_RIGHT <= '1';   
                               elsif (BUT_ROTATE ='1' and ROTATE_POS = '1' ) then
                                    ROTATE <= '1';   
                               end if;
                      
                      end if;
               end process;
               
-- Ce process verifie les lignes pour supprimer celles qui sont completes

 NUM_LIGNE <= Ligne_cmpt-1;
         
Verif_lignes: process(Clock, Reset)
         begin
         		if (Reset = '1') then
                    REMOVE_ROW  <= '0';
                    
                    etat_ligne  <= Attente;

                elsif rising_edge(CLOCK) then
                        REMOVE_ROW        <= '0';
                        
                
                      case(etat_ligne) is
                            
                            when Attente => if (Demande_ligneverif ='1') then
                                                etat_ligne <= verif_ligne;
                                                Ligne_cmpt <= Board_ligne-1;
                                            end if;    
                            when verif_ligne => if ( LIGNE_COMPLETE ='1' ) then
                                                    etat_ligne <= Attente_efface;
                                                    REMOVE_ROW <= '1';
                                                      
                                                elsif ( Ligne_cmpt > 0 ) then
                                                      Ligne_cmpt <= Ligne_cmpt -1;
                                                else 
                                                    etat_ligne <= Attente;
                                                    
                                                end if;
                            when Attente_efface => etat_ligne <= verif_ligne;
                      end case;
                 end if;                                                                   
         end process;                                          



-- Calcul du score du jeu en fonction de nombre de lignes supprimees

--Anti_rebond: entity work.anti_rebond 
--    Port map( 
--           clk => Clock,
--           s_in => LIGNE_COMPLETE,
--           s_out => INCREASE_SCORE
--          );
               
Score_jeu: process(Clock,Reset)
        begin
            if(Reset='1') then
              score<=0; 
            elsif rising_edge(Clock) then
              if LIGNE_COMPLETE ='1' then
                 score<=score+1;
              end if;               
            end if;
        end process;    

Result <= STD_LOGIC_VECTOR(TO_UNSIGNED(score/2, 10));


-- Pause_Play du jeu
  
PAUSE_PLAY: process(Reset,Clock)
        begin
            if (Reset='1') then
                PAUSE<='1';
                
            elsif rising_edge(Clock) then
                 if (OVER='1') then
                     PAUSE<='1';
                 end if;    
                 if(BUT_PAUSE='1') then
                    PAUSE<= not(PAUSE);
                 end if;     
            end if;
        end process;

        PLAY_PAUSE<=PAUSE;
                                        
end Behavioral;
