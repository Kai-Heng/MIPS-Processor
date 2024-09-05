------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- extender_Test.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity extender_Test is
	generic(gCLK_HPER : time := 50 ns);
end extender_Test;

architecture behavior of extender_Test is
 	-- Calculate the clock period as twice the half-period
  	constant cCLK_PER  : time := gCLK_HPER * 2;

   	component extender
	port (
		input		: in std_logic_vector(15 downto 0);
		sign_zero	 : in std_logic;
		output		: out std_logic_vector(31 downto 0));
	end component;

  signal clock, check : std_logic;
  signal s_input : std_logic_vector(15 downto 0);
  signal s_output : std_logic_vector(31 downto 0);

  begin

    DUT0: extender
	port MAP(
		 input => s_input,
	  	 sign_zero => check,
	 	 output => s_output);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    clock <= '0';
    wait for gCLK_HPER;
    clock <= '1';
    wait for gCLK_HPER;
  end process;

  P_Test : process
  begin
    s_input <= x"0000";
    check <= '0';
    wait for cCLK_PER; -- Zero extend, expected output: 0x00000000

    s_input <= x"0000";
    check <= '1';
    wait for cCLK_PER; -- Sign extend, expected output: 0x00000000

    s_input <= x"FFFF";
    check <= '0';
    wait for cCLK_PER; -- Zero extend, expected output: 0x0000FFFF

    s_input <= x"FFFF";
    check <= '1';
    wait for cCLK_PER; -- Sign extend, expected output: 0xFFFFFFFF

    s_input <= x"4FFF";
    check <= '1';
    wait for cCLK_PER; -- Sign extend, expected output: 0x00004FFF
    
    s_input <= x"A000";
    check <= '1';
    wait for cCLK_PER; -- Sign extend, expected output: 0xFFFFA000

   wait;
  end process;

end behavior;

