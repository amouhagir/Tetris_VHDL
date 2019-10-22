----------------------------------------------------------------------------------
-- random_gen_V1, v1.1
-- 2016/11/29, yannick Bornat (yannick.bornat@enseirb.fr)
-- this module provides a random generator.
-- it is based on a LFSR counter
-- used Xilinx application note XAPP052 as reference for LFSR values
--
--
-- size is the LFSR size (between 3 and 168)
-- seed is the seed of the generator
-- outpt is the bit size of the output random value
-- cycle is the number of bit shifts to provide a new random value
--         (must be between outpt and size*2)
--
-- draws a new value each time 'update' is equal to '1'
-- lasts 'cycle' clock cycles, asserts 'rdy' when finished
--
-- UPDATED :
-- v1.1 : 2017/02/27 :
--    - improved response time to update. if only one bit required, it is ready on the next clock edge
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity random_gen_V1 is
    generic (size  : integer := 168;  -- the cycle of the shift register
             seed  : integer := 2016; -- the number of cycles used to seed the generator
             cycle : integer := 168;  -- how much bit shifts to draw a new value ? (may reduce cycle size if submultiple of (2**size - 1)
             outpt : integer := 3);   -- output size (must be lower than 'size')
    Port ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           update   : in  STD_LOGIC;
           rdy      : out STD_LOGIC;
           rand_val : out STD_LOGIC_VECTOR (outpt - 1 downto 0));
end random_gen_V1;

architecture Behavioral of random_gen_V1 is

   signal shift_reg : std_logic_vector(size downto 1);
   signal shift_en  : std_logic;
   
   signal shift_count : integer range 0 to size*2;
   signal seed_count  : integer range 0 to seed := seed;

begin

   rand_val <= shift_reg(outpt downto 1);
   rdy      <= '1' when seed_count = 0 and shift_count = 0 else '0';
   
   process(clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            shift_reg <= (1 => '1', others => '0');
         elsif shift_en = '1' then
            shift_reg(size downto 2) <= shift_reg(size - 1 downto 1);
            case size is
               when     3  => shift_reg(1) <= not (shift_reg(  3) xor shift_reg(  2));
               when     4  => shift_reg(1) <= not (shift_reg(  4) xor shift_reg(  3));
               when     5  => shift_reg(1) <= not (shift_reg(  5) xor shift_reg(  3));
               when     6  => shift_reg(1) <= not (shift_reg(  6) xor shift_reg(  5));
               when     7  => shift_reg(1) <= not (shift_reg(  7) xor shift_reg(  6));
               when     8  => shift_reg(1) <= not (shift_reg(  8) xor shift_reg(  6) xor shift_reg(  5) xor shift_reg(  4));
               when     9  => shift_reg(1) <= not (shift_reg(  9) xor shift_reg(  5));
               when    10  => shift_reg(1) <= not (shift_reg( 10) xor shift_reg(  7));
               when    11  => shift_reg(1) <= not (shift_reg( 11) xor shift_reg(  9));
               when    15  => shift_reg(1) <= not (shift_reg( 15) xor shift_reg( 14));
               when    17  => shift_reg(1) <= not (shift_reg( 17) xor shift_reg( 14));
               when    18  => shift_reg(1) <= not (shift_reg( 18) xor shift_reg( 11));
               when    20  => shift_reg(1) <= not (shift_reg( 20) xor shift_reg( 17));
               when    21  => shift_reg(1) <= not (shift_reg( 21) xor shift_reg( 19));
               when    22  => shift_reg(1) <= not (shift_reg( 22) xor shift_reg( 21));
               when    23  => shift_reg(1) <= not (shift_reg( 23) xor shift_reg( 18));
               when    25  => shift_reg(1) <= not (shift_reg( 25) xor shift_reg( 22));
               when    28  => shift_reg(1) <= not (shift_reg( 28) xor shift_reg( 25));
               when    29  => shift_reg(1) <= not (shift_reg( 29) xor shift_reg( 27));
               when    31  => shift_reg(1) <= not (shift_reg( 31) xor shift_reg( 28));
               when    39  => shift_reg(1) <= not (shift_reg( 39) xor shift_reg( 35));
               when    41  => shift_reg(1) <= not (shift_reg( 41) xor shift_reg( 38));
               when    47  => shift_reg(1) <= not (shift_reg( 47) xor shift_reg( 42));
               when    63  => shift_reg(1) <= not (shift_reg( 63) xor shift_reg( 62));
               when    87  => shift_reg(1) <= not (shift_reg( 87) xor shift_reg( 74));
               when    98  => shift_reg(1) <= not (shift_reg( 98) xor shift_reg( 87));
               when   127  => shift_reg(1) <= not (shift_reg(127) xor shift_reg(126));
               when   129  => shift_reg(1) <= not (shift_reg(129) xor shift_reg(124));
               when   137  => shift_reg(1) <= not (shift_reg(137) xor shift_reg(116));
               when   140  => shift_reg(1) <= not (shift_reg(140) xor shift_reg(111));
               when   142  => shift_reg(1) <= not (shift_reg(142) xor shift_reg(121));
               when   145  => shift_reg(1) <= not (shift_reg(145) xor shift_reg( 93));
               when   148  => shift_reg(1) <= not (shift_reg(148) xor shift_reg(121));
               when   150  => shift_reg(1) <= not (shift_reg(150) xor shift_reg( 97));
               when   151  => shift_reg(1) <= not (shift_reg(151) xor shift_reg(148));
               when   153  => shift_reg(1) <= not (shift_reg(153) xor shift_reg(152));
               when   159  => shift_reg(1) <= not (shift_reg(159) xor shift_reg(128));
               when   161  => shift_reg(1) <= not (shift_reg(161) xor shift_reg(143));
               when   165  => shift_reg(1) <= not (shift_reg(165) xor shift_reg(164) xor shift_reg(135) xor shift_reg(134));
               when   166  => shift_reg(1) <= not (shift_reg(166) xor shift_reg(165) xor shift_reg(128) xor shift_reg(127));
               when   167  => shift_reg(1) <= not (shift_reg(167) xor shift_reg(161));
               when   168  => shift_reg(1) <= not (shift_reg(168) xor shift_reg(166) xor shift_reg(153) xor shift_reg(151));
               when others => shift_reg(1) <= '0';
            end case;
         end if;
      end if;
   end process;

   shift_en <= '1' when shift_count /= 0 or update = '1' or seed_count > 0 else '0';

   process(clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            shift_count <= cycle-1;
         elsif shift_count /= 0  then
            shift_count <= shift_count - 1;
         elsif update = '1' or seed_count /= 0 then
            shift_count <= cycle-1;
         end if;
      end if;
   end process;
   
   process(clk)
   begin
      if rising_edge(clk) then 
         if reset = '1' then
            seed_count <= seed;
         elsif shift_count = 0 and seed_count /= 0 then
            seed_count <= seed_count - 1;
         end if;
      end if;
   end process;

end Behavioral;

