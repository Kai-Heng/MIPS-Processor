------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- ALU_Test.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity ALU_Test is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end ALU_Test;

architecture mixed of ALU_Test is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.


component ALU is
  generic(N : integer := 32);
	port (A, B : in std_logic_vector(N-1 downto 0);
		ALUOP : in std_logic_vector(4 downto 0);
		F : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic;
		Overflow : out std_logic;
		Zero : out std_logic);

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero


-- TODO: change input and output signals as needed.
signal c, o, z : std_logic;
signal opcode : std_logic_vector(4 downto 0);
signal data0, data1, result : std_logic_vector(31 downto 0);

begin
 G_ALU: ALU
  port map(
            A => data0,
	    B => data1,
	    ALUOP => opcode,
	    F => result,
	    Cout => c,
	    Overflow => o,
	    Zero => z);


 P_test: process
  begin

  -- and
  data0 <= x"00010000";
  data1 <= x"00010001";
  opcode <= "00000";
  wait for cCLK_PER; -- 0x00010000

  -- or
  data0 <= x"7FFF0000";
  data1 <= x"0000FFFF";
  opcode <= "00001";
  wait for cCLK_PER; -- 0x00010001

  -- add
  data0 <= x"00000000";
  data1 <= x"FFFFFFF6";
  opcode <= "00010";
  wait for cCLK_PER; -- 0x00020002

  -- xor
  data0 <= x"00010000";
  data1 <= x"00010001";
  opcode <= "00011";
  wait for cCLK_PER; -- 0x00000001

  -- bgez
  data0 <= x"00010000";
  data1 <= x"00010001";
  opcode <= "00100";
  wait for cCLK_PER; -- 0x00000001 | Zero: 1

  -- bgtz
  data0 <= x"00010000";
  data1 <= x"00010001";
  opcode <= "00101";
  wait for cCLK_PER; -- 0x00000001 | Zero: 1

  -- sub
  data0 <= x"00010001";
  data1 <= x"00010001";
  opcode <= "00110";
  wait for cCLK_PER; -- 0x00000000


  -- slt
  data0 <= x"00010000";
  data1 <= x"00010001";
  opcode <= "00111";
  wait for cCLK_PER; -- 0x00000001 | Zero: 1	

  -- sll
  data0 <= x"11111111";
  data1 <= x"00000100";
  opcode <= "01000";
  wait for cCLK_PER; -- 0x11111110

  -- srl
  data0 <= x"11111111";
  data1 <= x"00000100";
  opcode <= "01001";
  wait for cCLK_PER; -- 0x01111111

  -- sra
  data0 <= x"FFFFFFF0";
  data1 <= x"00000100";
  opcode <= "01010";
  wait for cCLK_PER; -- 0xFFFFFFFF

  -- blez
  data0 <= x"F0010000";
  data1 <= x"00010001";
  opcode <= "01011";
  wait for cCLK_PER; -- 0x00000001 | Zero: 1

  -- nor
  data0 <= x"00010000";
  data1 <= x"00010001";
  opcode <= "01100";
  wait for cCLK_PER; -- 0xFFFEFFFE

  -- beq
  data0 <= x"7FFFFFFF";
  data1 <= x"FFFFFFF6";
  opcode <= "01101";
  wait for cCLK_PER; -- 0x00000000 | Zero: 0

  -- bne
  data0 <= x"00010000";
  data1 <= x"00010001";
  opcode <= "01110";
  wait for cCLK_PER; -- 0x00000001 | Zero: 1

  -- blt
  data0 <= x"00010000";
  data1 <= x"00010001";
  opcode <= "01111";
  wait for cCLK_PER; -- 0x00000000 | Zero: 0
 end process;
end mixed;
