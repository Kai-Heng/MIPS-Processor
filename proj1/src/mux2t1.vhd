------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an 2:1
-- mux using structural VHDL
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is
	port (i_D0, i_D1 : in std_logic;
		i_S : 	in std_logic;
		o_O : out std_logic);
end mux2t1;

architecture structure of mux2t1 is
 component andg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
 end component;

 component invg
  port(i_A          : in std_logic;
       o_F          : out std_logic);
 end component;

 component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
 end component;

 signal and1, and2:std_logic;
 signal not1:std_logic;

begin

g_Not : invg
 port MAP(i_A => i_S,
	  o_F => not1);

g_And1: andg2
 port MAP(i_A=>i_D0,
	  i_B => not1, 
	  o_F => and1);	
g_And2: andg2
 port MAP(i_A => i_S,
	  i_B => i_D1,
	  o_F => and2);
g_Or2: org2
 port MAP(i_A => and1,
 	  i_B => and2,
	  o_F => o_O);
  
end structure;