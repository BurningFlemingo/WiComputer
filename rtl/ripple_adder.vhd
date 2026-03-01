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
	s_fixed_b <= i_b xor (g_bit_size-1 downto 0 => i_subtract);
	
	s_xored_ab <= i_a xor s_fixed_b;

	s_carry(g_bit_size downto 1) <= (s_carry(g_bit_size-1 downto 0) and s_xored_ab) or (i_a and s_fixed_b);
	s_result <= s_carry(g_bit_size-1 downto 0) xor s_xored_ab;
end architecture rtl; 
