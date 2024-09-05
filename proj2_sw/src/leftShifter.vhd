------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- leftShifter.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity leftShifter is
  port(
        DATA : in std_logic_vector(25 downto 0);
	OUTPUT : out std_logic_vector(27 downto 0));

end leftShifter;

architecture behavior of leftShifter is
 signal regNew : std_logic_vector(27 downto 0);
 signal shamtInt : integer := 0;

 begin
   OUTPUT <= regNew;
   process (DATA) is
   begin
     leftShift_data : for k in 27 downto 0 loop
	exit when ((k-2)<0);
        regNew(k) <= DATA(k-2);
     end loop leftShift_data;

     leftShift_fill : for k in 0 to 1 loop
	  regNew(k) <= '0';
     end loop leftShift_fill;
   end process;
end behavior;



  