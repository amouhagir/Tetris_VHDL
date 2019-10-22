----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2018 20:22:16
-- Design Name: 
-- Module Name: Trans - Behavioral
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

entity Trans is
    Port ( 
           nb_binaire : in STD_LOGIC_VECTOR (9 downto 0);
           sortie1 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie2 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie3 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie4 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie5 : out STD_LOGIC_VECTOR (6 downto 0);
           S_cent : out STD_LOGIC_VECTOR (6 downto 0);
           S_diz : out STD_LOGIC_VECTOR (6 downto 0);
           S_uni : out STD_LOGIC_VECTOR (6 downto 0)
           );
end Trans;

architecture Behavioral of Trans is

signal N : unsigned (9 downto 0);
begin


sortie1 <= "0100100" ;
sortie2 <= "0110001" ;
sortie3 <= "0000001" ;
sortie4 <= "0111001" ;
sortie5 <= "0110000" ;




P3 : process ( nb_binaire,N )
begin 
  N <= unsigned (nb_binaire);
  if (N < 10) then
     case N is
         when "0000000000" => S_uni <= "0000001";
         when "0000000001" => S_uni <= "1001111";
         when "0000000010" => S_uni <= "0010010";
         when "0000000011" => S_uni <= "0000110";
         when "0000000100" => S_uni <= "1001100";
         when "0000000101" => S_uni <= "0100100";
         when "0000000110" => S_uni <= "0100000";
         when "0000000111" => S_uni <= "0001111";
         when "0000001000" => S_uni <= "0000000";
         when "0000001001" => S_uni <= "0000100";
         when others => S_uni <= "1111111";
         
      end case; 
      
      S_diz <= "0000001";
      S_cent <= "0000001"; 
   
   elsif ( N < 100 ) then 
       case (N mod 10) is 
           when "0000000000" => S_uni <= "0000001";
           when "0000000001"=> S_uni <= "1001111";
           when "0000000010"=> S_uni <= "0010010";
           when "0000000011"=> S_uni <= "0000110";
           when "0000000100" => S_uni <= "1001100";
           when "0000000101" => S_uni <= "0100100";
           when "0000000110" => S_uni <= "0100000";
           when "0000000111" => S_uni <= "0001111";
           when "0000001000" => S_uni <= "0000000";
           when "0000001001" => S_uni <= "0000100";
           when others => S_uni <= "1111111";

        end case;
        
        case (N/10) is 
           when "0000000000" => S_diz <= "0000001";
           when "0000000001" => S_diz <= "1001111";
           when "0000000010" => S_diz <= "0010010";
           when "0000000011" => S_diz <= "0000110";
           when "0000000100" => S_diz <= "1001100";
           when "0000000101" => S_diz <= "0100100";
           when "0000000110" => S_diz <= "0100000";
           when "0000000111" => S_diz <= "0001111";
           when "0000001000" => S_diz <= "0000000";
           when "0000001001" => S_diz <= "0000100";
           when others => S_diz <= "1111111";

        end case; 
        
        S_cent <= "0000001";
        
   else
      case (N mod 10) is 
      when "0000000000" => S_uni <= "0000001";
      when "0000000001"=> S_uni <= "1001111";
      when "0000000010"=> S_uni <= "0010010";
      when "0000000011"=> S_uni <= "0000110";
      when "0000000100" => S_uni <= "1001100";
      when "0000000101" => S_uni <= "0100100";
      when "0000000110" => S_uni <= "0100000";
      when "0000000111" => S_uni <= "0001111";
      when "0000001000" => S_uni <= "0000000";
      when "0000001001" => S_uni <= "0000100";
      when others => S_uni <= "1111111";

     end case;
     
     case ((N/10) mod 10) is 
     when "0000000000" => S_diz <= "0000001";
     when "0000000001" => S_diz <= "1001111";
     when "0000000010" => S_diz <= "0010010";
     when "0000000011" => S_diz <= "0000110";
     when "0000000100" => S_diz <= "1001100";
     when "0000000101" => S_diz <= "0100100";
     when "0000000110" => S_diz <= "0100000";
     when "0000000111" => S_diz <= "0001111";
     when "0000001000" => S_diz <= "0000000";
     when "0000001001" => S_diz <= "0000100";
     when others => S_diz <= "1111111";

     end case;
     
     case (N/100) is 
        when "0000000000" => S_cent <= "0000001";
        when "0000000001" => S_cent <= "1001111";
        when "0000000010" => S_cent <= "0010010";
        when "0000000011" => S_cent <= "0000110";
        when "0000000100" => S_cent <= "1001100";
        when "0000000101" => S_cent <= "0100100";
        when "0000000110" => S_cent <= "0100000";
        when "0000000111" => S_cent <= "0001111";
        when "0000001000" => S_cent <= "0000000";
        when "0000001001" => S_cent <= "0000100";
        when others => S_cent <= "1111111";
     end case;     
                           
       
   end if;          
end process;

end Behavioral;
