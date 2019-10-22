----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2018 20:24:19
-- Design Name: 
-- Module Name: mod8 - Behavioral
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

entity mod8 is
    Port ( C_e : in STD_LOGIC;
           clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           sortie : out STD_LOGIC_VECTOR (2 downto 0));
end mod8;

architecture Behavioral of mod8 is
signal cmpt : unsigned (2 downto 0);
begin

mod8 : process (clock)
begin
 if rising_edge(clock) then
    if (C_e = '1') then
       if (( cmpt >= 7 ) or (reset = '1')) then
          cmpt <= "000";
       else
           cmpt <= cmpt + 1;
       end if;
    end if;
 end if;                   
end process;

sortie <= STD_LOGIC_Vector(cmpt);

AN7 : process (cmpt)
  begin 
  case cmpt is
      when "000" => AN <= "11111110";
      when "001" => AN <= "11111101";
      when "010" => AN <= "11111011";
      when "011" => AN <= "11110111";
      when "100" => AN <= "11101111";
      when "101" => AN <= "11011111";
      when "110" => AN <= "10111111";
      when "111" => AN <= "01111111";
  end case;
end process;
  

end Behavioral;
