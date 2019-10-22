----------------------------------------------------------------------------------
-- Company: Enseirb-Matmeca
-- Engineer: MOUHAGIR_OUANNAS
-- 
-- Create Date: 19.11.2018 18:28:02
-- Design Name: 
-- Module Name: Afficheur_7SEG - Behavioral
-- Project Name: Jeu Tetris
-- Target Devices: Nexys 4 xc7a100tcsg324-3 
 
-- Description: Il permet d'afficher le score du joueur sur l'afficheur 7_segments

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Afficheur_7SEG is
    Port ( Clock : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Ce_perception : in STD_LOGIC;
           Score : in STD_LOGIC_VECTOR(9 downto 0);
           DP : out STD_LOGIC;
           Sept_segments : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end Afficheur_7SEG;

architecture Behavioral of Afficheur_7SEG is


signal CMD: std_logic_vector(2 downto 0);
signal s1, s2, s3, s4, s5, s_c, s_d, s_u : std_logic_vector(6 downto 0);

begin

Trans: ENTITY WORK.Trans
		PORT    MAP(
		      nb_binaire => Score,
             sortie1 => s1,
             sortie2 => s2,
             sortie3 => s3,
             sortie4 => s4,
             sortie5 => s5,
             S_cent => s_c,
             S_diz => s_d,
             S_uni => s_u
             );

mod8: ENTITY WORK.mod8
		PORT    MAP(
		           C_e => ce_perception,
                   clock => Clock,
                   reset => Reset,
                   AN => AN,
                   sortie => CMD
                 ); 
                 
mux8: ENTITY WORK.mux8
		PORT    MAP(
		      COMMANDE => CMD,
                   E0 => s_u,
                   E1 => s_d,
                   E2 => s_c,
                   E3 => s5,
                   E4 => s4,
                   E5 => s3,
                   E6 => s2,
                   E7 => s1,
                   DP => DP,
                   S => Sept_segments
                 );  



end Behavioral;
