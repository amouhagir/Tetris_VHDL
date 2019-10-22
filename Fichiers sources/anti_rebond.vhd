----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2018 22:10:06
-- Design Name: 
-- Module Name: anti_rebond - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity anti_rebond is
    Port ( clk : in STD_LOGIC;
           s_in : in STD_LOGIC;
           s_out : out STD_LOGIC);
end anti_rebond;

architecture Behavioral of anti_rebond is

signal sign : std_logic:= '0';


begin

p1 : process (clk)
begin
if rising_edge(clk) then
      sign <= s_in;
      s_out <= (sign XOR s_in) and s_in;
end if;
end process;

end Behavioral;