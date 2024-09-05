------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- xorg2_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- XOR using structural VHDL, generics, and generate statements.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity xorg2_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0          : in std_logic_vector(N-1 downto 0);
	i_D1          : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end xorg2_N;

architecture structural of xorg2_N is

  component xorg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_XORG: for i in 0 to N-1 generate
    XORG_N: xorg2 port map(
              i_A     => i_D0(i),
	      i_B => i_D1(i), 
              o_F      => o_O(i));
  end generate G_NBit_XORG;
  
end structural;