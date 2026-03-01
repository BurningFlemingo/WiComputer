library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_controller is 
	port (
		i_clk : in std_logic;
		i_rst : in std_logic;

		i_r : in std_logic_vector(3 downto 0);
		i_g : in std_logic_vector(3 downto 0);
		i_b : in std_logic_vector(3 downto 0);	
	
		o_r : out std_logic_vector(3 downto 0);
		o_g : out std_logic_vector(3 downto 0);
		o_b : out std_logic_vector(3 downto 0);

		o_x : out std_logic_vector(15 downto 0);
		o_y : out std_logic_vector(15 downto 0);

		o_hs : out std_logic;
		o_vs : out std_logic
	);
end entity;

architecture rtl of vga_controller is 
	-- for 25MHz pixel clock.
	constant c_hav_px_len : integer := 640;
	constant c_hfp_px_len : integer := 16;
	constant c_hs_px_len : integer := 96;

	constant c_vav_line_len : integer := 480;
	constant c_vfp_line_len : integer := 10;
	constant c_vs_line_len : integer := 2;
	
	constant c_hs_px_offset : integer := c_hav_px_len + c_hfp_px_len;
	constant c_vs_line_offset : integer := c_vav_line_len + c_vfp_line_len;

	constant c_px_per_line : integer := 800;
	constant c_lines_per_frame : integer := 525;
	
	signal r_px_ctr : integer := 0;
	signal r_line_ctr : integer := 0;
	
	signal r_px_tick : std_logic := '0';
	
	signal s_active_video : std_logic;
	
begin 
	o_hs <= '0' when r_px_ctr >= c_hs_px_offset and r_px_ctr < c_hs_px_offset + c_hs_px_len else '1';
	o_vs <= '0' when r_line_ctr >= c_vs_line_offset and r_line_ctr < c_vs_line_offset + c_vs_line_len else '1';
	
	s_active_video <= '1' when r_px_ctr < c_hav_px_len and r_line_ctr < c_vav_line_len else '0';

	o_r <= i_r when s_active_video = '1' else "0000";
	o_g <= i_g when s_active_video = '1' else "0000";
	o_b <= i_b when s_active_video = '1' else "0000";

	o_x <= std_logic_vector(to_unsigned(r_px_ctr, 16)) when s_active_video = '1' else (others => '0'); 
	o_y <= std_logic_vector(to_unsigned(r_line_ctr, 16)) when s_active_video = '1' else (others => '0'); 
	
	process(i_clk, i_rst) 
	begin 
		if i_rst = '1' then 
			r_px_tick <= '0';
			r_px_ctr <= 0;
			r_line_ctr <= 0;
		elsif rising_edge(i_clk) then 
			r_px_tick <= not r_px_tick;
			
			if r_px_tick = '1' then 
				if r_px_ctr < c_px_per_line-1 then 
					r_px_ctr <= r_px_ctr+1;
				else 
					r_px_ctr <= 0;
					
					if r_line_ctr < c_lines_per_frame-1 then 
						r_line_ctr <= r_line_ctr+1;
					else
						r_line_ctr <= 0;
					end if;
				end if; 
			end if;
		end if;
	end process;
	
	
end architecture rtl;
