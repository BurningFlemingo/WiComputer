library ieee; 
use ieee.std_logic_1164.all; 

entity ripple_adder is 
	generic (
		g_bit_size : natural := 32
	);
	port (
		i_subtract : in std_logic;
	
		i_a : in std_logic_vector(g_bit_size-1 downto 0);
		i_b : in std_logic_vector(g_bit_size-1 downto 0);
	
		o_result : out std_logic_vector(g_bit_size-1 downto 0)
	);
end entity ripple_adder;

architecture rtl of ripple_adder is 
	signal s_carry : std_logic_vector(g_bit_size downto 0);
	signal s_result : std_logic_vector(g_bit_size-1 downto 0);
	signal s_fixed_b : std_logic_vector(g_bit_size-1 downto 0);
	signal s_xored_ab : std_logic_vector(g_bit_size-1 downto 0);
begin 
	s_carry(0) <= i_subtract;
	o_result <= s_result;
	
	for i in g_bit_size-1 downto 0 generate 
		s_xored_ab(i) <= i_a(i) xor i_b(i);
		
		s_result(i) <= s_carry(i) xor s_xored_ab(i);
		s_carry(i+1) <= (s_carry(i) and s_xored_ab(i)) or (i_a(i) and i_b(i))
	end generate;
end architecture rtl; 
