------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--registers32.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity registers32 is
  generic(N : integer := 32);
  port(CLK        : in std_logic;     -- Clock input
       RST        : in std_logic;     -- Reset input
       S          : in std_logic_vector(N-1 downto 0);     -- Value from 5:32 Decoder
       En	    : in std_logic;
       D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27,Q28,Q29,Q30,Q31          : out std_logic_vector(N-1 downto 0));   -- Data value output

end registers32;

architecture structural of registers32 is
  component reg32b is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_S          : in std_logic;     -- Value from 5:32 Decoder
       En	    : in std_logic;
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;

begin
  g_32Reg0 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => '1',
	   i_S => S(0),
	   En => En,
           i_D => "00000000000000000000000000000000",
	   o_Q => Q0);

  g_32Reg1 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(1),
	   En => En,
           i_D => D,
	   o_Q => Q1);

  g_32Reg2 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(2),
	   En => En,
           i_D => D,
	   o_Q => Q2);

  g_32Reg3 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(3),
	   En => En,
           i_D => D,
	   o_Q => Q3);

  g_32Reg4 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(4),
	   En => En,
           i_D => D,
	   o_Q => Q4);

  g_32Reg5 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(5),
	   En => En,
           i_D => D,
	   o_Q => Q5);

  g_32Reg6 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(6),
	   En => En,
           i_D => D,
	   o_Q => Q6);

  g_32Reg7 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(7),
	   En => En,
           i_D => D,
	   o_Q => Q7);

  g_32Reg8 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(8),
	   En => En,
           i_D => D,
	   o_Q => Q8);


  g_32Reg9 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(9),
	   En => En,
           i_D => D,
	   o_Q => Q9);

  g_32Reg10 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(10),
	   En => En,
           i_D => D,
	   o_Q => Q10);

  g_32Reg11 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(11),
	   En => En,
           i_D => D,
	   o_Q => Q11);

  g_32Reg12 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(12),
	   En => En,
           i_D => D,
	   o_Q => Q12);

  g_32Reg13 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(13),
	   En => En,
           i_D => D,
	   o_Q => Q13);

  g_32Reg14 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(14),
	   En => En,
           i_D => D,
	   o_Q => Q14);

  g_32Reg15 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(15),
	   En => En,
           i_D => D,
	   o_Q => Q15);

  g_32Reg16 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(16),
	   En => En,
           i_D => D,
	   o_Q => Q16);

  g_32Reg17 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(17),
	   En => En,
           i_D => D,
	   o_Q => Q17);

  g_32Reg18 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(18),
	   En => En,
           i_D => D,
	   o_Q => Q18);

  g_32Reg19 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(19),
	   En => En,
           i_D => D,
	   o_Q => Q19);

  g_32Reg20 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(20),
	   En => En,
           i_D => D,
	   o_Q => Q20);

  g_32Reg21 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(21),
	   En => En,
           i_D => D,
	   o_Q => Q21);

  g_32Reg22 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(22),
	   En => En,
           i_D => D,
	   o_Q => Q22);

  g_32Reg23 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(23),
	   En => En,
           i_D => D,
	   o_Q => Q23);

  g_32Reg24 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(24),
	   En => En,
           i_D => D,
	   o_Q => Q24);

  g_32Reg25 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(25),
	   En => En,
           i_D => D,
	   o_Q => Q25);

  g_32Reg26 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(26),
	   En => En,
           i_D => D,
	   o_Q => Q26);

  g_32Reg27 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(27),
	   En => En,
           i_D => D,
	   o_Q => Q27);

  g_32Reg28 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(28),
	   En => En,
           i_D => D,
	   o_Q => Q28);

  g_32Reg29 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(29),
	   En => En,
           i_D => D,
	   o_Q => Q29);

  g_32Reg30 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(30),
	   En => En,
           i_D => D,
	   o_Q => Q30);

  g_32Reg31 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(31),
	   En => En,
           i_D => D,
	   o_Q => Q31);
  
end structural;