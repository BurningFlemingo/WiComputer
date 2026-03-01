library ieee; 
use ieee.std_logic_1164.all;

entity top_tb is 
end entity top_tb;

architecture tb of top_tb is 
	signal s_clk : std_logic;
	signal s_n_rst_async : std_logic;

	signal s_r : std_logic_vector(3 downto 0);
	signal s_g : std_logic_vector(3 downto 0);
	signal s_b : std_logic_vector(3 downto 0);
	
	signal s_hs : std_logic;
	signal s_vs : std_logic;
begin 

	top_inst: entity work.top
	 port map(
		i_clk => s_clk, 
		i_n_rst_async => s_n_rst_async, 
		o_r => s_r, 
		o_g => s_g, 
		o_b => s_b, 
		o_hs => s_hs,
		o_vs => s_vs
	);
	
	rst_proc: process
	begin
		s_n_rst_async <= '0';
		wait for 50 ns; 
		
		s_n_rst_async <= '1';

		wait;
	end process rst_proc;
	
	clk_proc: process
	begin
		s_clk <= '0'; 
		wait for 10 ns; 
		s_clk <= '1'; 
		wait for 10 ns;
	end process clk_proc;
end architecture tb;
