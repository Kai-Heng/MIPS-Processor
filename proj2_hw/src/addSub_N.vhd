------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------


-- addSub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bits add/sub
-- component using structural VHDL,oneComp_N, mux2t1_N, Adder_N
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity addSub_N is
  generic(N : integer := 32);
	port (D0, D1 : in std_logic_vector(N-1 downto 0);
		n_Add_Sub : in std_logic;
		Sum : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic);
end addSub_N;

architecture structure of addSub_N is
 component onesComp_N
  port(i_D         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
 end component;

 component mux2t1_N
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
 end component;

 component Adder_N
	port (D0, D1 : in std_logic_vector(N-1 downto 0);
		Cin : 	in std_logic;
		Sum : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic);
 end component;

 signal inv : std_logic_vector(N-1 downto 0);
 signal mux : std_logic_vector(N-1 downto 0);

begin
----------Stage 0 -------------
g_Ones : onesComp_N
 port MAP(i_D => D1,
	  o_O => inv);

-------- Stage 1 --------
g_Nmux : mux2t1_N
 port MAP(i_S => n_Add_Sub,
	  i_D0 => D1,
	  i_D1 => inv,
	  o_O => mux);

-------- Stage 2 --------------
g_NAdder : Adder_N
 port MAP(D0 => D0,
	  D1 => mux,
	  Cin => n_Add_Sub,
          Sum => Sum,
	  Cout => Cout);

end structure;