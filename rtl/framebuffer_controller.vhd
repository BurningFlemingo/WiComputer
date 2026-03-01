library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity framebuffer_controller is
	port(
		i_clk : in std_logic;
	
		i_x : in std_logic_vector(8 downto 0);
		i_y : in std_logic_vector(9 downto 0);

		i_write_en : in std_logic;

		i_data : in std_logic;
	
		o_data : out std_logic
	);
end entity framebuffer_controller;

architecture rtl of framebuffer_controller is 
	signal s_address : std_logic_vector(15 downto 0);

	signal s_fb_out : std_logic_vector(15 downto 0);
	signal s_patched : std_logic_vector(15 downto 0);
	
	signal s_px_out : std_logic;
	signal s_decoded_sub_addr : std_logic_vector(15 downto 0); -- the 3 downto 0 part of the address
	
begin 
	s_address <= '0' & i_y & i_x(8 downto 4);
	o_data <= s_px_out;

	decoder_inst : entity work.decoder 
		port map(
			i_encoded => i_x(3 downto 0), 
			o_decoded => s_decoded_sub_addr
		);
	
	-- BAD, but good for now
	framebuffer_inst : entity work.framebuffer 
		port map (
			address => s_address,
			clock => i_clk,
			data => s_patched,
			wren => i_write_en,
			q => s_fb_out
		);

	s_px_out <= s_fb_out(to_integer(unsigned((i_x(3 downto 0)))));
	s_patched <= (s_fb_out and not s_decoded_sub_addr) or ((15 downto 0 => i_data) and s_decoded_sub_addr);
end architecture rtl;
