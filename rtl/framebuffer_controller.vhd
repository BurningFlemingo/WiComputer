library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity framebuffer_controller is
	port(
		i_clk : in std_logic;
	
		i_x : in std_logic_vector(7 downto 0);
		i_y : in std_logic_vector(6 downto 0);

		i_write_en : in std_logic;

		i_data : in std_logic_vector(11 downto 0);
	
		o_data : out std_logic_vector(11 downto 0)
	);
end entity framebuffer_controller;

architecture rtl of framebuffer_controller is 
	signal s_address : std_logic_vector(14 downto 0);

	signal s_fb_out : std_logic_vector(11 downto 0);
	
begin 
	s_address <= i_y & i_x;
	o_data <= s_fb_out;

	framebuffer_inst : entity work.framebuffer 
		port map (
			address => s_address,
			clock => i_clk,
			data => i_data,
			wren => i_write_en,
			q => s_fb_out
		);
end architecture rtl;
