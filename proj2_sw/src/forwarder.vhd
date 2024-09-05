------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- forwarder.vhd


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarder is
	port(i_readAddr1  	  	: in std_logic_vector(4 downto 0);
	     i_readAddr2	  	: in std_logic_vector(4 downto 0);
	     i_writeAddr	  	: in std_logic_vector(4 downto 0);
             i_writeEnable      	: in std_logic;
             o_fwdSwitch1		: out std_logic; 
             o_fwdSwitch2		: out std_logic);
end forwarder;

architecture behavior of forwarder is
begin
    process(i_readAddr1, i_readAddr2, i_writeAddr)
    begin
        if (i_readAddr1 = i_writeAddr AND i_writeEnable = '1' AND i_writeAddr /= "00000") then
            o_fwdSwitch1 <= '1';
        else
            o_fwdSwitch1 <= '0';
        end if;
        if (i_readAddr2 = i_writeAddr AND i_writeEnable = '1' AND i_writeAddr /= "00000") then
            o_fwdSwitch2 <= '1';
        else
            o_fwdSwitch2 <= '0';
        end if;
    end process;
end behavior;