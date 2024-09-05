------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------


-- addSub_ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bits add/sub
-- component with ALUSrc using structural VHDL,oneComp_N, mux2t1_N, Adder_N
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity addSub_ALU is
  generic(N : integer := 32);
	port (D0, D1, I : in std_logic_vector(N-1 downto 0);
		n_Add_Sub : in std_logic;
		ALUSrc : in std_logic;
		Sum : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic);
end addSub_ALU;

architecture structure of addSub_ALU is
 component onesComp_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
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
		Ovfl : out std_logic);
 end component;

 signal inv, output : std_logic_vector(N-1 downto 0);
 signal mux, alu : std_logic_vector(N-1 downto 0);
 signal newOut : signed(N-1 downto 0);
 signal overflow : std_logic;

begin
----------Stage 0 -------------
g_ALU : mux2t1_N
  port MAP(i_S => ALUSrc,
	   i_D0 => D1,
	   i_D1 => I,
	   o_O => alu);

-------- Stage 1 --------
g_Ones : onesComp_N
 port MAP(i_D => alu,
	  o_O => inv);

-------- Stage 2 --------
g_Nmux : mux2t1_N
 port MAP(i_S => n_Add_Sub,
	  i_D0 => alu,
	  i_D1 => inv,
	  o_O => mux);

-------- Stage 3 -------------- 
g_NAdd : Adder_N
 port MAP(D0 => D0,
	  D1 => mux,
	  Cin => n_Add_Sub,
          Sum => Sum,
	  Ovfl => Cout);

end structure;