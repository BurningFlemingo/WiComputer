library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity framebuffer_controller is
	port(
		i_clk : in std_logic;
	
		i_read_addr : in std_logic_vector(14 downto 0);
		i_write_addr : in std_logic_vector(14 downto 0);

		i_write_en : in std_logic;

		i_data : in std_logic_vector(11 downto 0);
		o_data : out std_logic_vector(11 downto 0)
	);
end entity framebuffer_controller;

architecture rtl of framebuffer_controller is 
	signal s_fb_out : std_logic_vector(15 downto 0);
	signal s_padded_data : std_logic_vector(15 downto 0);
	signal s_padded_read_addr : std_logic_vector(15 downto 0);
	signal s_padded_write_addr : std_logic_vector(15 downto 0);
	
begin 
	o_data <= s_fb_out(11 downto 0);
	s_padded_data <= (15 downto 12 => '0') & i_data;
	s_padded_read_addr <= '0' & i_read_addr;
	s_padded_write_addr <= '0' & i_write_addr;

	framebuffer_inst : entity work.framebuffer 
		port map (
			clock => i_clk,
			data => s_padded_data,
			rdaddress => s_padded_read_addr,
			wraddress => s_padded_write_addr,
			wren => i_write_en,
			q => s_fb_out
		);
end architecture rtl;
