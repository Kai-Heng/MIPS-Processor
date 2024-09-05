------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--mergeSignal_test.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity mergeSignal_test is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end mergeSignal_test;

architecture mixed of mergeSignal_test is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component mergeSignal is
  port(
        DATA0 : in std_logic_vector(27 downto 0);
	DATA1 : in std_logic_vector(3 downto 0);
	OUTPUT : out std_logic_vector(31 downto 0));

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal clk : std_logic:= '0';
signal d0 : std_logic_vector(27 downto 0);
signal d1 : std_logic_vector(3 downto 0);
signal Q : std_logic_vector(31 downto 0);

-- TODO: change input and output signals as needed.

begin
 DUT0: mergeSignal
  port map(
	    DATA0 => d0,
	    DATA1 => d1,
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


  d0 <= "0000000000000000000000001100";
  d1 <= "1111";
  wait for cCLK_PER; -- expected output: 11110000000000000000000000001100

  d0 <= "0000000000000000000000110000";
  d1 <= "0011";
  wait for cCLK_PER; -- expected output: 00110000000000000000000000110000

 end process;
end mixed;