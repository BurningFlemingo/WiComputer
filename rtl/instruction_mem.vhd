library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity instruction_mem is 
	port(
		i_clk : in std_logic;
		i_addr : in std_logic_vector(9 downto 0);

		o_instruction : out std_logic_vector(31 downto 0)
	);
end entity instruction_mem; 

architecture rtl of instruction_mem is 
	type t_byte_arr is array (natural range<>) of std_logic_vector(7 downto 0);
	
	constant c_instruction_rom : t_byte_arr(1023 downto 0) := (
		x"00", x"00", x"00", others => x"00"
	);
	signal r_current_instruction : std_logic_vector(31 downto 0);
begin 

	o_instruction <= r_current_instruction;

	process(i_clk)
	begin 
		if rising_edge(i_clk) then 
			r_current_instruction(7 downto 0) <= c_instruction_rom(to_integer(unsigned(i_addr(9 downto 2)) + 0));
			r_current_instruction(15 downto 8) <= c_instruction_rom(to_integer(unsigned(i_addr(9 downto 2)) + 1));
			r_current_instruction(23 downto 16) <= c_instruction_rom(to_integer(unsigned(i_addr(9 downto 2)) + 2));
			r_current_instruction(31 downto 24) <= c_instruction_rom(to_integer(unsigned(i_addr(9 downto 2)) + 3));
		end if;
	end process;
end architecture rtl;
