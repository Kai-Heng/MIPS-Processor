------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- pipelineDesignProcessor.vhd

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

end MIPS_Processor;


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

  component dffg_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
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

  component regIFID is 
  port(CLK			: in std_logic;
       RST			: in std_logic;
       pcAdderOutputDataIn	: in std_logic_vector(31 downto 0);
       instIn			: in std_logic_vector(31 downto 0);
       pcAdderOutputDataOut	: out std_logic_vector(31 downto 0);
       instOut			: out std_logic_vector(31 downto 0));
  end component;

  component regIDEX is
   port(CLK			: in std_logic;
        RST			: in std_logic;
	instIn : in std_logic_vector(31 downto 0);
        pcAdderOutputIn		: in std_logic_vector(31 downto 0);
        jumpAddressIn	: in std_logic_vector(31 downto 0);
        rsDataIn		: in std_logic_vector(31 downto 0);
        rtDataIn		: in std_logic_vector(31 downto 0);
        extOutputIn		: in std_logic_vector(31 downto 0);
        writeAddrIn		: in std_logic_vector(4 downto 0);
        regDstIn : in std_logic_vector(1 downto 0);
	jumpIn : in std_logic;
	signIn : in std_logic;
	branchIn : in std_logic;
	haltIn : in std_logic;
	memtoRegIn : in std_logic_vector(1 downto 0);
	ALUOpIn : in std_logic_vector(3 downto 0);
	memWriteIn : in std_logic;
	ALUSrcIn : in std_logic;
	regWriteIn : in std_logic;
	instOut : out std_logic_vector(31 downto 0);
        pcAdderOutputOut	: out std_logic_vector(31 downto 0);
        jumpAddressOut	: out std_logic_vector(31 downto 0);
        rsDataOut		: out std_logic_vector(31 downto 0);
        rtDataOut		: out std_logic_vector(31 downto 0);
        extOutputOut		: out std_logic_vector(31 downto 0);
        writeAddrOut		: out std_logic_vector(4 downto 0);
        regDstOut : out std_logic_vector(1 downto 0);
	jumpOut : out std_logic;
	signOut : out std_logic;
	branchOut : out std_logic;
	haltOut : out std_logic;
	memtoRegOut : out std_logic_vector(1 downto 0);
	ALUOpOut : out std_logic_vector(3 downto 0);
	memWriteOut : out std_logic;
	ALUSrcOut : out std_logic;
	regWriteOut : out std_logic);
  end component;

  component regMEMWB is
   port(CLK			: in std_logic;
        RST			: in std_logic;
	pcAdderOutputIn : in std_logic_vector(31 downto 0);
	jumpAddrIn : in std_logic_vector(31 downto 0);
	branchAddrIn : in std_logic_vector(31 downto 0);
	memReadDataIn : in std_logic_vector(31 downto 0);
	aluOutputIn : in std_logic_vector(31 downto 0);
	writeAddrIn : in std_logic_vector(4 downto 0);

	branchIsTrueIn : in std_logic;
	overflowIn : in std_logic;
	memtoRegIn : in std_logic_vector(1 downto 0);
	regWriteIn : in std_logic;
	jumpIn : in std_logic;
	haltIn : in std_logic;

	pcAdderOutputOut : out std_logic_vector(31 downto 0);
	jumpAddrOut : out std_logic_vector(31 downto 0);
	branchAddrOut : out std_logic_vector(31 downto 0);
	memReadDataOut : out std_logic_vector(31 downto 0);
	aluOutputOut : out std_logic_vector(31 downto 0);
	writeAddrOut : out std_logic_vector(4 downto 0);

	branchIsTrueOut : out std_logic;
	overflowOut : out std_logic;
	memtoRegOut : out std_logic_vector(1 downto 0);
	regWriteOut : out std_logic;
	jumpOut : out std_logic;
	haltOut : out std_logic);
  end component;

  component regEXMEM is 
   port(CLK			: in std_logic;
        RST			: in std_logic;
	instIn : in std_logic_vector(31 downto 0);
	pcAdderOutputIn : in std_logic_vector(31 downto 0);
	jumpAddrIn : in std_logic_vector(31 downto 0);
	branchAddrIn : in std_logic_vector(31 downto 0);
	rtDataIn : in std_logic_vector(31 downto 0);
	aluOutputIn : in std_logic_vector(31 downto 0);
	writeAddrIn : in std_logic_vector(4 downto 0);
	
	zeroIn : in std_logic;
	overflowIn : in std_logic;
	memtoRegIn : in std_logic_vector(1 downto 0);
	memWriteIn : in std_logic;
	regWriteIn : in std_logic;
	branchIn : in std_logic;
	jumpIn : in std_logic;
	haltIn : in std_logic;

	instOut : out std_logic_vector(31 downto 0);
	pcAdderOutputOut : out std_logic_vector(31 downto 0);
	jumpAddrOut : out std_logic_vector(31 downto 0);
	branchAddrOut : out std_logic_vector(31 downto 0);
	rtDataOut : out std_logic_vector(31 downto 0);
	aluOutputOut : out std_logic_vector(31 downto 0);
	writeAddrOut : out std_logic_vector(4 downto 0);
	
	zeroOut : out std_logic;
	overflowOut : out std_logic;
	memtoRegOut : out std_logic_vector(1 downto 0);
	memWriteOut : out std_logic;
	regWriteOut : out std_logic;
	branchOut : out std_logic;
	jumpOut : out std_logic;
	haltOut : out std_logic);
  end component;

  component hazardDetector is
  port( i_jump_ID          : in std_logic; 
        i_jump_EX          : in std_logic;
        i_jump_MEM         : in std_logic;
        i_jump_WB          : in std_logic;
        i_branch_ID        : in std_logic;
        i_branch_EX        : in std_logic;
        i_branch_MEM       : in std_logic;
        i_branch_WB        : in std_logic;

        i_readAddr1  	  	: in std_logic_vector(4 downto 0); 
        i_readAddr2	  	    : in std_logic_vector(4 downto 0);
        i_writeAddr_ID      : in std_logic_vector(4 downto 0);
        i_writeAddr_EX      : in std_logic_vector(4 downto 0); 
        i_writeEnable_ID    : in std_logic;
        i_writeEnable_EX    : in std_logic;

        o_stall    		: out std_logic); 
  end component;

  component forwarder is
	port(i_readAddr1  	  	: in std_logic_vector(4 downto 0);
	     i_readAddr2	  	: in std_logic_vector(4 downto 0);
	     i_writeAddr	  	: in std_logic_vector(4 downto 0);
             i_writeEnable      	: in std_logic;
             o_fwdSwitch1		: out std_logic; 
             o_fwdSwitch2		: out std_logic);
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
  signal s_jump,s_finalJump, s_branch, s_memRead, s_aluSrc, s_sign, s_halt_ID : std_logic;
  signal s_DMemWr_ID, s_RegWr_ID : std_logic;
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

  --alDataWriteBackMux
  signal s_alDataWriteBackMuxOutput : std_logic;
  signal s_regEnable : std_logic;

  -- g_PC
  signal s_pcEnable : std_logic;

  -- PipelineIFID
  signal s_pcAdderOutputIFID : std_logic_vector(31 downto 0);
  signal s_instIFID : std_logic_vector(31 downto 0);


  -- hazardDetectUnit
  signal s_stall : std_logic;

  -- stallMux1 & stallMux2
  signal s_stallMux1Output : std_logic_vector(31 downto 0);
  signal s_stallMux2Output : std_logic_vector(31 downto 0);

  -- ForwardingUnit
  signal s_forwardMux1, s_forwardMux2 : std_logic;

  -- RegFile
  signal s_rsData, s_rtData : std_logic_vector(31 downto 0);

  -- forwardMux1 & forwardMux2
  signal s_forwardMux1_ID, s_forwardMux2_ID : std_logic_vector(31 downto 0);

  -- WMUX
  signal s_RegWrAddr_ID : std_logic_vector(4 downto 0);

  -- PipelineIDEX
  signal s_instIDEX,s_pcAdderOutputOutIDEX, s_jumpAddressOutIDEX, s_rsDataOutIDEX, s_rtDataOutIDEX, s_extOutputOutIDEX : std_logic_vector(31 downto 0);
  signal s_wrtieAddrOutIDEX : std_logic_vector(4 downto 0);
  signal s_ALUOpOutIDEX : std_logic_vector(3 downto 0);
  signal s_regDstOutIDEX, s_memtoRegOutIDEX : std_logic_vector(1 downto 0);
  signal s_jumpOutIDEX, s_signOutIDEX, s_branchOutIDEX, s_haltOutIDEX, s_memWriteOutIDEX, s_ALUSrcOutIDEX, s_regWriteOutIDEX : std_logic;

  -- JrMux
  signal s_jumpAddress_EX : std_logic_vector(31 downto 0);

  -- addressAdder
  signal s_addressAdderOutput_EX : std_logic_vector(31 downto 0);

  -- ALU
  signal s_aluOutput_EX : std_logic_vector(31 downto 0);
  signal s_aluCout_EX, s_overflow_EX, s_zero_EX : std_logic;

  -- PipelineEXMEM
  
  signal s_pcAdderOutputOutEXMEM, s_jumpAddrOutEXMEM, s_branchAddrOutEXMEM, s_rtDataOutEXMEM, s_aluOutputOutEXMEM,s_instEXMEM  : std_logic_vector(31 downto 0);
  signal s_writeAddrOutEXMEM : std_logic_vector(4 downto 0);
  signal s_memtoRegOutEXMEM : std_logic_vector(1 downto 0);
  signal s_zeroOutEXMEM,s_overflowOutEXMEM,s_memWriteOutEXMEM,s_regWriteOutEXMEM,s_branchOutEXMEM,s_jumpOutEXMEM,s_haltOutEXMEM, s_RegWr_MEM : std_logic;
  
  -- PipelineMEMWB
  signal s_pcAdderOutputOutMEMWB, s_jumpAddrOutMEMWB, s_branchAddrOutMEMWB, s_memReadDataOutMEMWB, s_aluOutputOutMEMWB  : std_logic_vector(31 downto 0);
  signal s_writeAddrOutMEMWB : std_logic_vector(4 downto 0);
  signal s_memtoRegOutMEMWB : std_logic_vector(1 downto 0);
  signal s_branchIsTrueOutMEMWB,s_overflowOutMEMWB,s_regWriteOutMEMWB,s_jumpOutMEMWB,s_haltOutMEMWB : std_logic;


begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)

  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

  

  ------ Fetch Stage ------

  g_PC : pc
  port map(CLK => iCLK,
	   RST => iRST,
	   DATA => s_pcMuxOutput,
	   OUTPUT => s_NextInstAddr);

  pcAdder : addSub_ALU
  port map(D0 => s_NextInstAddr,
	   D1 => x"00000004",
	   I => x"00000004",
	   n_Add_Sub => '0',
	   ALUSrc => '1',
	   Sum => s_pcAdderOutput,
	   Cout => s_pcAdderCout);

  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);

  hazardDetectUnit : hazardDetector
  port map(i_jump_ID => s_finalJump,
           i_jump_EX => s_jumpOutIDEX,
           i_jump_MEM => s_jumpOutEXMEM,
           i_jump_WB => s_jumpOutMEMWB,
           i_branch_ID => s_branch,
           i_branch_EX => s_branchOutIDEX,
           i_branch_MEM => s_branchOutEXMEM,
           i_branch_WB => s_branchIsTrueOutMEMWB,
           i_readAddr1 => s_Inst(25 downto 21),
           i_readAddr2 => s_Inst(20 downto 16),
           i_writeAddr_ID => s_RegWrAddr_ID,
           i_writeAddr_EX => s_wrtieAddrOutIDEX,
           i_writeEnable_ID => s_RegWr_ID,
           i_writeEnable_ex => s_regWriteOutIDEX,
           o_stall => s_stall);


  stallMux1 : mux2t1_N
  port map(i_S => s_stall,
	   i_D0 => s_pcAdderOutput,
	   i_D1 => s_IMemAddr,
	   o_O => s_stallMux1Output);

  stallMux2 : mux2t1_N
  port map(i_S => s_stall,
	   i_D0 => s_Inst,
	   i_D1 => x"00000000",
	   o_O => s_stallMux2Output);

  
  ------- IF/ID Pipeline --------
  PipelineIFID : regIFID
  port map(CLK => iCLK,
	   RST => iRST,
	   pcAdderOutputDataIn => s_pcAdderOutput,
	   instIn => s_stallMux2Output,
	   pcAdderOutputDataOut => s_pcAdderOutputIFID,
	   instOut => s_instIFID);
   
  -------- Decoder Stage -----------
  -- Fetch Stage other components 
  firstLeftShifter : leftShifter
  port map(DATA => s_instIFID(25 downto 0),
	   OUTPUT => s_firstLeftShifterOuptut);

  g_Merge : mergeSignal
  port map(DATA0 => s_firstLeftShifterOuptut,
	   DATA1 => s_pcAdderOutputIFID(31 downto 28),
	   OUTPUT => s_jumpAddress);

  process(s_opcode, s_mipsOpcode, s_instIFID) is
  begin
        -- bgezal
  	if(s_instIFID(31 downto 26) = "000001" and s_instIFID(20 downto 16) = "10001") then
		s_mipsOpcode <= "011101";
                s_opcode <= '1';

	--bgez
        elsif(s_instIFID(31 downto 26) = "000001" and s_instIFID(20 downto 16) = "00001") then
		s_mipsOpcode <= "011100";
                s_opcode <= '1';

	--bltzal
	elsif(s_instIFID(31 downto 26) = "000001" and s_instIFID(20 downto 16) = "10000") then
		s_mipsOpcode <= "011111";
                s_opcode <= '1';
	--bltz
        elsif(s_instIFID(31 downto 26) = "000001" and s_instIFID(20 downto 16) = "00000") then
		s_mipsOpcode <= "011110";
                s_opcode <= '1';
	else
		s_mipsOpcode <= "000000";
		s_opcode <= '0';
	end if;
  end process;
  
  controlLogicMux : mux2t1_6b
  port map(i_S => s_opcode,
	   i_D0 => s_instIFID(31 downto 26),
	   i_D1 => s_mipsOpcode, 
	   o_o => s_controlLogicMuxOutput);



  Control : controlLogic
  port map(opcode => s_controlLogicMuxOutput,
	   RegDst => s_regDst,
	   Jump => s_jump,
	   Sign => s_sign,
	   Branch => s_branch,
	   Halt => s_halt_ID,
	   MemtoReg => s_memToReg,
	   ALUOp => aluOp,
	   MemWrite => s_DMemWr_ID,
	   ALUSrc => s_aluSrc,
	   RegWrite => s_RegWr_ID);

  process(s_finalJump, s_jump, s_instIFID) is
  begin
  	if(s_instIFID(31 downto 26) = "000000" and s_instIFID(5 downto 0) = "001000") then
		s_finalJump <= '1';
	else
		s_finalJump <= s_jump;
	end if;
  end process;

  ForwardingUnit : forwarder
  port map(i_readAddr1 => s_instIFID(25 downto 21),
	   i_readAddr2 => s_instIFID(20 downto 16),
	   i_writeAddr => s_RegWrAddr,
	   i_writeEnable => s_RegWr,
	   o_fwdSwitch1 => s_forwardMux1,
	   o_fwdSwitch2 => s_forwardMux2);


  RegFile : registerFile
  port map(CLK => iCLK,
	   En => s_RegWr,
	   RST => iRST,
	   rd => s_RegWrAddr,
	   S0 => s_instIFID(25 downto 21),
	   S1 => s_instIFID(20 downto 16),
	   D => s_RegWrData,
	   rs => s_RegRdData0,
	   rt => s_RegRdData1);

  forwardMux1 : mux2t1_N
  port map(i_S => s_forwardMux1,
	   i_D0 => s_RegRdData0,
	   i_D1 => s_RegWrData,
	   o_O => s_forwardMux1_ID);

  forwardMux2 : mux2t1_N
  port map(i_S => s_forwardMux2,
	   i_D0 => s_RegRdData1,
	   i_D1 => s_RegWrData,
	   o_O => s_forwardMux2_ID);

  Ext : extender
  port map(input => s_instIFID(15 downto 0),
	   sign_zero => s_sign,
	   output => s_ExtOut);

  WMux : mux4t1_5b
  port map(S => s_regDst,
	   D0 => s_instIFID(20 downto 16),
	   D1 => s_instIFID(15 downto 11),
	   D2 => "11111",
	   D3 => "00000",
	   Y => s_RegWrAddr_ID);



  ------ Pipeline ID/EX -------
  PipelineIDEX : regIDEX
  port map(CLK => iCLK,
	   RST => iRST,
	   instIn => s_instIFID,
	   pcAdderOutputIn => s_pcAdderOutputIFID,
	   jumpAddressIn => s_jumpAddress,
	   rsDataIn => s_forwardMux1_ID,
	   rtDataIn => s_forwardMux2_ID,
	   extOutputIn => s_ExtOut,
	   writeAddrIn => s_RegWrAddr_ID,
	   regDstIn => s_regDst,
	   jumpIn => s_finalJump,
	   signIn => s_sign,
	   branchIn => s_branch,
	   haltIn => s_halt_ID,
	   memtoRegIn => s_memToReg,
	   ALUOpIn => aluop,
	   memWriteIn => s_DMemWr_ID,
	   ALUSrcIn => s_aluSrc,
	   regWriteIn => s_RegWr_ID,
	   instOut => s_instIDEX,
	   pcAdderOutputOut => s_pcAdderOutputOutIDEX,
	   jumpAddressOut => s_jumpAddressOutIDEX, 
	   rsDataOut => s_rsDataOutIDEX,
	   rtDataOut => s_rtDataOutIDEX,
	   extOutputOut => s_extOutputOutIDEX,
	   writeAddrOut => s_wrtieAddrOutIDEX,
	   regDstOut => s_regDstOutIDEX,
	   jumpOut => s_jumpOutIDEX,
	   signOut => s_signOutIDEX,
	   branchOut => s_branchOutIDEX,
	   haltOut => s_haltOutIDEX,
	   memtoRegOut => s_memtoRegOutIDEX,
	   ALUOpOut => s_ALUOpOutIDEX,
	   memWriteOut => s_memWriteOutIDEX,
	   ALUSrcOut => s_ALUSrcOutIDEX,
	   regWriteOut => s_regWriteOutIDEX);

  process(s_jumpReg, s_jump, s_instIDEX) is
  begin
  	if(s_instIDEX(31 downto 26) = "000000" and s_instIDEX(5 downto 0) = "001000") then
		s_jumpReg <= '1';
	else
		s_jumpReg <= '0';
	end if;
  end process;

  JrMux : mux2t1_N
  port map(i_S => s_jumpReg,
	   i_D0 => s_jumpAddressOutIDEX,
	   i_D1 => s_rsDataOutIDEX,
	   o_O => s_jumpAddress_EX);


  secondLeftShifter : barrelShifter
  port map(DATA => s_extOutputOutIDEX,
	   shamt => "00010",
	   DIR => '1',
	   MODE => '0',
	   OUTPUT => s_secondLeftShifterOuptut);

  addressAdder : addSub_ALU
  port map(D0 => s_pcAdderOutputOutIDEX,
	   D1 => s_secondLeftShifterOuptut,
	   I => s_secondLeftShifterOuptut,
	   n_Add_Sub => '0',
	   ALUSrc => '0',
	   Sum => s_addressAdderOutput_EX,
	   Cout => s_addressAdderCout);


  ALUControl : alulogic
  port map (ALUOp => s_ALUOpOutIDEX,
	    funct => s_instIDEX(5 downto 0),
	    ALUControl => aluC);

  process(s_shiftInst, s_instIDEX) is
  begin
  	if(s_instIDEX(31 downto 26) = "000000" and (s_instIDEX(5 downto 0) = "000000" or s_instIDEX(5 downto 0) = "000010" or s_instIDEX(5 downto 0) = "000011")) then
		s_shiftInst <= '1';
	else
		s_shiftInst <= '0';
	end if;
  end process;

  shifterMux : mux2t1_N
  port map(i_S => s_shiftInst,
	   i_D0 => s_rsDataOutIDEX,
	   i_D1 => s_extOutputOutIDEX,
	   o_O => s_shifterMuxOutput);

  ALUMux : mux2t1_N
  port map(i_S => s_ALUSrcOutIDEX,
	   i_D0 => s_rtDataOutIDEX,
	   i_D1 => s_extOutputOutIDEX,
	   o_O => s_ALUIn1);

  g_ALU : ALU
  port map(A => s_shifterMuxOutput,
	   B => s_ALUIn1,
	   ALUOP => aluC,
	   F => s_aluOutput_EX,
	   Cout => s_aluCout_EX,
	   Overflow => s_overflow_EX,
	   Zero => s_zero_EX);




  ------------------------- Pipeline EX/MEM ------------------------
  PipelineEXMEM : regEXMEM
    port map(CLK	     => iCLK,
	     RST	     => iRST,
	     instIn => s_instIDEX,
	     pcAdderOutputIn	     => s_pcAdderOutputOutIDEX,
	     jumpAddrIn => s_jumpAddress_EX,
	     branchAddrIn    => s_addressAdderOutput_EX,
	     rtDataIn     => s_rtDataOutIDEX,
	     aluOutputIn	=> s_aluOutput_EX,
	     writeAddrIn      => s_wrtieAddrOutIDEX,
	     zeroIn	     => s_zero_EX,
	     overflowIn	     => s_overflow_EX,
	     memtoRegIn	     => s_memtoRegOutIDEX,
	     memWriteIn	     => s_memWriteOutIDEX,
	     regWriteIn	     => s_regWriteOutIDEX,
	     branchIn	     => s_branchOutIDEX,
	     jumpIn	     => s_jumpOutIDEX,
	     haltIn	     => s_haltOutIDEX,
	     instOut => s_instEXMEM,
	     pcAdderOutputOut	     => s_pcAdderOutputOutEXMEM,
	     jumpAddrOut => s_jumpAddrOutEXMEM,
	     branchAddrOut    => s_branchAddrOutEXMEM,
	     rtDataOut     => s_rtDataOutEXMEM,
	     aluOutputOut	     => s_aluOutputOutEXMEM,
	     writeAddrOut      => s_writeAddrOutEXMEM,
	     zeroOut	     => s_zeroOutEXMEM,
	     overflowOut	     => s_overflowOutEXMEM,
	     memtoRegOut	     => s_memtoRegOutEXMEM,
	     memWriteOut	     => s_memWriteOutEXMEM,
	     regWriteOut	     => s_regWriteOutEXMEM,
	     branchOut	     => s_branchOutEXMEM,
	     jumpOut	     => s_jumpOutEXMEM,
	     haltOut	     => s_haltOutEXMEM);




  g_And : andg2
  port map(i_A => s_branchOutEXMEM,
	   i_B => s_zeroOutEXMEM,
	   o_F => s_andOutput);
  
  s_DMemAddr <= s_aluOutputOutEXMEM;
  s_DMemData <= s_rtDataOutEXMEM;
  s_DMemWr <= s_memWriteOutEXMEM;

  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

 P_ALinst : process(s_instEXMEM, s_andOutput, s_regWriteOutEXMEM, s_RegWr_MEM)
 begin
        -- bgezal
  	if(s_instEXMEM(31 downto 26) = "000001" and s_instEXMEM(20 downto 16) = "10001" and s_andOutput = '0') then
               s_RegWr_MEM <= '0';

	--bltzal
	elsif(s_instEXMEM(31 downto 26) = "000001" and s_instEXMEM(20 downto 16) = "10000" and s_andOutput = '0') then
                s_RegWr_MEM <= '0';

	else
		s_RegWr_MEM <= s_regWriteOutEXMEM;
	end if;
  end process;

  ---------- Pipeline MEM/WB -----------------
  PipelineMEMWB : regMEMWB
  port map(CLK => iCLK,
	   RST => iRST,
	   pcAdderOutputIn => s_pcAdderOutputOutEXMEM,
	   jumpAddrIn => s_jumpAddrOutEXMEM,
	   branchAddrIn => s_branchAddrOutEXMEM,
	   memReadDataIn => s_DMemOut,
	   aluOutputIn => s_aluOutputOutEXMEM,
	   writeAddrIn => s_writeAddrOutEXMEM,
	   branchIsTrueIn => s_andOutput,
	   overflowIn => s_overflowOutEXMEM,
	   memtoRegIn => s_memtoRegOutEXMEM,
	   regWriteIn => s_RegWr_Mem,
	   jumpIn => s_jumpOutEXMEM,
	   haltIn => s_haltOutEXMEM,
	   pcAdderOutputOut => s_pcAdderOutputOutMEMWB,
	   jumpAddrOut => s_jumpAddrOutMEMWB,
	   branchAddrOut => s_branchAddrOutMEMWB,
	   memReadDataOut => s_memReadDataOutMEMWB,
	   aluOutputOut => s_aluOutputOutMEMWB,
	   writeAddrOut => s_RegWrAddr,
	   branchIsTrueOut => s_branchIsTrueOutMEMWB,
	   overflowOut => s_Ovfl,
	   memtoRegOut => s_memtoRegOutMEMWB,
	   regWriteOut => s_RegWr,
	   jumpOut => s_jumpOutMEMWB,
	   haltOut => s_Halt);
  


  oALUOut<=s_aluOutputOutMEMWB;


  BranchMux : mux2t1_N
  port map(i_S => s_branchIsTrueOutMEMWB,
	   i_D0 => s_stallMux1Output,
	   i_D1 => s_branchAddrOutMEMWB,
	   o_O => s_branchMuxOutput);

  PCMux : mux2t1_N
  port map(i_S => s_jumpOutMEMWB,
	   i_D0 => s_branchMuxOutput,
	   i_D1 => s_jumpAddrOutMEMWB,
	   o_O => s_pcMuxOutput);


 -- process(s_regEnable, s_mipsOpcode, s_branchIsTrueOutMEMWB) is
 -- begin
        -- bgezal
  --	if(s_mipsOpcode = "011101" and s_branchIsTrueOutMEMWB = '0') then
  --              s_regEnable <= '0';
	--bltzal
--	elsif(s_mipsOpcode = "011111" and s_branchIsTrueOutMEMWB = '0') then
  --              s_regEnable <= '0';
--	else
--		s_regEnable <= '1';
--	end if;
 -- end process;


  MemMux : mux4t1_N
  port map(i_S => s_memtoRegOutMEMWB,
	   i_D0 => s_aluOutputOutMEMWB,
	   i_D1 => s_memReadDataOutMEMWB,
	   i_D2 => s_pcAdderOutputOutMEMWB,
	   i_D3 => s_aluOutputOutMEMWB,
	   o_O => s_RegWrData);


end structure;

