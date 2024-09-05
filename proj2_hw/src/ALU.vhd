------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------


-- ALU.vhd
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

entity ALU is
  generic(N : integer := 32);
	port (A, B : in std_logic_vector(N-1 downto 0);
		ALUOP : in std_logic_vector(4 downto 0);
		F : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic;
		Overflow : out std_logic;
		Zero : out std_logic);
  	
end ALU;

architecture structure of ALU is
 component addSub_ALU
  generic(N : integer := 32);
	port (D0, D1, I : in std_logic_vector(N-1 downto 0);
		n_Add_Sub : in std_logic;
		ALUSrc : in std_logic;
		Sum : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic);
 end component;

 component andg2_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
 end component;

 component org2_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
 end component;

 component xorg2_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0          : in std_logic_vector(N-1 downto 0);
	i_D1          : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
 end component;
 
 component norg2_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0          : in std_logic_vector(N-1 downto 0);
	i_D1          : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
 end component;
 
 component barrelShifter
  port(
        DATA : in std_logic_vector(31 downto 0);
	shamt : in std_logic_vector(4 downto 0);
	DIR : in std_logic; -- 0: right 1: left
	MODE : in std_logic; -- 0: logical 1: arithmetic 
	OUTPUT : out std_logic_vector(31 downto 0));
 end component;

 component mux32t1_dataflow
	port(D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15, D16,D17,D18,D19,D20,D21,D22,D23,D24,
	D25,D26,D27,D28,D29,D30,D31 : in std_logic_vector(31 downto 0);
	     S : in std_logic_vector(4 downto 0);
	     Y : out std_logic_vector(31 downto 0));
 end component;
 
 --signal
 signal addOutput, subOutput, sltOutput, andOutput, orOutput, xorOutput, norOutput, sllOutput, srlOutput, sraOutput, bgOutput, blOutput, bOutput, luiOutput  : std_logic_vector(31 downto 0) := x"00000000";
 signal addOver, subOver, sltOver, bgOver, blOver, bOver : std_logic := '0';
 signal sltSetOutput, sltFinalOut : std_logic_vector(31 downto 0);

 
begin
   -- add
        g_add : addSub_ALU
	port MAP(D0 => A,
		D1 => B,
		I => B,
		n_Add_Sub => '0',
		ALUSrc => '0',
		Sum => addOutput,
		Cout => addOver);

  -- sub
	g_sub : addSub_ALU
	port MAP(D0 => A,
		D1 => B,
		I => B,
		n_Add_Sub => '1',
		ALUSrc => '0',
		Sum => subOutput,
		Cout => subOver);

   -- slt
	g_slt : addSub_ALU
	port MAP(D0 => A,
		D1 => B,
		I => B,
		n_Add_Sub => '1',
		ALUSrc => '0',
		Sum => sltOutput,
		Cout => sltOver);

   -- and
	g_and : andg2_N
          port MAP(i_D0 => A,
		   i_D1 => B,
		   o_O => andOutput);

   -- or 
	g_or : org2_N
          port MAP(i_D0 => A,
		   i_D1 => B,
		   o_O => orOutput);

   -- xor
	g_xor : xorg2_N
          port MAP(i_D0 => A,
		   i_D1 => B,
		   o_O => xorOutput);

   -- nor
	g_nor : norg2_N
          port MAP(i_D0 => A,
		   i_D1 => B,
		   o_O => norOutput);
   
   -- sll
	g_sll : barrelShifter
	  port MAP(DATA => B,
		   shamt => A(10 downto 6),
		   DIR => '1',
		   MODE => '0',
		   OUTPUT => sllOutput);

   -- srl
	g_srl : barrelShifter
	  port MAP(DATA => B,
		   shamt => A(10 downto 6),
		   DIR => '0',
		   MODE => '0',
		   OUTPUT => srlOutput);

   -- sra
	g_sra : barrelShifter
	  port MAP(DATA => B,
		   shamt => A(10 downto 6),
		   DIR => '0',
		   MODE => '1',
		   OUTPUT => sraOutput);

   -- bgtz, bgez, bgezal
	g_bgez : addSub_ALU
	port MAP(D0 => A,
		D1 => x"00000000",
		I => x"00000000",
		n_Add_Sub => '1',
		ALUSrc => '0',
		Sum => bgOutput,
		Cout => bgOver);

   -- bltz, blez, blezal
	g_blez : addSub_ALU
	port MAP(D0 => A,
		D1 => x"00000000",
		I => x"00000000",
		n_Add_Sub => '1',
		ALUSrc => '0',
		Sum => blOutput,
		Cout => blOver);

	-- beq | bne
	g_beq : addSub_ALU
	port MAP(D0 => A,
		D1 => B,
		I => B,
		n_Add_Sub => '1',
		ALUSrc => '0',
		Sum => bOutput,
		Cout => bOver);

	-- lui
        g_lui : barrelShifter
	port MAP(DATA => B,
		 shamt => "10000",
		 DIR => '1',
		 MODE => '0',
		 OUTPUT => luiOutput);






   -- select for Overflow, Cout, Zero
   P_ALUOUT : process (ALUOP, addOver, subOver, sltOver, bgOver, blOver, bOver, sltOutput, bgOutput, blOutput, bOutput, sltSetOutput)
   variable v_sltOut  : std_logic_vector(31 downto 0);

   begin

	-- and
	if(ALUOP = "00000") then
	    Overflow <= '0';
	    Cout <= '0';
	    Zero <= '0';
	    sltSetOutput <= x"00000000";

	-- or
	elsif(ALUOP = "00001") then
	    Overflow <= '0';
	    Cout <= '0';
	    Zero <= '0';
	    sltSetOutput <= x"00000000";

	-- add
 	elsif(ALUOP = "00010") then
	   Zero <= '0';
	   Cout <= addOver;
	   Overflow <= addOver;
	    sltSetOutput <= x"00000000";

	-- xor
	elsif(ALUOP = "00011") then
	    Overflow <= '0';
	    Cout <= '0';
	    Zero <= '0';
	    sltSetOutput <= x"00000000";

	-- bgez / bgezal
	elsif(ALUOP = "00100") then
	    Overflow <= 'X';
	    Cout <= 'X';
	    sltSetOutput <= x"00000000";
	    if(bgOutput(31) /= '1' or bgOutput = x"00000000") then
	       Zero <= '1';
	    else
	       Zero <= '0';
	    end if;
	    

	-- bgtz
	elsif(ALUOP = "00101") then
	    Overflow <= 'X';
	    Cout <= 'X';
	    sltSetOutput <= x"00000000";
	    if(bgOutput(31) = '1' or bgOutput = x"00000000") then
	       Zero <= '0';
	    else
	       Zero <= '1';
	    end if;
	
	-- sub
	elsif(ALUOP = "00110") then
	   Zero <= '0';
	   Overflow <= subOver;
	   Cout <= subOver;
	    sltSetOutput <= x"00000000";

	-- slt
	elsif(ALUOP = "00111") then
	    Overflow <= 'X';
	    Cout <= 'X';
	    Zero <= 'X';
	    if(sltOutput(31) = '1') then
	       sltSetOutput <= x"00000001";
	    else
	       sltSetOutput <= x"00000000";
	    end if;

	-- sll
	elsif(ALUOP = "10000") then
	    Overflow <= '0';
	    Cout <= '0';
	    Zero <= '0';
	    sltSetOutput <= x"00000000";


	-- srl
	elsif(ALUOP = "01001") then
	    Overflow <= '0';
	    Cout <= '0';
	    Zero <= '0';
	    sltSetOutput <= x"00000000";

	-- sra
	elsif(ALUOP = "01010") then
	    Overflow <= '0';
	    Cout <= '0';
	    Zero <= '0';
	    sltSetOutput <= x"00000000";

	-- blez
	elsif(ALUOP = "01011") then
	    Overflow <= 'X';
	    Cout <= 'X';
	    sltSetOutput <= x"00000000";
	    if(blOutput(31) = '1' or blOutput = x"00000000") then
	       Zero <= '1';
	    else
	       Zero <= '0';
	    end if;

	-- nor
	elsif(ALUOP = "01100") then
	    Overflow <= '0';
	    Cout <= '0';
	    Zero <= '0';
	    sltSetOutput <= x"00000000";

	-- beq
	elsif(ALUOP = "01101") then
	    Overflow <= 'X';
	    Cout <= 'X';
	    sltSetOutput <= x"00000000";
	    if(bOutput = x"00000000") then
	       Zero <= '1';
	    else
	       Zero <= '0';
	    end if;

	-- bne
	elsif(ALUOP = "01110") then
	    Overflow <= 'X';
	    Cout <= 'X';
	    sltSetOutput <= x"00000000";
	    if(bOutput = x"00000000") then
	       Zero <= '0';
	    else
	       Zero <= '1';
	    end if;

	-- bltz / bltzal
	elsif(ALUOP = "01111") then
	    Overflow <= 'X';
	    Cout <= 'X';
	    sltSetOutput <= x"00000000";
	    if(blOutput(31) = '1') then
	       Zero <= '1';
	    else
	       Zero <= '0';
	    end if;

	-- lui
	elsif(ALUOP = "10000") then
	    Overflow <= '0';
	    Cout <= '0';
	    Zero <= '0';
	    sltSetOutput <= x"00000000";

	else
	    Overflow <= 'X';
	    Cout <= 'X';
	    Zero <= 'X';
	    sltSetOutput <= x"00000000";
	end if;
   end process;

   -- select for F
   g_muxF : mux32t1_dataflow
	port MAP(D0=> andOutput, --and, andi
		D1=> orOutput, -- or, ori
		D2=> addOutput, -- add, addi, addiu, addu, lw, sw
		D3=> xorOutput, -- xor, xori
		D4=> x"00000000", -- bgez, bgezal
		D5=> x"00000000", -- bgtz
		D6=> subOutput, -- sub, subu
		D7=> sltSetOutput, -- slt, slti
		D8=> sllOutput, -- sll
		D9=> srlOutput, -- srl
		D10=> sraOutput, -- sra
		D11=> x"00000000", -- blez
		D12=> norOutput, -- nor
		D13=> bOutput, -- beq
		D14=> bOutput, -- bne
		D15=> x"00000000", -- bltz, bltzal
	        D16 => luiOutput, -- lui
	        D17 => x"00000000",
	        D18 => x"00000000",
	        D19 => x"00000000",
	        D20 => x"00000000",
	        D21 => x"00000000",
	        D22 => x"00000000",
	        D23 => x"00000000",
	        D24 => x"00000000",
	        D25 => x"00000000",
	        D26 => x"00000000",
	        D27 => x"00000000",
	        D28 => x"00000000",
	        D29 => x"00000000",
	        D30 => x"00000000",
	        D31 => x"00000000",
		S=> ALUOP,
		Y => F);
end structure;