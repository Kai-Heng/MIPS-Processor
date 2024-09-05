

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_regIFID is
  generic(gCLK_HPER   : time := 50 ns);
end tb_regIFID;

architecture behavior of tb_regIFID is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component regIFID
  port(CLK			: in std_logic;
       RST			: in std_logic;
       pcAdderOutputDataIn	: in std_logic_vector(31 downto 0);
       instIn			: in std_logic_vector(31 downto 0);
       pcAdderOutputDataOut	: out std_logic_vector(31 downto 0);
       instOut			: out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_pcIn     : std_logic_vector(31 downto 0) := (others=> '0');
  signal s_instIn     : std_logic_vector(31 downto 0) := (others=> '0');
  signal s_pcOut     : std_logic_vector(31 downto 0);
  signal s_instOut     : std_logic_vector(31 downto 0);

begin

  DUT: regIFID 
  port map(CLK => s_CLK,
           RST => '0',
           pcAdderOutputDataIn   => s_pcIn,
           instIn   => s_instIn,
           pcAdderOutputDataOut   => s_pcOut,
	   instOut => s_instOut);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

     -- Test 1
    s_pcIn <= x"11111111";
    s_instIn <= x"00000000";
    wait for cCLK_PER; 
    assert s_pcOut = x"11111111" and s_instOut = x"00000000" report "Test 1 failed" severity error;

    -- Test 2
    s_pcIn <= x"FFFFFFFF";
    s_instIn <= x"AAAAAAAA";
    wait for cCLK_PER; 
    assert s_pcOut = x"FFFFFFFF" and s_instOut = x"AAAAAAAA" report "Test 2 failed" severity error;

    -- Test 3
    wait for cCLK_PER*4;
    assert s_pcOut = x"FFFFFFFF" and s_instOut = x"AAAAAAAA" report "Test 3 failed" severity error;

    -- Test 4
    wait for cCLK_PER*4;
    assert s_pcOut = x"FFFFFFFF" and s_instOut = x"AAAAAAAA" report "Test 4 failed" severity error;


     assert false report "Testbench completed successfully" severity error;
  end process;
  
end behavior;
