------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------


--controlLogic_Test.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity controlLogic_Test is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end controlLogic_Test;

architecture mixed of controlLogic_Test is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component controlLogic is
    port ( opcode : in  std_logic_vector (5 downto 0);
           RegDst : out std_logic;
           Jump : out std_logic;
           Branch : out std_logic;
           Halt : out std_logic;
           MemtoReg : out std_logic;
           ALUOp : out std_logic_vector (3 downto 0);
           MemWrite : out std_logic;
           ALUSrc : out std_logic;
           RegWrite : out std_logic); 
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal inst: std_logic_vector(5 downto 0);
signal s_regDst, s_jump, s_branch, s_halt, s_memToReg, s_memWrite, s_aluSrc, s_regWrite:std_logic;
signal s_aluOp : std_logic_vector(3 downto 0);

-- TODO: change input and output signals as needed.

begin
 DUT0: controlLogic
  port map(opcode => inst,
	   RegDst => s_regDst,
	   Jump => s_jump,
	   Branch => s_branch,
	   Halt => s_halt,
	   MemtoReg => s_memToReg,
	   ALUOp => s_aluOp,
	   MemWrite => s_memWrite,
	   ALUSrc => s_aluSrc,
	   RegWrite => s_regWrite);



 P_Test : process
 begin
  -- addi
  inst <= "001000";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0001
  -- s_DMemWr = 0
  -- ALUSrc = 1
  -- RegWrite = 1

  -- R-type
  inst <= "000000";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 1
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0000
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 1

  -- addiu
  inst <= "001001";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0001
  -- s_DMemWr = 0
  -- ALUSrc = 1
  -- RegWrite = 1

  -- andi
  inst <= "001100";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0010
  -- s_DMemWr = 0
  -- ALUSrc = 1
  -- RegWrite = 1

  -- lui
  inst <= "001111";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 1
  -- ALUControl = 0001
  -- s_DMemWr = 0
  -- ALUSrc = 1
  -- RegWrite = 1


  -- lw
  inst <= "100011";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 1
  -- ALUControl = 0001
  -- s_DMemWr = 0
  -- ALUSrc = 1
  -- RegWrite = 1

  -- xori
  inst <= "001110";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0100
  -- s_DMemWr = 0
  -- ALUSrc = 1
  -- RegWrite = 1


  -- ori
  inst <= "001101";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0011
  -- s_DMemWr = 0
  -- ALUSrc = 1
  -- RegWrite = 1

  -- slti
  inst <= "001010";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 1011
  -- s_DMemWr = 0
  -- ALUSrc = 1
  -- RegWrite = 1

  -- sw
  inst <= "101011";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0001
  -- s_DMemWr = 1
  -- ALUSrc = 1
  -- RegWrite = 0

  -- beq
  inst <= "000100";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 1
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 1000
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 0

  -- bne
  inst <= "000101";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 1
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 1001
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 0

  -- j
  inst <= "000010";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 1
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 1111
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 0

  -- jal
  inst <= "000011";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 1
  -- Branch = 0
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 1111
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 1

  -- bgez
  inst <= "011100";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 1
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0101
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 0

  -- bgezal
  inst <= "011101";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 1
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0101
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 1

  -- bgtz
  inst <= "000110";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 1
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0110
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 0

  -- blez
  inst <= "000111";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 1
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 0111
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 0

  -- bgez
  inst <= "011110";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 1
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 1010
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 0

  -- bgez
  inst <= "011111";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 1
  -- Halt = 0
  -- MemtoReg = 0
  -- ALUControl = 1010
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 1

  -- halt
  inst <= "010100";
  wait for cCLK_PER;
  -- expected output:
  -- RegDst = 0
  -- Jump = 0
  -- Branch = 0
  -- Halt = 1
  -- MemtoReg = 0
  -- ALUControl = 1111
  -- s_DMemWr = 0
  -- ALUSrc = 0
  -- RegWrite = 0
 end process;
end mixed;