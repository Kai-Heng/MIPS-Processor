------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- regEXMEM.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity regEXMEM is
   port(CLK			: in std_logic;
        RST			: in std_logic;
	instIn : in std_logic_vector(31 downto 0);
	pcAdderOutputIn : in std_logic_vector(31 downto 0);
	jumpAddrIn : in std_logic_vector(31 downto 0);
	branchAddrIn : in std_logic_vector(31 downto 0);
	rtDataIn : in std_logic_vector(31 downto 0);
	aluOutputIn : in std_logic_vector(31 downto 0);
	writeAddrIn : in std_logic_vector(4 downto 0);
	
	zeroIn : in std_logic;
	overflowIn : in std_logic;
	memtoRegIn : in std_logic_vector(1 downto 0);
	memWriteIn : in std_logic;
	regWriteIn : in std_logic;
	branchIn : in std_logic;
	jumpIn : in std_logic;
	haltIn : in std_logic;

	instOut : out std_logic_vector(31 downto 0);
	pcAdderOutputOut : out std_logic_vector(31 downto 0);
	jumpAddrOut : out std_logic_vector(31 downto 0);
	branchAddrOut : out std_logic_vector(31 downto 0);
	rtDataOut : out std_logic_vector(31 downto 0);
	aluOutputOut : out std_logic_vector(31 downto 0);
	writeAddrOut : out std_logic_vector(4 downto 0);
	
	zeroOut : out std_logic;
	overflowOut : out std_logic;
	memtoRegOut : out std_logic_vector(1 downto 0);
	memWriteOut : out std_logic;
	regWriteOut : out std_logic;
	branchOut : out std_logic;
	jumpOut : out std_logic;
	haltOut : out std_logic);

end regEXMEM;

architecture structural of regEXMEM is
component dffg_N
  generic(N : integer := 32);
  port(i_CLK          : in std_logic;     -- Clock input
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
  instOutReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => instIn,
		o_Q => instOut);

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

  rtDataReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => rtDataIn,
		o_Q => rtDataOut);

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

  zeroReg: dffg
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => zeroIn,
		o_Q => zeroOut);

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

  memWriteReg: dffg
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => memWriteIn,
		o_Q => memWriteOut);
  regWriteReg: dffg
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => regWriteIn,
		o_Q => regWriteOut);
  branchReg: dffg
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => branchIn,
		o_Q => branchOut);
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

end structural;








