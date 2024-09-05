------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

------- addSubTest.vhd -------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity addSubTest is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end addSubTest;

architecture mixed of addSubTest is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component addSub_N is
	generic(N : integer := 32);
	port (D0, D1 : in std_logic_vector(N-1 downto 0);
		n_Add_Sub : in std_logic;
		Sum : 	out std_logic_vector(N-1 downto 0);
		Cout : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal data0, data1 : std_logic_vector(31 downto 0);
signal carryI : std_logic := '0';
signal carryO : std_logic := '0';
signal sumO : std_logic_vector(31 downto 0);

-- TODO: change input and output signals as needed.

begin
 DUT0: addSub_N
  port map(
            n_Add_Sub     => carryI,
            D0       => data0,
            D1       => data1,
	    Sum	=> sumO,
	    Cout => carryO);

---- Test Case 1 ----
 -- carryI <= '0'; -- 0x00000001
 -- data0 <= "01010001010001010101010010110001"; -- 0x514554B1
 -- data1 <= "01111000011101010101011110011110"; -- 0X7875579E
  -- Expected output: 0xC9BAAC50 | Carry-Out bit: 0

---- Test Case 2 ----
 -- carryI <= '1';
 -- data0 <= "10111010100010011110111111110010"; -- 0xBA89EFF2 
 -- data1 <= "11111110110000001001010001110011"; -- 0xFEC09473 
  -- Expected output: 0xBBC95B7F | Carry-Out bit: 0

---- Test Case 3 ----
  carryI <= '1'; -- 0x00000001
  data0 <= "11101110111011101110111011101110"; -- 0xEEEEEEEE 
  data1 <= "00010001000100010001000100010001"; -- 0x11111111 
  -- Expected output: 0xDDDDDDDD | Carry-Out bit: 1
end mixed;