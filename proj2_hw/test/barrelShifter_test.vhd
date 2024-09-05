------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--barrelShifter_test.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity barrelShifter_test is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end barrelShifter_test;

architecture mixed of barrelShifter_test is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component barrelShifter is
  port(
        DATA : in std_logic_vector(31 downto 0);
	shamt : in std_logic_vector(4 downto 0);
	DIR : in std_logic; -- 0: right 1: left
	MODE : in std_logic; -- 0: logical 1: arithmetic 
	OUTPUT : out std_logic_vector(31 downto 0));

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal clk : std_logic:= '0';
signal direction, mode : std_logic;
signal count : std_logic_vector(4 downto 0);
signal d : std_logic_vector(31 downto 0);
signal Q : std_logic_vector(31 downto 0);

-- TODO: change input and output signals as needed.

begin
 DUT0: barrelShifter
  port map(
	    DATA => d,
	    shamt => count,
	    DIR => direction,
	    MODE => mode,
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


  d <= x"11111111";
  count <= "00100";
  direction <= '1';
  mode <= '0';
  wait for cCLK_PER; -- expected output: 0x11111110

  d <= x"11111111";
  count <= "00100";
  direction <= '0';
  mode <= '0';
  wait for cCLK_PER; -- expected output: 0x01111111

  d <= x"FFFFFFF0";
  count <= "00100";
  direction <= '0';
  mode <= '1';
  wait for cCLK_PER; -- expected output: 0xFFFFFFFF

 end process;
end mixed;