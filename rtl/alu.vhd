library ieee; 
use ieee.std_logic_1164.all; 

-- alu opcodes 
-- 000 ; add 
-- 001 ; subtract
-- 011 ; slt
-- 100 ; xor
entity alu is 
	port (
		i_op : in std_logic_vector(2 downto 0);
		i_a : in std_logic_vector(31 downto 0); 
		i_b : in std_logic_vector(31 downto 0); 
	
		o_result : out std_logic_vector(31 downto 0);
		o_zero : out std_logic
	);
end entity alu; 

architecture rtl of alu is 
	signal s_xor : std_logic_vector(31 downto 0);
	signal s_slt : std_logic_vector(31 downto 0);
	signal s_sum : std_logic_vector(31 downto 0);

	signal s_result : std_logic_vector(31 downto 0);
begin 
	o_result <= s_result;
	
	s_xor <= i_a xor i_b;
	s_slt <= (31 downto 0 => s_sum(31));
	
	ripple_adder_inst: entity work.ripple_adder
	 generic map(
	    g_bit_size => 32
	)
	 port map(
	    i_subtract => i_op(0),
	    i_a => i_a,
	    i_b => i_b,
	    o_result => s_sum
	);

	with i_op select
		s_result <= s_sum when "000" | "001", 
					s_slt when "011", 
					s_xor when "100", 
					(others => '0') when others;

	o_zero <= '1' when s_result = (31 downto 0 => '0') else '0';
	
end architecture rtl;
