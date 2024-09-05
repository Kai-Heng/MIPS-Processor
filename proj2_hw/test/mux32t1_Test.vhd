------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------


--mux32t1_Test.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity mux32t1_Test is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end mux32t1_Test;

architecture mixed of mux32t1_Test is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component mux32t1_dataflow is
	port(D0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D20,D21,D22,D23,D24,
	D25,D26,D27,D28,D29,D30,D31 : in std_logic_vector(31 downto 0);
	     S : in std_logic_vector(4 downto 0);
	     Y : out std_logic_vector(31 downto 0));

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,d31: std_logic_vector(31 downto 0);
signal clk : std_logic:= '0';
signal sel : std_logic_vector(4 downto 0);
signal output : std_logic_vector(31 downto 0);

-- TODO: change input and output signals as needed.

begin
 DUT0: mux32t1_dataflow
  port map(
            D0 => d0,
	    D1=>d1,
	    D2=>d2,
	    D3=>d3,
	    D4=>d4,
	    D5=>d5,
	    D6=>d6,
	    D7=>d7,
	    D8=>d8,
	    D9=>d9,
	    D10=>d10,
	    D11=>d11,
	    D12=>d12,
	    D13=>d13,
	    D14=>d14,
	    D15=>d15,
	    D16=>d16,
	    D17=>d17,
	    D18=>d18,
	    D19=>d19,
	    D20=>d20,
	    D21=>d21,
	    D22=>d22,
	    D23=>d23,
	    D24=>d24,
	    D25=>d25,
	    D26=>d26,
	    D27=>d27,
	    D28=>d28,
	    D29=>d29,
	    D30=>d30,
	    D31=>d31,
            S => sel,

	    Y => output);

 P_CLK: process
  begin
    clk <= '1';         -- clock starts at 1
    wait for gCLK_HPER*2; -- after a cycle
    clk <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;
  
P_Test : process
  begin
  d0 <= "01010001010001010101010010110001"; -- 0x514554B1
  d19 <= "01111000011101010101011110011110"; -- 0X7875579E
  d31 <= "10111010100010011110111111110010"; -- 0xBA89EFF2 
  d10 <= "11111110110000001001010001110011"; -- 0xFEC09473 
  d8 <= "00010001000100010001000100010001"; -- 0x11111111 
  d25 <= "11101110111011101110111011101110"; -- 0xEEEEEEEE 

  sel <= "11001";
  wait for gCLK_HPER;
  --expected output: 0xEEEEEEEE

  sel <= "00000";
  wait for gCLK_HPER;
  --expected output: 0x514554B1

  sel <= "11111";
  wait for gCLK_HPER;
  --expected output: 0xBA89EFF2

  sel <= "01010";
  wait for gCLK_HPER;
  --expected output: 0xFEC09473

end process;
  

end mixed;