------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- mux2t1_5b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_5b is
  generic(N : integer := 5); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end mux2t1_5b;

architecture structural of mux2t1_5b is

  component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_5Bit_MUX: for i in 0 to 5-1 generate
    MUX_5B: mux2t1 port map(
              i_S      => i_S,      -- All instances share the same select input.
              i_D0     => i_D0(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => i_D1(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_5Bit_MUX;
  
end structural;