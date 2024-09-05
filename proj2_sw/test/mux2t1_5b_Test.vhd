------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------


--mux2t1_5b_Test.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity mux2t1_5b_Test is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end mux2t1_5b_Test;

architecture mixed of mux2t1_5b_Test is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component mux2t1_5b is
  generic(N : integer := 5); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));


end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal d0,d1: std_logic_vector(4 downto 0);
signal clk : std_logic:= '0';
signal sel : std_logic;
signal output : std_logic_vector(4 downto 0);

-- TODO: change input and output signals as needed.

begin
 DUT0: mux2t1_5b
  port map(
            i_D0 => d0,
	    i_D1=>d1,
            i_S => sel,
	    o_O => output);

 P_CLK: process
  begin
    clk <= '1';         -- clock starts at 1
    wait for gCLK_HPER*2; -- after a cycle
    clk <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;
  
P_Test : process
  begin
  d0 <= "01110"; -- 0xE
  d1 <= "01111"; -- 0xF

  sel <= '1';
  wait for gCLK_HPER;
  --expected output: 0xF

  sel <= '0';
  wait for gCLK_HPER;
  --expected output: 0xE

end process;
  

end mixed;