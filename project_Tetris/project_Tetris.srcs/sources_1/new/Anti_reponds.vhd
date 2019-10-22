----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.01.2019 21:21:31
-- Design Name: 
-- Module Name: Anti_reponds - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Anti_reponds is
    Port (
                Clock: in std_logic;
                BUT_LEFT : in STD_LOGIC;
                BUT_RIGHT : in STD_LOGIC;
                BUT_DOWN : in STD_LOGIC;
                BUT_ROTATE : in STD_LOGIC; 
                BUT_PAUSE : in STD_LOGIC;
                LEFT : out STD_LOGIC;
                RIGHT: out STD_LOGIC;
                DOWN: out STD_LOGIC;
                ROTATE: out STD_LOGIC;
                PA: out STD_LOGIC
           );     
                  
end Anti_reponds;

architecture Behavioral of Anti_reponds is

begin

Anti_rebond1: entity work.anti_rebond 
    Port map( 
           clk => Clock,
           s_in => BUT_LEFT,
           s_out => LEFT
          );
Anti_rebond2: entity work.anti_rebond 
    Port map( 
           clk => Clock,
           s_in => BUT_RIGHT,
           s_out => RIGHT
         );
Anti_rebond3: entity work.anti_rebond 
    Port map( 
            clk => Clock,
            s_in => BUT_DOWN,
            s_out => DOWN
           );
Anti_rebond4: entity work.anti_rebond 
     Port map( 
             clk => Clock,
             s_in => BUT_ROTATE ,
             s_out => ROTATE
           );
Anti_rebond5: entity work.anti_rebond 
               Port map( 
                      clk => Clock,
                      s_in => BUT_PAUSE,
                      s_out => PA
                     ); 
end Behavioral;
