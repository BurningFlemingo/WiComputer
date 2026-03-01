library ieee; 
use ieee.std_logic_1164.all;

entity top_tb is 
end entity top_tb;

architecture tb of top_tb is 
		signal s_subtract : std_logic;
	
		signal s_a : std_logic_vector(7 downto 0);
		signal s_b : std_logic_vector(7 downto 0);
	
		signal s_result : std_logic_vector(7 downto 0);

begin 

	ripple_adder_inst: entity work.ripple_adder 
		generic map(
			g_bit_size => 8
		)
		port map(
			i_subtract => s_subtract,
			i_a => s_a,
			i_b => s_b,
			o_result => s_result
		);

	stim_proc: process 
	begin 
		s_subtract <= '0';
		
		s_a <= "00000000";
		s_b <= "00000000";

		wait for 20 ns;

		s_subtract <= '0';
		
		s_a <= "00000001";
		s_b <= "00000001";

		wait for 20 ns;

		s_subtract <= '0';
		
		s_a <= "01111111";
		s_b <= "00000001";

		wait for 20 ns;

		s_subtract <= '1';
		
		s_a <= "00000010";
		s_b <= "00000001";

		wait for 20 ns;

		s_subtract <= '0';
		
		s_a <= "11111111";
		s_b <= "00000001";

		wait for 20 ns;

		s_subtract <= '1';
		
		s_a <= "11111111";
		s_b <= "00000001";

		wait for 20 ns;
		
		wait;
		
	end process stim_proc;


end architecture tb;
