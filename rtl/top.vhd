library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is 
	port (
		i_clk : in std_logic;
		i_n_rst_async : in std_logic;

		o_r : out std_logic_vector(3 downto 0);
		o_g : out std_logic_vector(3 downto 0);
		o_b : out std_logic_vector(3 downto 0);
	
		o_hs : out std_logic;
		o_vs : out std_logic
	);
end entity;

architecture rtl of top is 
	signal r_n_rst_meta : std_logic;
	signal r_n_rst_sync : std_logic;
	
	signal s_rst : std_logic;
	
	signal s_x : std_logic_vector(15 downto 0);
	signal s_y : std_logic_vector(15 downto 0);
	
	signal s_vs : std_logic;

	signal s_px_color : std_logic_vector(11 downto 0); -- rrrrggggbbbb
	signal s_n_vs : std_logic;
begin 
	s_rst <= not r_n_rst_sync;
	o_vs <= s_vs;
	s_n_vs <= not s_vs;
	
	vga_controller_inst: entity work.vga_controller
	 port map(
	    i_clk => i_clk,
	    i_rst => s_rst,
		
	    i_r => s_px_color(3 downto 0),
	    i_g => s_px_color(7 downto 4),
	    i_b => s_px_color(11 downto 8),
		
	    o_r => o_r,
	    o_g => o_g,
	    o_b => o_b,

		o_x => s_x,
		o_y => s_y,

	    o_hs => o_hs,
	    o_vs => s_vs
	);

	framebuffer_controller_inst: entity work.framebuffer_controller
	 port map(
	    i_clk => i_clk,
	    i_x => s_x(9 downto 2),
	    i_y => s_y(8 downto 2),
	    i_write_en => '1',
	    i_data => s_y(6 downto 1) & s_x(7 downto 2),
	    o_data => s_px_color
	);

	process(i_clk) 
	begin 
		if rising_edge(i_clk) then 
			r_n_rst_meta <= i_n_rst_async;
			r_n_rst_sync <= r_n_rst_meta;
		end if; 
	end process;
end architecture rtl;
