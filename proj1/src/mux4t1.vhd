------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--mux4t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using dataflow VHDL, generics, and generate statements.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1 is
	port(i_D0, i_D1, i_D2, i_D3:in std_logic;
	     i_S : in std_logic_vector(1 downto 0);
	     o_O : out std_logic);
end mux4t1;

architecture dataflow of mux4t1 is
begin
  o_O <=i_D3 when(i_S = "11") else 
	i_D2 when(i_S = "10") else
	i_D1 when(i_S = "01") else
	 i_D0 when (i_S = "00") else
	 '0';
end dataflow;