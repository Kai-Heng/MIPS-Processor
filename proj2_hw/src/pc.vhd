------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------


-- pc.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
  port(
	CLK, RST : in std_logic;
	DATA : in std_logic_vector(31 downto 0);
	OUTPUT : out std_logic_vector(31 downto 0));

end pc;

architecture structure of pc is
  signal s_O : std_logic_vector(31 downto 0);
  signal initPCAddr : std_logic_vector(31 downto 0) := x"00400000";

begin
  OUTPUT <= s_O;

  process (CLK, RST, DATA)
  begin
    if (RST = '1') then
      s_O <= initPCAddr;
    elsif (rising_edge(CLK)) then
      s_O <= DATA;
    end if;

  end process;
end structure;