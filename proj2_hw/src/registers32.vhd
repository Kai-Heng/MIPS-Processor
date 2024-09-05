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

  component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  signal load : std_logic_vector(31 downto 0) := x"00000000";

begin

  g_And0 : andg2
  port map(i_A => S(0),
	   i_B => En,
	   o_F => load(0));

  g_32Reg0 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => '1',
	   i_S => S(0),
	   En => load(0),
           i_D => x"00000000",
	   o_Q => Q0);

  g_And1 : andg2
  port map(i_A => S(1),
	   i_B => En,
	   o_F => load(1));

  g_32Reg1 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(1),
	   En => load(1),
           i_D => D,
	   o_Q => Q1);

  g_And2 : andg2
  port map(i_A => S(2),
	   i_B => En,
	   o_F => load(2));

  g_32Reg2 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(2),
	   En => load(2),
           i_D => D,
	   o_Q => Q2);

  g_And3 : andg2
  port map(i_A => S(3),
	   i_B => En,
	   o_F => load(3));

  g_32Reg3 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(3),
	   En => load(3),
           i_D => D,
	   o_Q => Q3);

  g_And4 : andg2
  port map(i_A => S(4),
	   i_B => En,
	   o_F => load(4));

  g_32Reg4 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(4),
	   En => load(4),
           i_D => D,
	   o_Q => Q4);

  g_And5 : andg2
  port map(i_A => S(5),
	   i_B => En,
	   o_F => load(5));

  g_32Reg5 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(5),
	   En => load(5),
           i_D => D,
	   o_Q => Q5);

  g_And6 : andg2
  port map(i_A => S(6),
	   i_B => En,
	   o_F => load(6));

  g_32Reg6 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(6),
	   En => load(6),
           i_D => D,
	   o_Q => Q6);

  g_And7 : andg2
  port map(i_A => S(7),
	   i_B => En,
	   o_F => load(7));

  g_32Reg7 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(7),
	   En => load(7),
           i_D => D,
	   o_Q => Q7);

  g_And8 : andg2
  port map(i_A => S(8),
	   i_B => En,
	   o_F => load(8));

  g_32Reg8 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(8),
	   En => load(8),
           i_D => D,
	   o_Q => Q8);

  g_And9 : andg2
  port map(i_A => S(9),
	   i_B => En,
	   o_F => load(9));


  g_32Reg9 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(9),
	   En => load(9),
           i_D => D,
	   o_Q => Q9);

  g_And10 : andg2
  port map(i_A => S(10),
	   i_B => En,
	   o_F => load(10));

  g_32Reg10 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(10),
	   En => load(10),
           i_D => D,
	   o_Q => Q10);

  g_And11 : andg2
  port map(i_A => S(11),
	   i_B => En,
	   o_F => load(11));

  g_32Reg11 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(11),
	   En => load(11),
           i_D => D,
	   o_Q => Q11);

  g_And12 : andg2
  port map(i_A => S(12),
	   i_B => En,
	   o_F => load(12));

  g_32Reg12 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(12),
	   En => load(12),
           i_D => D,
	   o_Q => Q12);

  g_And13 : andg2
  port map(i_A => S(13),
	   i_B => En,
	   o_F => load(13));

  g_32Reg13 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(13),
	   En => load(13),
           i_D => D,
	   o_Q => Q13);

  g_And14 : andg2
  port map(i_A => S(14),
	   i_B => En,
	   o_F => load(14));

  g_32Reg14 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(14),
	   En => load(14),
           i_D => D,
	   o_Q => Q14);

  g_And15 : andg2
  port map(i_A => S(15),
	   i_B => En,
	   o_F => load(15));

  g_32Reg15 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(15),
	   En => load(15),
           i_D => D,
	   o_Q => Q15);

  g_And16 : andg2
  port map(i_A => S(16),
	   i_B => En,
	   o_F => load(16));

  g_32Reg16 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(16),
	   En => load(16),
           i_D => D,
	   o_Q => Q16);

  g_And17 : andg2
  port map(i_A => S(17),
	   i_B => En,
	   o_F => load(17));

  g_32Reg17 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(17),
	   En => load(17),
           i_D => D,
	   o_Q => Q17);

  g_And18 : andg2
  port map(i_A => S(18),
	   i_B => En,
	   o_F => load(18));

  g_32Reg18 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(18),
	   En => load(18),
           i_D => D,
	   o_Q => Q18);

  g_And19 : andg2
  port map(i_A => S(19),
	   i_B => En,
	   o_F => load(19));

  g_32Reg19 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(19),
	   En => load(19),
           i_D => D,
	   o_Q => Q19);

  g_And20 : andg2
  port map(i_A => S(20),
	   i_B => En,
	   o_F => load(20));

  g_32Reg20 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(20),
	   En => load(20),
           i_D => D,
	   o_Q => Q20);

  g_And21 : andg2
  port map(i_A => S(21),
	   i_B => En,
	   o_F => load(21));

  g_32Reg21 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(21),
	   En => load(21),
           i_D => D,
	   o_Q => Q21);

  g_And22 : andg2
  port map(i_A => S(22),
	   i_B => En,
	   o_F => load(22));

  g_32Reg22 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(22),
	   En => load(22),
           i_D => D,
	   o_Q => Q22);

  g_And23 : andg2
  port map(i_A => S(23),
	   i_B => En,
	   o_F => load(23));

  g_32Reg23 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(23),
	   En => load(23),
           i_D => D,
	   o_Q => Q23);

  g_And24 : andg2
  port map(i_A => S(24),
	   i_B => En,
	   o_F => load(24));

  g_32Reg24 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(24),
	   En => load(24),
           i_D => D,
	   o_Q => Q24);

  g_And25 : andg2
  port map(i_A => S(25),
	   i_B => En,
	   o_F => load(25));

  g_32Reg25 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(25),
	   En => load(25),
           i_D => D,
	   o_Q => Q25);

  g_And26 : andg2
  port map(i_A => S(26),
	   i_B => En,
	   o_F => load(26));

  g_32Reg26 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(26),
	   En => load(26),
           i_D => D,
	   o_Q => Q26);

  g_And27 : andg2
  port map(i_A => S(27),
	   i_B => En,
	   o_F => load(27));

  g_32Reg27 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(27),
	   En => load(27),
           i_D => D,
	   o_Q => Q27);

  g_And28 : andg2
  port map(i_A => S(28),
	   i_B => En,
	   o_F => load(28));

  g_32Reg28 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(28),
	   En => load(28),
           i_D => D,
	   o_Q => Q28);

  g_And29 : andg2
  port map(i_A => S(29),
	   i_B => En,
	   o_F => load(29));

  g_32Reg29 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(29),
	   En => load(29),
           i_D => D,
	   o_Q => Q29);

  g_And30 : andg2
  port map(i_A => S(30),
	   i_B => En,
	   o_F => load(30));

  g_32Reg30 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(30),
	   En => load(30),
           i_D => D,
	   o_Q => Q30);

  g_And31 : andg2
  port map(i_A => S(31),
	   i_B => En,
	   o_F => load(31));

  g_32Reg31 : reg32b
  port MAP(i_CLK => CLK,
	   i_RST => RST,
	   i_S => S(31),
	   En => load(31),
           i_D => D,
	   o_Q => Q31);
  
end structural;