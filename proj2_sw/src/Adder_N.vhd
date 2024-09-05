------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------


-- Adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a full adder
-- using structural VHDL
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Adder_N is
  generic(N : integer := 32);
	port (D0, D1 : in std_logic_vector(N-1 downto 0);
		Cin : 	in std_logic;
		Sum : out std_logic_vector(N-1 downto 0);
		Ovfl : out std_logic);
end Adder_N;

architecture structure of Adder_N is
 component andg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
 end component;

 component xorg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
 end component;

 component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
 end component;

 signal sum0 : std_logic_vector(N-1 downto 0);
 signal and0, and1:std_logic_vector(N-1 downto 0);
 signal carryO : std_logic_vector(N-1 downto 0);
 signal lastCarryOut : std_logic;

begin

----------Stage 0 -------------
----------First Half Adder--------
g_Xor1 : xorg2
 port MAP(i_A => D1(0),
	  i_B => D0(0),
	  o_F => sum0(0));

g_And1: andg2
 port MAP(i_A=>D1(0),
	  i_B => D0(0), 
	  o_F => and0(0));	
--------- Second Half Adder---------
g_Xor2 : xorg2
 port MAP(i_A => sum0(0),
	  i_B => Cin,
	  o_F => Sum(0));

g_And2: andg2
 port MAP(i_A=>sum0(0),
	  i_B => Cin, 
	  o_F => and1(0));	
--------- OR --------
g_Or2: org2
 port MAP(i_A => and0(0),
 	  i_B => and1(0),
	  o_F => carryO(0));

---------- Generic --------
G_NBit_Adder : for i in 1 to N-1 generate
----------Stage 1--------
g_nXor1 : xorg2
 port MAP(i_A => D1(i),
	  i_B => D0(i),
	  o_F => sum0(i));

g_nAnd1: andg2
 port MAP(i_A=>D1(i),
	  i_B => D0(i), 
	  o_F => and0(i));	

g_nXor2 : xorg2
 port MAP(i_A => sum0(i),
	  i_B => carryO(i-1),
	  o_F => Sum(i));

g_nAnd2: andg2
 port MAP(i_A=>sum0(i),
	  i_B => carryO(i-1), 
	  o_F => and1(i));	

g_nOr: org2
 port MAP(i_A => and0(i),
 	  i_B => and1(i),
	  o_F => carryO(i));
  end generate G_NBit_Adder;
 
g_Overflow : xorg2
  port MAP(i_A => carryO(31),
	   i_B => carryO(30),
           o_F => Ovfl);

end structure;