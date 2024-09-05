------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--reg32b.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity reg32b is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_S         : in std_logic;     -- Value from 5:32 Decoder
       En	: in  std_logic;
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end reg32b;

architecture structural of reg32b is
  component reg1b is
  port(CLK        : in std_logic;     -- Clock input
       RST        : in std_logic;     -- Reset input
       S         : in std_logic;	-- Value from 5:32 Decoder
       En	: in std_logic;
       D          : in std_logic;     -- Data value input
       Q          : out std_logic);   -- Data value output
  end component;

begin
  
  g_NBit_Reg : for i in 0 to N-1 generate
   reg : reg1b port map(CLK => i_CLK,
			RST => i_RST,
			S => i_S,
			En => En,
			D => i_D(i),
			Q => o_Q(i));
 end generate;
  
end structural;