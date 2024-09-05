-------------------------------------------------------------------------
-- Kai Heng Gan
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  component pc is
  	port(
		CLK, RST : in std_logic;
		DATA : in std_logic_vector(31 downto 0);
		OUTPUT : out std_logic_vector(31 downto 0));
  end component;

  component addSub_ALU is
  generic(N : integer := 32);
	port (D0, D1, I : in std_logic_vector(N-1 downto 0);
		n_Add_Sub : in std_logic;
		ALUSrc : in std_logic;
		Sum : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic);
  end component;

  component barrelShifter is
  port(
        DATA : in std_logic_vector(31 downto 0);
	shamt : in std_logic_vector(4 downto 0);
	DIR : in std_logic; -- 0: right 1: left
	MODE : in std_logic; -- 0: logical 1: arithmetic 
	OUTPUT : out std_logic_vector(31 downto 0));
  end component;

  component leftShifter is
  port(
        DATA : in std_logic_vector(25 downto 0);
	OUTPUT : out std_logic_vector(27 downto 0));
  end component;

  component mergeSignal is
  port(
        DATA0 : in std_logic_vector(27 downto 0);
	DATA1 : in std_logic_vector(3 downto 0);
	OUTPUT : out std_logic_vector(31 downto 0));
  end component;

  component controlLogic is
    port ( opcode : in  std_logic_vector (5 downto 0);
           RegDst : out std_logic_vector(1 downto 0);
           Jump : out std_logic;
	   Sign : out std_logic;
           Branch : out std_logic;
           Halt : out std_logic;
           MemtoReg : out std_logic_vector(1 downto 0);
           ALUOp : out std_logic_vector (3 downto 0);
           MemWrite : out std_logic;
           ALUSrc : out std_logic;
           RegWrite : out std_logic);
  end component;

  component mux2t1 is
	port (i_D0, i_D1 : in std_logic;
		i_S : 	in std_logic;
		o_O : out std_logic);
  end component;

  component mux2t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component mux2t1_5b is
  generic(N : integer := 5); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;
  
  component mux2t1_6b is
  generic(N : integer := 6); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component mux4t1_5b is
  port(S          : in std_logic_vector(1 downto 0);
       D0         : in std_logic_vector(4 downto 0);
       D1         : in std_logic_vector(4 downto 0);
       D2         : in std_logic_vector(4 downto 0);
       D3         : in std_logic_vector(4 downto 0);
       Y          : out std_logic_vector(4 downto 0));
  end component;

  component extender is
	port (
		input		: in std_logic_vector(15 downto 0);
		sign_zero	 : in std_logic;
		output		: out std_logic_vector(31 downto 0));
  end component;

  component registerFile is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(CLK,En,RST	  : in std_logic;
       rd         : in std_logic_vector(4 downto 0);
       S0         : in std_logic_vector(4 downto 0);
       S1         : in std_logic_vector(4 downto 0);
       D	  : in std_logic_vector(N-1 downto 0);
       rs          : out std_logic_vector(N-1 downto 0);
       rt	: out std_logic_vector(N-1 downto 0));
  end component;

  component aluLogic is
    port(   ALUOp                           : in std_logic_vector(3 downto 0);
            funct                           : in std_logic_vector(5 downto 0);
            ALUControl                      : out std_logic_vector(4 downto 0));
  end component;

  component ALU is
  generic(N : integer := 32);
	port (A, B : in std_logic_vector(N-1 downto 0);
		ALUOP : in std_logic_vector(4 downto 0);
		F : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic;
		Overflow : out std_logic;
		Zero : out std_logic);
  end component;

  component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component mux4t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic_vector(1 downto 0);
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       i_D2         : in std_logic_vector(N-1 downto 0);
       i_D3         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_RegRdData0   : std_logic_vector(N-1 downto 0);
  signal s_RegRdData1   : std_logic_vector(N-1 downto 0);

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  -- Control signals
  signal s_jump, s_branch, s_RegWr_Control, s_memRead, s_aluSrc, s_sign : std_logic;
  signal s_regDst, s_memToReg : std_logic_vector(1 downto 0);
  signal aluOp :std_logic_vector(3 downto 0);

  -- Sign Extender
  signal s_ExtOut : std_logic_vector(31 downto 0);

  -- ALU signals
  signal s_ALUIn1 : std_logic_vector(31 downto 0);
  signal s_Zero : std_logic;
  signal s_Cout : std_logic;
  signal s_ALUResult : std_logic_vector(31 downto 0);

  -- ALU Control signals
  signal aluC : std_logic_vector(4 downto 0);

  -- PC Adder signals
  signal s_pcAdderOutput : std_logic_vector(31 downto 0);
  signal s_pcAdderCout : std_logic;

  -- firstLeftShifter signals
  signal s_firstLeftShifterOuptut : std_logic_vector(27 downto 0);

  -- secondLeftShifter signals
  signal s_secondLeftShifterOuptut : std_logic_vector(31 downto 0);

  -- g_Merge signals
  signal s_jumpAddress : std_logic_vector(31 downto 0);

  -- addressAdder signal
  signal s_addressAdderOutput : std_logic_vector(31 downto 0);
  signal s_addressAdderCout : std_logic;

  -- g_and signal
  signal s_andOutput : std_logic;

  -- BranchMux signal
  signal s_branchMuxOutput : std_logic_vector(31 downto 0);

  --pcMUX
  signal s_pcMuxOutput : std_logic_vector(31 downto 0);

  --pcAdder_jal
  signal s_pcAdderjalOutput : std_logic_vector(31 downto 0);
  signal s_pcAdderjalCout : std_logic;

  --MemMux
  signal s_MemMuxOutput : std_logic_vector(31 downto 0);

  --shifterMux
  signal s_shifterMuxOutput : std_logic_vector(31 downto 0);
  signal s_shiftInst : std_logic := '0';

  --JrMux
  signal s_jrMuxOutput : std_logic_vector(31 downto 0);
  signal s_jumpReg : std_logic := '0';

  --controlLogicMux
  signal s_controlLogicMuxOutput : std_logic_vector(5 downto 0);
  signal s_opcode : std_logic;

  -- bgezal, bltzal, bltz
  signal s_mipsOpcode : std_logic_vector(5 downto 0);

  --BranchAlMux
  signal s_bal : std_logic;
  signal s_branchAlMuxOutput : std_logic_vector(31 downto 0);

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)

  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

  oALUOut<=s_ALUResult;

  g_PC : pc
  port map(CLK => iCLK,
	   RST => iRST,
	   DATA => s_jrMuxOutput,
	   OUTPUT => s_NextInstAddr);

  pcAdder : addSub_ALU
  port map(D0 => s_NextInstAddr,
	   D1 => x"00000004",
	   I => x"00000004",
	   n_Add_Sub => '0',
	   ALUSrc => '1',
	   Sum => s_pcAdderOutput,
	   Cout => s_pcAdderCout);

  firstLeftShifter : leftShifter
  port map(DATA => s_Inst(25 downto 0),
	   OUTPUT => s_firstLeftShifterOuptut);

  g_Merge : mergeSignal
  port map(DATA0 => s_firstLeftShifterOuptut,
	   DATA1 => s_pcAdderOutput(31 downto 28),
	   OUTPUT => s_jumpAddress);
  

  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);

  P_branchInst : process(s_opcode, s_mipsOpcode, s_Inst)
  begin
        -- bgezal
  	if(s_Inst(31 downto 26) = "000001" and s_Inst(20 downto 16) = "10001") then
		s_mipsOpcode <= "011101";
                s_opcode <= '1';

	--bgez
        elsif(s_Inst(31 downto 26) = "000001" and s_Inst(20 downto 16) = "00001") then
		s_mipsOpcode <= "011100";
                s_opcode <= '1';

	--bltzal
	elsif(s_Inst(31 downto 26) = "000001" and s_Inst(20 downto 16) = "10000") then
		s_mipsOpcode <= "011111";
                s_opcode <= '1';
	--bltz
        elsif(s_Inst(31 downto 26) = "000001" and s_Inst(20 downto 16) = "00000") then
		s_mipsOpcode <= "011110";
                s_opcode <= '1';
	else
		s_mipsOpcode <= "000000";
		s_opcode <= '0';
	end if;
  end process;

  controlLogicMux : mux2t1_6b
  port map(i_S => s_opcode,
	   i_D0 => s_Inst(31 downto 26),
	   i_D1 => s_mipsOpcode, 
	   o_o => s_controlLogicMuxOutput);

  Control : controlLogic
  port map(opcode => s_controlLogicMuxOutput,
	   RegDst => s_regDst,
	   Jump => s_jump,
	   Sign => s_sign,
	   --ShiftInst => s_shiftInst;
	   Branch => s_branch,
	   Halt => s_Halt,
	   MemtoReg => s_memToReg,
	   ALUOp => aluOp,
	   MemWrite => s_DMemWr,
	   ALUSrc => s_aluSrc,
	   RegWrite => s_RegWr_Control);

  Ext : extender
  port map(input => s_Inst(15 downto 0),
	   sign_zero => s_sign,
	   output => s_ExtOut);

  secondLeftShifter : barrelShifter
  port map(DATA => s_ExtOut,
	   shamt => "00010",
	   DIR => '1',
	   MODE => '0',
	   OUTPUT => s_secondLeftShifterOuptut);

  addressAdder : addSub_ALU
  port map(D0 => s_pcAdderOutput,
	   D1 => s_secondLeftShifterOuptut,
	   I => s_secondLeftShifterOuptut,
	   n_Add_Sub => '0',
	   ALUSrc => '0',
	   Sum => s_addressAdderOutput,
	   Cout => s_addressAdderCout);

  g_And : andg2
  port map(i_A => s_branch,
	   i_B => s_Zero,
	   o_F => s_andOutput);



  BranchMux : mux2t1_N
  port map(i_S => s_andOutput,
	   i_D0 => s_pcAdderOutput,
	   i_D1 => s_addressAdderOutput,
	   o_O => s_branchMuxOutput);

 P_ALinst : process(s_Inst, s_andOutput, s_RegWr, s_RegWr_Control)
 begin
        -- bgezal
  	if(s_Inst(31 downto 26) = "000001" and s_Inst(20 downto 16) = "10001" and s_andOutput = '0') then
               s_RegWr <= '0';

	--bltzal
	elsif(s_Inst(31 downto 26) = "000001" and s_Inst(20 downto 16) = "10000" and s_andOutput = '0') then
                s_RegWr <= '0';

	else
		s_RegWr <= s_RegWr_Control;
	end if;
  end process;

 -- BranchAlMux : mux2t1_N
 -- port map(i_S => s_bal,
--	   i_D0 => s_branchMuxOutput,
--	   i_D1 => s_addressAdderOutput,
--	   o_O => s_branchAlMuxOutput);

  PCMux : mux2t1_N
  port map(i_S => s_jump,
	   i_D0 => s_branchMuxOutput,
	   i_D1 => s_jumpAddress,
	   o_O => s_pcMuxOutput);

  P_JrInst : process(s_jumpReg, s_Inst)
  begin
  	if(s_Inst(31 downto 26) = "000000" and s_Inst(5 downto 0) = "001000") then
		s_jumpReg <= '1';
	
	else
		s_jumpReg <= '0';
	end if;
  end process;

  JrMux : mux2t1_N
  port map(i_S => s_jumpReg,
	   i_D0 => s_pcMuxOutput,
	   i_D1 => s_RegRdData0,
	   o_O => s_jrMuxOutput);

  WMux : mux4t1_5b
  port map(S => s_regDst,
	   D0 => s_Inst(20 downto 16),
	   D1 => s_Inst(15 downto 11),
	   D2 => "11111",
	   D3 => "00000",
	   Y => s_RegWrAddr);


  RegFile : registerFile
  port map(CLK => iCLK,
	   En => s_RegWr,
	   RST => iRST,
	   rd => s_RegWrAddr,
	   S0 => s_Inst(25 downto 21),
	   S1 => s_Inst(20 downto 16),
	   D => s_RegWrData,
	   rs => s_RegRdData0,
	   rt => s_RegRdData1);

 s_DMemData <= s_RegRdData1;

  P_ShiftInst : process(s_shiftInst, s_Inst)
  begin
  	if(s_Inst(31 downto 26) = "000000" and (s_Inst(5 downto 0) = "000000" or s_Inst(5 downto 0) = "000010" or s_Inst(5 downto 0) = "000011")) then
		s_shiftInst <= '1';
	else
		s_shiftInst <= '0';
	end if;
  end process;

  shifterMux : mux2t1_N
  port map(i_S => s_shiftInst,
	   i_D0 => s_RegRdData0,
	   i_D1 => s_ExtOut,
	   o_O => s_shifterMuxOutput);

  ALUMux : mux2t1_N
  port map(i_S => s_aluSrc,
	   i_D0 => s_RegRdData1,
	   i_D1 => s_ExtOut,
	   o_O => s_ALUIn1);

  ALUControl : alulogic
  port map (ALUOp => aluOp,
	    funct => s_Inst(5 downto 0),
	    ALUControl => aluC);

  g_ALU : ALU
  port map(A => s_shifterMuxOutput,
	   B => s_ALUIn1,
	   ALUOP => aluC,
	   F => s_ALUResult,
	   Cout => s_Cout,
	   Overflow => s_Ovfl,
	   Zero => s_Zero);

s_DMemAddr <= s_ALUResult;

  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);


  MemMux : mux4t1_N
  port map(i_S => s_memToReg,
	   i_D0 => s_ALUResult,
	   i_D1 => s_DMemOut,
	   i_D2 => s_pcAdderOutput,
	   i_D3 => x"00000000",
	   o_O => s_RegWrData);


  

end structure;

