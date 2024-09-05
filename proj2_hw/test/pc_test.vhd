------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--pc_test.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity pc_test is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end pc_test;

architecture mixed of pc_test is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component pc is
    port(
	CLK, RST : in std_logic;
	DATA : in std_logic_vector(31 downto 0);
	OUTPUT : out std_logic_vector(31 downto 0));

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal clk, reset : std_logic:= '0';
signal en : std_logic := '1';
signal d : std_logic_vector(31 downto 0);
signal Q : std_logic_vector(31 downto 0);

-- TODO: change input and output signals as needed.

begin
 DUT0: pc
  port map(
            CLK => clk,
	    RST => reset,
	    DATA => d,
	    OUTPUT => Q);

 P_CLK: process
  begin
    clk <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after a cycle
    clk <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

 P_test: process
  begin
  reset <= '1';
  wait for gCLK_HPER;
  reset <= '0';
  wait for gCLK_HPER;

  d <= x"00040004";
  wait for cCLK_PER;

  d <= x"00040008";
  wait for cCLK_PER;

  d <= x"0004000C";
  wait for cCLK_PER;

  d <= x"00040010";
  wait for cCLK_PER;

  reset <= '1';
  wait;
 end process;
end mixed;