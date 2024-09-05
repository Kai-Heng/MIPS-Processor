------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- regIFID.vhd


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity regIFID is
  port(CLK			: in std_logic;
       RST			: in std_logic;
       pcAdderOutputDataIn	: in std_logic_vector(31 downto 0);
       instIn			: in std_logic_vector(31 downto 0);
       pcAdderOutputDataOut	: out std_logic_vector(31 downto 0);
       instOut			: out std_logic_vector(31 downto 0));
end regIFID;

architecture structure of regIFID is
component dffg_N
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;       -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;

signal en			: std_logic := '1';

begin
  pcAdderOutputReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => pcAdderOutputDataIn,
		o_Q => pcAdderOutputDataOut);

  iMemOutputReg: dffg_N 
	port map(i_CLK => CLK,
		i_RST => RST,
		i_WE => en,
		i_D => instIn,
		o_Q => instOut);
end structure;





