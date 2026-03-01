library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity instruction_mem is 
	port(
		i_addr : in std_logic_vector(9 downto 0);
	
		o_instruction : out std_logic_vector(31 downto 0)
	);
end entity instruction_mem; 

architecture rtl of instruction_mem is 
	type t_byte_arr is array (natural range<>) of std_logic_vector(7 downto 0);
	
	constant c_instruction_rom : t_byte_arr(0 to 1023) := (x"20",x"08",x"80",x"00",x"20",x"09",x"00",x"00",x"20",x"0a",x"00",x"78",x"20",x"0c",x"00",x"a0",x"20",x"0b",x"00",x"00",x"01",x"2b",x"68",x"26",x"ad",x"0d",x"00",x"00",x"21",x"08",x"00",x"01",x"21",x"6b",x"00",x"01",x"01",x"6c",x"88",x"2a",x"16",x"20",x"ff",x"fa",x"21",x"29",x"00",x"01",x"01",x"2a",x"80",x"2a",x"16",x"00",x"ff",x"f6", others => x"00");

	signal s_masked_addr : std_logic_vector(9 downto 0);
begin 

	s_masked_addr <= i_addr(9 downto 2) & "00";

	o_instruction <= c_instruction_rom(to_integer(unsigned(s_masked_addr) + 0)) &
			c_instruction_rom(to_integer(unsigned(s_masked_addr) + 1)) &
			c_instruction_rom(to_integer(unsigned(s_masked_addr) + 2)) &
			c_instruction_rom(to_integer(unsigned(s_masked_addr) + 3));
end architecture rtl;
