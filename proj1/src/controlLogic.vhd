-- Created by
-- Brian McCreary
-- Iowa State University
-- Computer Engineering
-- Control Logic component

-- Corrected by
------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- controlLogic.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controlLogic is
    port ( opcode : in  std_logic_vector (5 downto 0);
           RegDst : out std_logic_vector (1 downto 0);
           Jump : out std_logic;
           Sign : out std_logic;
           Branch : out std_logic;
           Halt : out std_logic;
           MemtoReg : out std_logic_vector (1 downto 0);
           ALUOp : out std_logic_vector (3 downto 0);
           MemWrite : out std_logic;
           ALUSrc : out std_logic;
           RegWrite : out std_logic);
end controlLogic;

architecture behavioral of controlLogic is
begin
    P_CTRL : process (opcode)
    begin
        case opcode is
            when "000000" => -- R-type
                RegDst <= "01"; 
                Jump <= '0';
		Sign <= '0';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0000"; 
                MemWrite <= '0'; 
                ALUSrc <= '0'; 
                RegWrite <= '1';

            when "001000" => -- addi
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0001"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

            when "001001" => -- addiu
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0001"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

            when "001100" => -- andi
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '0';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0010"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

            when "001111" => -- lui
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '0';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "1100"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

            when "100011" => -- lw
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "01"; 
                ALUOp <= "0001"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

            when "001101" => -- ori
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '0';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0011"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

            when "001110" => -- xori
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '0';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0100"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

            when "001010" => -- slti
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "1011"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

            when "101011" => -- sw
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0001"; 
                MemWrite <= '1'; 
                ALUSrc <= '1'; 
                RegWrite <= '0';

            when "000100" => -- beq
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '1'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "1000"; 
                MemWrite <= '0'; 
                ALUSrc <= '0'; 
                RegWrite <= '0';

            when "000101" => -- bne
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '1'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "1001"; 
                MemWrite <= '0'; 
                ALUSrc <= '0'; 
                RegWrite <= '0';

            when "000010" => -- j
                RegDst <= "00"; 
                Jump <= '1'; 
		Sign <= '0';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "1111"; -- none
                MemWrite <= '0'; 
                ALUSrc <= '0'; 
                RegWrite <= '0';

            when "000011" => -- jal
                RegDst <= "10"; 
                Jump <= '1'; 
		Sign <= '0';
                Branch <= '0'; 
                Halt <= '0'; 
                MemtoReg <= "10"; 
                ALUOp <= "1111"; -- none
                MemWrite <= '0'; 
                ALUSrc <= '0'; 
                RegWrite <= '1';

            when "011100" => -- bgez (In MIPS 000001)
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '1'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0101"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '0';

            when "011101" => -- bgezal (In MIPS 000001)
                RegDst <= "10"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '1';
                Halt <= '0'; 
                MemtoReg <= "10"; 
                ALUOp <= "0101"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

            when "000111" => -- bgtz
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '1'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0110"; 
                MemWrite <= '0'; 
                ALUSrc <= '0'; 
                RegWrite <= '0';

            when "000110" => -- blez
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '1'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "0111"; 
                MemWrite <= '0'; 
                ALUSrc <= '0'; 
                RegWrite <= '0';

            when "011110" => -- bltz (In MIPS 000001)
                RegDst <= "00"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '1'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "1010"; 
                MemWrite <= '0'; 
                ALUSrc <= '0'; 
                RegWrite <= '0';

            when "011111" => -- bltzal (In MIPS 000001)
                RegDst <= "10"; 
                Jump <= '0'; 
		Sign <= '1';
                Branch <= '1'; 
                Halt <= '0'; 
                MemtoReg <= "10"; 
                ALUOp <= "1010"; 
                MemWrite <= '0'; 
                ALUSrc <= '1'; 
                RegWrite <= '1';

	   when "010100" => -- halt
		RegDst <= "00"; 
                Jump <= 'X'; 
		Sign <= 'X';
                Branch <= 'X'; 
                Halt <= '1'; 
                MemtoReg <= "00"; 
                ALUOp <= "1111"; 
                MemWrite <= 'X'; 
                ALUSrc <= 'X'; 
                RegWrite <= '0';

            when others =>
                RegDst <= "00"; 
                Jump <= 'X'; 
		Sign <= 'X';
                Branch <= 'X'; 
                Halt <= '0'; 
                MemtoReg <= "00"; 
                ALUOp <= "1111"; 
                MemWrite <= 'X'; 
                ALUSrc <= 'X'; 
                RegWrite <= 'X';
        end case;
    end process;
end behavioral;
               
