------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- tb_alu.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_alu is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_alu;

architecture mixed of tb_alu is

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

  data0 <= x"00010000";
  data1 <= x"00001001";

  -- and, andi
  opcode <= "00000";
  wait for cCLK_PER; -- 0x00000000
  
  -- or, ori
  opcode <= "00001";
  wait for cCLK_PER; -- 0x00011001

  -- add, addi, addiu, addu, lw, sw
  opcode <= "00010";
  wait for cCLK_PER; -- 0x00011001

  -- xor, xori
  opcode <= "00011";
  wait for cCLK_PER; -- 0x00011001

  -- bgez, bgezal
  opcode <= "00100";
  wait for cCLK_PER; -- 0x00000001 | Zero: 1

  -- bgtz
  opcode <= "00101";
  wait for cCLK_PER; -- 0x00000001 | Zero: 1

  -- sub, subu
  opcode <= "00110";
  wait for cCLK_PER; -- 0x0000EFFF

  -- slt, slti
  opcode <= "00111";
  wait for cCLK_PER; -- 0x00000000

  -- sll
  opcode <= "01000";
  wait for cCLK_PER; -- 0x00001001

  -- srl
  opcode <= "01001";
  wait for cCLK_PER; -- 0x00001001

  -- sra
  opcode <= "01010";
  wait for cCLK_PER; -- 0x00001001

  -- blez
  opcode <= "01011";
  wait for cCLK_PER; -- 0x00000000 | Zero: 0

  -- nor
  opcode <= "01100";
  wait for cCLK_PER; -- 0xFFFEEFFE

  -- beq
  opcode <= "01101";
  wait for cCLK_PER; -- 0x0000EFFF | Zero: 0

  -- bne
  opcode <= "01110";
  wait for cCLK_PER; -- 0x0000EFFF | Zero: 1

  -- bltz, bltzal
  opcode <= "01111";
  wait for cCLK_PER; -- 0x00000000 | Zero: 0

  -- lui
  opcode <= "10000";
  wait for cCLK_PER; -- 0x10010000

  data0 <= x"FFFFFFFF";
  data1 <= x"00001FFF";

  -- and, andi
  opcode <= "00000";
  wait for cCLK_PER; -- 0x00001FFF
  
  -- or, ori
  opcode <= "00001";
  wait for cCLK_PER; -- 0xFFFFFFFF

  -- add, addi, addiu, addu, lw, sw
  opcode <= "00010";
  wait for cCLK_PER; -- 0x00001FFE

  -- xor, xori
  opcode <= "00011";
  wait for cCLK_PER; -- 0xFFFFE000

  -- bgez, bgezal
  opcode <= "00100";
  wait for cCLK_PER; -- 0x00000000 | Zero: 0

  -- bgtz
  opcode <= "00101";
  wait for cCLK_PER; -- 0x00000000 | Zero: 0

  -- sub, subu
  opcode <= "00110";
  wait for cCLK_PER; -- 0xFFFFE000

  -- slt, slti
  opcode <= "00111";
  wait for cCLK_PER; -- 0x00000001

  -- sll
  opcode <= "01000";
  wait for cCLK_PER; -- 0x80000000

  -- srl
  opcode <= "01001";
  wait for cCLK_PER; -- 0x00000000

  -- sra
  opcode <= "01010";
  wait for cCLK_PER; -- 0x00000000

  -- blez
  opcode <= "01011";
  wait for cCLK_PER; -- 0x00000001 | Zero: 1

  -- nor
  opcode <= "01100";
  wait for cCLK_PER; -- 0x00000000 | Zero: 0

  -- beq
  opcode <= "01101";
  wait for cCLK_PER; -- 0xFFFFE000 | Zero: 0

  -- bne
  opcode <= "01110";
  wait for cCLK_PER; -- 0xFFFFE000 | Zero: 1

  -- bltz, bltzal
  opcode <= "01111";
  wait for cCLK_PER; -- 0x00000001 | Zero: 0

  -- lui
  opcode <= "10000";
  wait for cCLK_PER; -- 0x1FFF0000
  
 end process;
end mixed;