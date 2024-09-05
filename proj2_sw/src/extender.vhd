------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- extender.vhd

library ieee;
use ieee.std_logic_1164.all;

entity extender is
	port (
		input		: in std_logic_vector(15 downto 0);
		sign_zero	 : in std_logic;
		output		: out std_logic_vector(31 downto 0));

end extender;

architecture behavior of extender is

begin
  process(input, sign_zero)
   begin
     for i in 0 to 15 loop
	output(i) <= input(i);
     end loop;

     for i in 16 to 31 loop
        output(i) <= (input(15) and sign_zero);
     end loop;
  end process;
end behavior;