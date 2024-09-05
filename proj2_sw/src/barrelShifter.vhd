------------------------------------
-- Kai Heng Gan
-- Cyber Security Engineering
-- Iowa State University
------------------------------------

-- barrelShifter.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrelShifter is
  port(
        DATA : in std_logic_vector(31 downto 0);
	shamt : in std_logic_vector(4 downto 0);
	DIR : in std_logic; -- 0: right 1: left
	MODE : in std_logic; -- 0: logical 1: arithmetic 
	OUTPUT : out std_logic_vector(31 downto 0));

end barrelShifter;

architecture behavior of barrelShifter is
 signal regNew : std_logic_vector(31 downto 0);
 signal leftShiftReg : std_logic_vector(31 downto 0);
 signal shamtInt : integer := 0;

 begin
    OUTPUT <= regNew;

   P_ShiftValue : process (shamt, shamtInt)
    	begin
	case shamt is
		when "00000" => shamtInt <= 0; -- $0
		when "00001" => shamtInt <= 1; -- $1
		when "00010" => shamtInt <= 2; -- $2
		when "00011" => shamtInt <= 3; -- $3
		when "00100" => shamtInt <= 4; -- $4
		when "00101" => shamtInt <= 5; -- $5
		when "00110" => shamtInt <= 6; -- $6
		when "00111" => shamtInt <= 7; -- $7
		when "01000" => shamtInt <= 8; -- $8
		when "01001" => shamtInt <= 9; -- $9
		when "01010" => shamtInt <= 10; -- $10
		when "01011" => shamtInt <= 11; -- $11
		when "01100" => shamtInt <= 12; -- $12
		when "01101" => shamtInt <= 13; -- $13
		when "01110" => shamtInt <= 14; -- $14
		when "01111" => shamtInt <= 15; -- $15
		when "10000" => shamtInt <= 16; -- $16
		when "10001" => shamtInt <= 17; -- $17
		when "10010" => shamtInt <= 18; -- $18
		when "10011" => shamtInt <= 19; -- $19
		when "10100" => shamtInt <= 20; -- $20
		when "10101" => shamtInt <= 21; -- $21
		when "10110" => shamtInt <= 22; -- $22
		when "10111" => shamtInt <= 23; -- $23
		when "11000" => shamtInt <= 24; -- $24
		when "11001" => shamtInt <= 25; -- $25
		when "11010" => shamtInt <= 26; -- $26
		when "11011" => shamtInt <= 27; -- $27
		when "11100" => shamtInt <= 28; -- $28
		when "11101" => shamtInt <= 29; -- $29
		when "11110" => shamtInt <= 30; -- $30
		when "11111" => shamtInt <= 31; -- $31
		when others => shamtInt <= 0;
	end case;
     end process;

  P_shift : process (MODE,DIR, DATA, leftShiftReg, regNew, shamtInt)
  variable count : integer;
  variable newData : std_logic_vector(31 downto 0);
  begin 
   

   -- logical right shift
   if(DIR = '0' and MODE = '0') then
	logic_data : for k in 0 to 31 loop
	  count := (k + shamtInt);
	  if ((count) > 31) then
		newData(k) := '0';
	  else
          	newData(k) := DATA(count);
	  end if;
	end loop logic_data;
    --   logic_fill : for k in (32 - shamtInt) to 31 loop
	--  regNew(k) <= '0';
     --  end loop logic_fill;
 
   -- arithmetic right shift
   elsif (DIR = '0' and MODE = '1') then
	arith_data : for k in 0 to 31 loop
	  count := (k+shamtInt);
          if ((count)>31) then
		newData(k) := DATA(31);
	  else
	  	newData(k) := DATA(count);
	  end if;
          
	end loop arith_data;
  
  --     arith_fill : for k in (32 - shamtInt) to 31 loop
	--  regNew(k) <= DATA(31);
   --    end loop arith_fill;

   -- logical left shift
   else
     leftShift_data : for k in 31 downto 0 loop
	count := (k-shamtInt);
	if ((count)<0) then
		newData(k) := '0';
        else
        	newData(k) := DATA(count);
	end if;
     end loop leftShift_data;

   --  leftShift_fill : for k in 0 to shamtInt-1 loop
	--  leftShiftReg(k) <= '0';
   --  end loop leftShift_fill;
   end if;

   regNew <= newData;
  end process;
end behavior;



  