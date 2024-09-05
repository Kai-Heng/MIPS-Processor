------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- regMEMWB.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity regMEMWB is
   port(CLK			: in std_logic;
        RST			: in std_logic;

	pcAdderOutputIn : in std_logic_vector(31 downto 0);
	jumpAddrIn : in std_logic_vector(31 downto 0);
	branchAddrIn : in std_logic_vector(31 downto 0);
	memReadDataIn : in std_logic_vector(31 downto 0);
	aluOutputIn : in std_logic_vector(31 downto 0);
	writeAddrIn : in std_logic_vector(4 downto 0);

	branchIsTrueIn : in std_logic;
	overflowIn : in std_logic;
	memtoRegIn : in std_logic_vector(1 downto 0);
	regWriteIn : in std_logic;
	jumpIn : in std_logic;
	haltIn : in std_logic;

	pcAdderOutputOut : out std_logic_vector(31 downto 0);
	jumpAddrOut : out std_logic_vector(31 downto 0);
	branchAddrOut : out std_logic_vector(31 downto 0);
	memReadDataOut : out std_logic_vector(31 downto 0);
	aluOutputOut : out std_logic_vector(31 downto 0);
	writeAddrOut : out std_logic_vector(4 downto 0);

	branchIsTrueOut : out std_logic;
	overflowOut : out std_logic;
	memtoRegOut : out std_logic_vector(1 downto 0);
	regWriteOut : out std_logic;
	jumpOut : out std_logic;
	haltOut : out std_logic);
end regMEMWB;

architecture structure of regMEMWB is
component dffg_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;

component dffg
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;

signal en		: std_logic := '1';

begin 

  pcAdderOutputReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => pcAdderOutputIn,
		o_Q => pcAdderOutputOut);

  jumpAddrReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => jumpAddrIn,
		o_Q => jumpAddrOut);

  branchAddrReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => branchAddrIn,
		o_Q => branchAddrOut);

  memReadDataReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => memReadDataIn,
		o_Q => memReadDataOut);

  aluOutputReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => aluOutputIn,
		o_Q => aluOutputOut);

  writeAddrReg: dffg_N 
	generic map(N => 5)
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => writeAddrIn,
		o_Q => writeAddrOut);

  branchIsTrueReg: dffg
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => branchIsTrueIn,
		o_Q => branchIsTrueOut);

  overflowReg: dffg
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => overflowIn,
		o_Q => overflowOut);

  memtoRegReg: dffg_N 
	generic map(N => 2)
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => memtoRegIn,
		o_Q => memtoRegOut);

  regWriteReg: dffg
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => regWriteIn,
		o_Q => regWriteOut);

  jumpReg: dffg
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => jumpIn,
		o_Q => jumpOut);

  haltReg: dffg
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => haltIn,
		o_Q => haltOut);


end structure;