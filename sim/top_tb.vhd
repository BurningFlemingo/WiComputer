library ieee; 
use ieee.std_logic_1164.all;

entity top_tb is 
end entity top_tb;

architecture tb of top_tb is 
		signal s_clk : std_logic;

		signal s_x : std_logic_vector(15 downto 0);
		signal s_y : std_logic_vector(15 downto 0);
		
		signal s_write_en : std_logic;
		signal s_px_color : std_logic;
begin 

	framebuffer_controller_inst: entity work.framebuffer_controller
	 port map(
	    i_clk => s_clk,
	    i_x => s_x(8 downto 0),
	    i_y => s_y(9 downto 0),
	    i_write_en => s_write_en,
	    i_data => '1',
	    o_data => s_px_color
	);

	clock_proc: process 
	begin 
		s_clk <= '0';
		wait for 10 ns;
		
		s_clk <= '1';
		wait for 10 ns;
	end process clock_proc;

	stim_proc: process 
	begin 
		s_x <= "0000000000000000";
		s_y <= "0000000000000000";
		s_write_en <= '0';

		wait for 20 ns;

		s_x <= "0000000000000001";
		s_y <= "0000000000000001";
		s_write_en <= '1';

		wait for 20 ns;
		
		wait;
		
	end process stim_proc;


end architecture tb;
