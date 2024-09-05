------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------


-- aluLogic_Test.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity aluLogic_Test is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end aluLogic_Test;

architecture mixed of aluLogic_Test is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component aluLogic is
    port(   ALUOp                           : in std_logic_vector(3 downto 0);
            funct                           : in std_logic_vector(5 downto 0);
            ALUControl                      : out std_logic_vector(4 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal s_funct: std_logic_vector(5 downto 0);
signal s_aluOp : std_logic_vector(3 downto 0);
signal s_ALUControl : std_logic_vector(4 downto 0);

-- TODO: change input and output signals as needed.

begin
 DUT0: aluLogic
  port map(ALUOp => s_aluOp,
	   funct => s_funct,
	   ALUControl => s_ALUControl);



 P_Test : process
 begin

  -- add
  s_aluOp <= "0000";
  s_funct <= "100000";
  wait for cCLK_PER; -- expected output: 00010

  -- addu
  s_aluOp <= "0000";
  s_funct <= "100001";
  wait for cCLK_PER; -- expected output: 00010

  -- and
  s_aluOp <= "0000";
  s_funct <= "100100";
  wait for cCLK_PER; -- expected output: 00000

  -- nor
  s_aluOp <= "0000";
  s_funct <= "100111";
  wait for cCLK_PER; -- expected output: 01100

  -- xor
  s_aluOp <= "0000";
  s_funct <= "100110";
  wait for cCLK_PER; -- expected output: 00011

  -- or
  s_aluOp <= "0000";
  s_funct <= "100101";
  wait for cCLK_PER; -- expected output: 00001

  -- slt
  s_aluOp <= "0000";
  s_funct <= "101010";
  wait for cCLK_PER; -- expected output: 00111

  -- sll
  s_aluOp <= "0000";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 01000

  -- srl
  s_aluOp <= "0000";
  s_funct <= "000010";
  wait for cCLK_PER; -- expected output: 01001

  -- sra
  s_aluOp <= "0000";
  s_funct <= "000011";
  wait for cCLK_PER; -- expected output: 01010

  -- sub
  s_aluOp <= "0000";
  s_funct <= "100010";
  wait for cCLK_PER; -- expected output: 00110

  -- subu
  s_aluOp <= "0000";
  s_funct <= "100011";
  wait for cCLK_PER; -- expected output: 00110

  -- jr
  s_aluOp <= "0000";
  s_funct <= "001000";
  wait for cCLK_PER; -- expected output: 00100

  -- lw, sw addi, addiu
  s_aluOp <= "0001";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 00010

  -- andi
  s_aluOp <= "0010";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 00000

  -- ori
  s_aluOp <= "0011";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 00001

  -- xori
  s_aluOp <= "0100";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 00111

  -- bgez | bgezal
  s_aluOp <= "0101";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 00100

  -- bgtz
  s_aluOp <= "0110";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 00101

  -- beq
  s_aluOp <= "1000";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 01101

  -- bne
  s_aluOp <= "1001";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 01110

  -- bltz | btzal
  s_aluOp <= "1010";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 01111

  -- slti
  s_aluOp <= "1011";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 00111

  -- lui
  s_aluOp <= "1100";
  s_funct <= "000000";
  wait for cCLK_PER; -- expected output: 10000
  
 end process;
end mixed;