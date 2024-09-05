
------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- Adder_structural.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a full adder
-- using structural VHDL
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Adder_structural is
	port (D0, D1 : in std_logic;
		Cin : 	in std_logic;
		Sum : out std_logic;
		Cout : out std_logic);
end Adder_structural;

architecture structure of Adder_structural is
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

 signal sum0 : std_logic;
 signal and0, and1:std_logic;

begin

----------First Half Adder--------
g_Xor1 : xorg2
 port MAP(i_A => D1,
	  i_B => D0,
	  o_F => sum0);

g_And1: andg2
 port MAP(i_A=>D1,
	  i_B => D0, 
	  o_F => and0);	
--------- Second Half Adder---------
g_Xor2 : xorg2
 port MAP(i_A => sum0,
	  i_B => Cin,
	  o_F => Sum);

g_And2: andg2
 port MAP(i_A=>sum0,
	  i_B => Cin, 
	  o_F => and1);	
--------- OR --------
g_Or2: org2
 port MAP(i_A => and0,
 	  i_B => and1,
	  o_F => Cout);
  
end structure;