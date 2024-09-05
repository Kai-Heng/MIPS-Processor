------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--mux32t1_dataflow.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using dataflow VHDL, generics, and generate statements.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1_dataflow is
	port(D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D20,D21,D22,D23,D24,
	D25,D26,D27,D28,D29,D30,D31 : in std_logic_vector(31 downto 0);
	     S : in std_logic_vector(4 downto 0);
	     Y : out std_logic_vector(31 downto 0));
end mux32t1_dataflow;

architecture dataflow of mux32t1_dataflow is
begin
  Y <= D0 when (S="00000") else
	D1 when (S="00001") else
	D2 when (S="00010") else
	D3 when (S="00011") else
	D4 when (S="00100") else
	D5 when (S="00101") else
	D6 when (S="00110") else
	D7 when (S="00111") else
	D8 when (S="01000") else
	D9 when (S="01001") else
	D10 when (S="01010") else
	D11 when (S="01011") else
	D12 when (S="01100") else
	D13 when (S="01101") else
	D14 when (S="01110") else
	D15 when (S="01111") else
	D16 when (S="10000") else
	D17 when (S="10001") else
	D18 when (S="10010") else
	D19 when (S="10011") else
	D20 when (S="10100") else
	D21 when (S="10101") else
	D22 when (S="10110") else
	D23 when (S="10111") else
	D24 when (S="11000") else
	D25 when (S="11001") else
	D26 when (S="11010") else
	D27 when (S="11011") else
	D28 when (S="11100") else
	D29 when (S="11101") else
	D30 when (S="11110") else
	D31 when (S="11111") else
	"00000000000000000000000000000000";

end dataflow;