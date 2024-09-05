
------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--mux4t1_5b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using dataflow VHDL, generics, and generate statements.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1_5b is
	port(D0,D1,D2,D3 : in std_logic_vector(4 downto 0);
	     S : in std_logic_vector(1 downto 0);
	     Y : out std_logic_vector(4 downto 0));
end mux4t1_5b;

architecture dataflow of mux4t1_5b is
begin
  Y <= D0 when (S="00") else
	D1 when (S="01") else
	D2 when (S="10") else
	D3 when (S="11") else
	"00000";

end dataflow;