------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--reg1b.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity reg1b is
  port(CLK        : in std_logic;     -- Clock input
       RST        : in std_logic;     -- Reset input
       S         : in std_logic;	-- Value from 5:32 Decoder
       En	: in std_logic;
       D          : in std_logic;     -- Data value input
       Q          : out std_logic);   -- Data value output   

end reg1b;

architecture structural of reg1b is
  component mux2t1 is
	port (i_D0, i_D1 : in std_logic;
		i_S : 	in std_logic;
		o_O : out std_logic);
  end component;

  component dffg is
    port (i_CLK : in std_logic;
          i_RST : in std_logic;
	  i_WE : in std_logic;
	  i_D : in std_logic;
	  o_Q : out std_logic);
  end component;

  signal s_Q : std_logic;
  signal o_Mux : std_logic;
  
begin
 g_Mux : mux2t1
  port MAP(i_D0 => s_Q,
	   i_D1 => D,
	   i_S => S,
	   o_O => o_Mux);
 g_Dffg : dffg
   port Map(i_CLK => CLK,
	    i_RST => RST,
	    i_WE => En,
	    i_D => o_Mux,
	    o_Q => s_Q);

 Q <= s_Q;
  
end structural;