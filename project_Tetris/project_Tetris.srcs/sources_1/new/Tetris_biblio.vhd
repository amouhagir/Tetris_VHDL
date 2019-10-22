
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

package Tetris_biblio is

    constant Board_col : integer := 15;
    constant Board_ligne : integer :=25;
    
    constant FAST: integer := 10;
    constant NORMAL: integer := 40;
    
    constant START_X: integer range 0 to 150 := 65;
    constant START_Y: integer range 0 to 100 := 31;
    
    type shape is (shape_T, shape_SQUARE, shape_L_L, shape_L_R, shape_DOG_L, shape_DOG_R, shape_STICK);
-- Définition des type nécessaire pour la able du jeu (Board):

	type board_array_type is record
		rempli       : std_logic;
		Color: STD_LOGIC_VECTOR(2 downto 0);
	end record;	

	type board_array is array(natural range <>, natural range <>) of board_array_type;
	
	type board_type is record
		cells        :  board_array(0 to (Board_col-1), 0 to (Board_ligne-1));
	end record;    
    
--Definition des types necessaires pour les pieces:



type Blck is record 
       col: integer range 0 to Board_col -1;
       ligne: integer range 0 to Board_ligne-1;
end record;

type Block_array is array (0 to 3) of Blck;

type Piece is record
     shape_P: shape;
     Blocks: Block_array;
     Color: STD_LOGIC_VECTOR(2 downto 0);
end record;

	

-- Creation des pieces --

-- Piece en T : 
constant Piece_T : Piece :=
    ( shape_P => shape_T,
      Blocks => 
             (  (1, 1),
                (1, 0),
                (2, 0),
                (0, 0)
             ),
      Color=> "001"       
     );
     
 -- Piece en L_Right : 
     constant Piece_L_R : Piece :=
         ( shape_P => shape_L_R,
           Blocks => 
                  (  (1, 1),
                     (2, 0),                       
                     (0, 1),
                     (2, 1)
                  ),
                  Color=> "010" 
          );            
             
-- Piece en L_LEFT : 
          constant Piece_L_L : Piece :=
              ( shape_P => shape_L_L,
                Blocks => 
                       (  (1, 1),
                          (0, 1),
                          (0, 0),
                          (2, 1)
                       ),
                       Color=> "011" 
               );
               
-- Piece en SQUARE : 
               constant Piece_SQUARE : Piece :=
                   ( shape_P => shape_SQUARE,
                     Blocks => 
                            (  (1,  1),
                               (1,  0),
                               (0,  1),
                               (0,  0)
                            ),
                            Color=> "100" 
                    );
                    
                    
--Piece en STICK           
             constant Piece_STICK : Piece :=
                        ( shape_P => shape_STICK,
                          Blocks => 
                                 (  (0, 1),
                                    (0, 0),
                                    (0, 2),
                                    (0, 3)
                                 ),
                                 Color=> "101" 
                         );                   
                    
--Piece en DOG_LEFT   
               constant Piece_DOG_L : Piece :=
                             ( shape_P => shape_DOG_L,
                               Blocks => 
                                      (  (1, 1),
                                         (1, 0),
                                         (0, 0),
                                         (2, 1)
                                      ),
                                      Color=> "110" 
                              );                    
 
--Piece en DOG_RIGHT   
                  constant Piece_DOG_R : Piece :=
                            ( shape_P => shape_DOG_R,
                              Blocks => 
                                       (  
                                          (1, 1),
                                          (0, 1),
                                          (1, 0),
                                          (2, 0)
                                        ),
                                        Color=> "110" 
                              ); 
                              
                              

                                                                 
end package;

