------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- registerFile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity registerFile is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(CLK,En,RST	  : in std_logic;
       rd         : in std_logic_vector(4 downto 0);
       S0         : in std_logic_vector(4 downto 0);
       S1         : in std_logic_vector(4 downto 0);
       D	  : in std_logic_vector(N-1 downto 0);
       rs          : out std_logic_vector(N-1 downto 0);
       rt	: out std_logic_vector(N-1 downto 0));

end registerFile;

architecture structural of registerFile is

  component decoder5to32 is
    port(WA	: in std_logic_vector(4 downto 0);
         En        : in std_logic;
         Q          : out std_logic_vector(31 downto 0));   -- Data value output  
  end component;

  component registers32 is
    generic(N : integer := 32);
    port(CLK        : in std_logic;     -- Clock input
         RST        : in std_logic;     -- Reset input
         S          : in std_logic_vector(N-1 downto 0);     -- Value from 5:32 Decoder
         En	    : in std_logic;
         D          : in std_logic_vector(N-1 downto 0);     -- Data value input
         Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27,Q28,Q29,Q30,Q31    : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;

  component mux32t1_dataflow is
    port(D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,D30,D31 : in std_logic_vector(31 downto 0);
	 S : in std_logic_vector(4 downto 0);
	 Y : out std_logic_vector(31 downto 0));
  end component;

signal decoderO : std_logic_vector(31 downto 0);
signal out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,out16,out17,out18,out19,out20,out21,out22,out23,out24,out25,out26,out27,out28,out29,out30,out31 : std_logic_vector(31 downto 0);

begin

--- Stage 1 decoder ----
g_Decoder : decoder5to32
port MAP(WA => rd,
	 En => En,
	 Q => decoderO);

---- Stage 2 Reisters ----
g_RegFile : registers32
port MAP(CLK => CLK,
         RST => RST,
	 S => decoderO,
	 En => En,
 	 D => D,
	 Q0 => out0,
	 Q1 => out1,
	 Q2 => out2,
	 Q3 => out3,
	 Q4 => out4,
	 Q5 => out5,
	 Q6 => out6,
	 Q7 => out7,
	 Q8 => out8,
	 Q9 => out9,
	 Q10 => out10,
	 Q11 => out11,
	 Q12 => out12,
	 Q13 => out13,
	 Q14 => out14,
	 Q15 => out15,
	 Q16 => out16,
	 Q17 => out17,
	 Q18 => out18,
	 Q19 => out19,
	 Q20 => out20,
	 Q21 => out21,
	 Q22 => out22,
	 Q23 => out23,
	 Q24 => out24,
	 Q25 => out25,
	 Q26 => out26,
	 Q27 => out27,
	 Q28 => out28,
	 Q29 => out29,
	 Q30 => out30,
	 Q31 => out31);

--- Stage 3 Multiplexers ---
g_Mux0 : mux32t1_dataflow
port MAP(D0 => out0,
	 D1 => out1,
	 D2 => out2,
	 D3 => out3,
	 D4 => out4,
	 D5 => out5,
	 D6 => out6,
	 D7 => out7,
	 D8 => out8,
	 D9 => out9,
	 D10 => out10,
	 D11 => out11,
	 D12 => out12,
	 D13 => out13,
	 D14 => out14,
	 D15 => out15,
	 D16 => out16,
	 D17 => out17,
	 D18 => out18,
	 D19 => out19,
 	 D20 => out20,
 	 D21 => out21,
 	 D22 => out22,
 	 D23 => out23,
 	 D24 => out24,
 	 D25 => out25,
 	 D26 => out26,
 	 D27 => out27,
 	 D28 => out28,
	 D29 => out29,
	 D30 => out30,
	 D31 => out31,
	 S => S0,
	 Y => rs);

g_Mux1 : mux32t1_dataflow
port MAP(D0 => out0,
	 D1 => out1,
	 D2 => out2,
	 D3 => out3,
	 D4 => out4,
	 D5 => out5,
	 D6 => out6,
	 D7 => out7,
	 D8 => out8,
	 D9 => out9,
	 D10 => out10,
	 D11 => out11,
	 D12 => out12,
	 D13 => out13,
	 D14 => out14,
	 D15 => out15,
	 D16 => out16,
	 D17 => out17,
	 D18 => out18,
	 D19 => out19,
 	 D20 => out20,
 	 D21 => out21,
 	 D22 => out22,
 	 D23 => out23,
 	 D24 => out24,
 	 D25 => out25,
 	 D26 => out26,
 	 D27 => out27,
 	 D28 => out28,
	 D29 => out29,
	 D30 => out30,
	 D31 => out31,
	 S => S1,
	 Y => rt);

  
end structural;