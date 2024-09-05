------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- regIDEX.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity regIDEX is
   port(CLK			: in std_logic;
        RST			: in std_logic;
	instIn : in std_logic_vector(31 downto 0);
        pcAdderOutputIn		: in std_logic_vector(31 downto 0);
        jumpAddressIn	: in std_logic_vector(31 downto 0);
        rsDataIn		: in std_logic_vector(31 downto 0);
        rtDataIn		: in std_logic_vector(31 downto 0);
        extOutputIn		: in std_logic_vector(31 downto 0);
        writeAddrIn		: in std_logic_vector(4 downto 0);
        regDstIn : in std_logic_vector(1 downto 0);
	jumpIn : in std_logic;
	signIn : in std_logic;
	branchIn : in std_logic;
	haltIn : in std_logic;
	memtoRegIn : in std_logic_vector(1 downto 0);
	ALUOpIn : in std_logic_vector(3 downto 0);
	memWriteIn : in std_logic;
	ALUSrcIn : in std_logic;
	regWriteIn : in std_logic;
	instOut : out std_logic_vector(31 downto 0);
        pcAdderOutputOut	: out std_logic_vector(31 downto 0);
        jumpAddressOut	: out std_logic_vector(31 downto 0);
        rsDataOut		: out std_logic_vector(31 downto 0);
        rtDataOut		: out std_logic_vector(31 downto 0);
        extOutputOut		: out std_logic_vector(31 downto 0);
        writeAddrOut		: out std_logic_vector(4 downto 0);
        regDstOut : out std_logic_vector(1 downto 0);
	jumpOut : out std_logic;
	signOut : out std_logic;
	branchOut : out std_logic;
	haltOut : out std_logic;
	memtoRegOut : out std_logic_vector(1 downto 0);
	ALUOpOut : out std_logic_vector(3 downto 0);
	memWriteOut : out std_logic;
	ALUSrcOut : out std_logic;
	regWriteOut : out std_logic);
end regIDEX;

architecture structure of regIDEX is
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

signal en : std_logic := '1';

begin 
  instReg: dffg_N
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

  jumpAddressReg: dffg_N
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => jumpAddressIn,
		o_Q => jumpAddressOut);

  rsDataReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => rsDataIn,
		o_Q => rsDataOut);

  rtDataReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => rtDataIn,
		o_Q => rtDataOut);

  extOutputReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => extOutputIn,
		o_Q => extOutputOut);

  writeAddrReg: dffg_N
	generic map(N => 5)
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => writeAddrIn,
		o_Q => writeAddrOut);

  regDstReg: dffg_N
	generic map(N => 2)
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => regDstIn,
		o_Q => regDstOut);

  jumpReg: dffg 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => jumpIn,
		o_Q => jumpOut);

  signReg: dffg 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => signIn,
		o_Q => signOut);

  branchReg: dffg 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => branchIn,
		o_Q => branchOut);

  haltReg: dffg 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => haltIn,
		o_Q => haltOut);

  memtoRegReg: dffg_N
	generic map(N => 2)
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => memtoRegIn,
		o_Q => memtoRegOut);

  ALUOpReg: dffg_N 
	generic map(N => 4)
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => ALUOpIn,
		o_Q => ALUOpOut);

  memWriteReg: dffg 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => memWriteIn,
		o_Q => memWriteOut);

  ALUSrcReg: dffg 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => ALUSrcIn,
		o_Q => ALUSrcOut);

  regWriteReg: dffg 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => regWriteIn,
		o_Q => regWriteOut);

end structure;