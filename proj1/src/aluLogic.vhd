------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- aluLogic.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aluLogic is
    port(   ALUOp                           : in std_logic_vector(3 downto 0);
            funct                           : in std_logic_vector(5 downto 0);
            ALUControl                      : out std_logic_vector(4 downto 0));
end aluLogic;

architecture alu of aluLogic is
signal aluCout : std_logic_vector(4 downto 0);
begin
    ALUControl <= aluCout;
    P_ALULOGIC : process (ALUOp, funct, aluCout)
    variable ALUC : std_logic_vector(4 downto 0);
    begin
	-- R-type
        if(ALUOp = "0000") then
	   -- add
	   if(funct = "100000") then
		ALUC := "00010";

	   -- addu
	   elsif (funct = "100001") then
		ALUC := "00010";

	   -- and
	   elsif (funct = "100100") then
		ALUC := "00000";

	   -- nor
	   elsif (funct = "100111") then
		ALUC := "01100";

	   -- xor
	   elsif (funct = "100110") then
		ALUC := "00011";

	   -- or
	   elsif (funct = "100101") then
		ALUC := "00001";

	   -- slt
	   elsif (funct = "101010") then
		ALUC := "00111";

	   -- sll
	   elsif (funct = "000000") then
		ALUC := "01000";

	   -- srl 
	   elsif (funct = "000010") then
		ALUC := "01001";

	   -- sra
	   elsif (funct = "000011") then
		ALUC := "01010";

	   -- sub 
	   elsif (funct = "100010") then
		ALUC := "00110";

	   -- subu
	   elsif (funct = "100011") then
		ALUC := "00110";

	   -- jr
	   elsif (funct = "001000") then
		ALUC := "11111";
	
	   else
		ALUC := "11111";

	   end if;

	-- lw, sw, addi, addiu
	elsif(ALUOP = "0001") then
	    ALUC := "00010";

	-- andi
        elsif(ALUOP = "0010") then  
	    ALUC := "00000";

	-- ori
        elsif(ALUOP = "0011") then  
	    ALUC := "00001";

	-- xori
        elsif(ALUOP = "0100") then
	    ALUC := "00011";

	-- bgez | bgezal
        elsif(ALUOP = "0101") then
	    ALUC := "00100";

	-- bgtz
        elsif(ALUOP = "0110") then
	    ALUC := "00101";

        -- blez
        elsif(ALUOP = "0111") then  
	    ALUC := "01011";

	-- beq
        elsif(ALUOP = "1000") then 
	    ALUC := "01101";  

	-- bne
        elsif(ALUOP = "1001") then 
	    ALUC := "01110"; 

	-- bltz | bltzal
        elsif(ALUOP = "1010") then 
	    ALUC := "01111";     

	-- slti
        elsif(ALUOP = "1011") then 
	    ALUC := "00111";     


	-- lui
        elsif(ALUOP = "1100") then 
	    ALUC := "10000";    

	else
	    ALUC := "11111"; 
      end if;
    aluCout <= ALUC;
    end process;
end alu;
