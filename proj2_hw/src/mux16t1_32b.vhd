------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--mux16t1_32b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using dataflow VHDL, generics, and generate statements.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux16t1_32b is
	port(D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15 : in std_logic_vector(31 downto 0);
	     S : in std_logic_vector(3 downto 0);
	     Y : out std_logic_vector(31 downto 0));
end mux16t1_32b;

architecture dataflow of mux16t1_32b is
begin
  Y <= D0 when (S="0000") else
	D1 when (S="0001") else
	D2 when (S="0010") else
	D3 when (S="0011") else
	D4 when (S="0100") else
	D5 when (S="0101") else
	D6 when (S="0110") else
	D7 when (S="0111") else
	D8 when (S="1000") else
	D9 when (S="1001") else
	D10 when (S="1010") else
	D11 when (S="1011") else
	D12 when (S="1100") else
	D13 when (S="1101") else
	D14 when (S="1110") else
	D15 when (S="1111") else
	"00000000000000000000000000000000";

end dataflow;
