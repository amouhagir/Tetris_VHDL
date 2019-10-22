----------------------------------------------------------------------------------
-- Company: Enseirb-Matmeca
-- Engineer: MOUHAGIR_OUANNAS
-- 
-- Create Date: 19.11.2018 18:28:02
-- Design Name: 
-- Module Name: Gestion_temps - Behavioral
-- Project Name: Jeu Tetris
-- Target Devices: Nexys 4 xc7a100tcsg324-3 
-- Description: Ce bloc gere tout ce qui concerne la gestion de temps de l'affichage et la vitesse de descente des pieces
--              En plus, il gere le changement aleatoire de la forme des pieces.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Tetris_biblio.all;


entity Gestion_temps is
  Port (Clock : in STD_LOGIC;
        Reset : in STD_LOGIC;
        BUT_DOWN: in STD_LOGIC;
        NEW_PIECE: in STD_LOGIC;
        MOVE_DOWN: out STD_LOGIC;
        RAND_PIECE: out piece;
        CE_perception: out STD_LOGIC;
        CE: out STD_LOGIC );
end Gestion_temps;

architecture Behavioral of Gestion_temps is

    signal cmpt_descente : integer :=0; 
    signal move_dw: STD_LOGIC;
    signal Signal_CE: STD_LOGIC;
    signal Signal_perception: STD_LOGIC;
    signal CE_cmpt,cmpt2, cmpt : integer;
    
    -- La forme aléatoire d'une piece
    signal RAND_VAL: std_logic_vector(2 downto 0) :="000";
    -- Vitesse de la descente d'une piece:
    type vit is(Normale,Rapide);
    signal speed: vit :=Normale;
    
    
begin

--Clock_enable pour controler la descente d'une piece et son affichage sur l'ecran
Clock_Enable: process(Clock, Reset)
begin
if (Reset='1') then
   Signal_CE<='0';
   CE_cmpt <= 0;
elsif rising_edge(Clock) then
      if (CE_cmpt < 1000000) then
         CE_cmpt<= CE_cmpt + 1;
         Signal_CE <= '0';
      else
          CE_cmpt <= 0;
          Signal_CE <= '1';
      end if;       

end if;  
end process;

--Signal de perception (Afficheur septs_segments)
Perception: process(Clock, Reset)
begin
if (Reset='1') then
   Signal_perception<='0';
   cmpt <= 0;
elsif rising_edge(Clock) then
      if (cmpt = 33333) then
         cmpt <= 0;
         Signal_perception <= '1';
      else
          cmpt <= cmpt + 1;
          Signal_perception <= '0';
      end if;       

end if;   
end process;

    CE_perception <= Signal_perception;
    CE<=Signal_CE;
    
     
-- Ce Process gere la vitesse de la descente des pieces:
Chute: process(Clock,Reset)
       variable chute_vit: integer := NORMAL;
     begin
         if Reset='1' then
            cmpt_descente  <= 0;
            move_dw <= '0';
            speed<=Normale;
            
         elsif rising_edge(Clock) then
             
               move_dw <= '0';
              
               case(speed) is
                         when(Normale) => 
                                                            
                                 if (Signal_CE='1') then
                                    if (cmpt_descente < NORMAL) then
                                       cmpt_descente <= cmpt_descente + 1; 
                                           
                                    else
                                      move_dw <= '1';
                                      cmpt_descente <= 0; 
                                   end if;
                                 end if;
                                 
                                 if BUT_DOWN='1' then
                                    speed <= Rapide;
                                 end if;
                                 
                          when (Rapide) => 
                          
                                  if (Signal_CE='1') then
                                     if (cmpt_descente < FAST) then
                                        cmpt_descente <= cmpt_descente + 1; 
                                            
                                     else
                                       move_dw <= '1';
                                       cmpt_descente <= 0; 
                                    end if;
                                  end if;   
                                  
                                    if BUT_DOWN='1' then
                                       speed <= Normale;
                                    end if;
                                    if NEW_PIECE='1' then
                                       speed <= Normale;
                                     end if;   
                
                end case;                    
          end if;
     end process;
     

MOVE_DOWN <= move_dw;


 --Generer valeur aleatoire   
         
             random: ENTITY WORK.random_gen_V1
             GENERIC MAP ( size => 168,
                           seed => 2016 ,
                           cycle => 1 ,
                           outpt => 3 )
             PORT MAP(
                 clk    => Clock,
                 Reset    => Reset,
                 update   => '1',
                 rdy => open,
                 rand_val => RAND_VAL
             );
             
             
            
             RAND_PIECE <= Piece_SQUARE when (RAND_VAL= "000") else
                           Piece_L_L      when (RAND_VAL= "001") else
                           Piece_STICK  when (RAND_VAL= "010") else
                           Piece_T    when (RAND_VAL= "011") else
                           Piece_L_R    when (RAND_VAL= "100") else
                           Piece_DOG_L  when (RAND_VAL= "101") else 
                           Piece_DOG_R; 
             
             
             
end Behavioral;
