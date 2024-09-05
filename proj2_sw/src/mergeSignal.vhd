------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

--mergeSignal.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mergeSignal is
  port(
        DATA0 : in std_logic_vector(27 downto 0);
	DATA1 : in std_logic_vector(3 downto 0);
	OUTPUT : out std_logic_vector(31 downto 0));

end mergeSignal;

architecture behavior of mergeSignal is
 component org2_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
 end component;

 signal regNew : std_logic_vector(31 downto 0);
 signal firstDataExt : std_logic_vector(31 downto 0);
 signal secondDataExt : std_logic_vector(31 downto 0);
 signal count :  integer := 0;
  

 begin

   process (DATA0, DATA1) is
   begin
     firstData : for k in 0 to 27 loop
        firstDataExt(k) <= DATA0(k);
     end loop firstData;

    firstDataFill : for k in 31 downto 28 loop
	firstDataExt(k) <= '0';
    end loop firstDataFill;

     secondData : for k in 31 downto 28 loop
	  exit when ((k-28)<0);
	  secondDataExt(k) <= DATA1(k-28);
     end loop secondData;

     secondDataFill : for k in 0 to 27 loop
	  secondDataExt(k) <= '0';
     end loop secondDataFill;
   end process;

  G_OR : org2_N
  port map (i_D0 => firstDataExt,
	    i_D1 => secondDataExt,
	    o_O => OUTPUT);
end behavior;



  