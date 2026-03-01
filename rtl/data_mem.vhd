library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity data_mem is 
	port (
		i_clk : in std_logic;

		i_write_en : in std_logic;

		i_x : in std_logic_vector(7 downto 0);
		i_y : in std_logic_vector(6 downto 0);

		i_px_addr : in std_logic_vector(15 downto 0);
		
		i_addr : in std_logic_vector(15 downto 0);
		i_data : in std_logic_vector(31 downto 0);
	
		o_data : out std_logic_vector(31 downto 0);
		o_px_color : out std_logic_vector(11 downto 0)

	);
end entity data_mem; 

architecture rtl of data_mem is 
	type t_word_arr is array(0 to 15) of std_logic_vector(31 downto 0);
	
	signal r_main_mem : t_word_arr;
	signal s_write_framebuffer : std_logic;
	
	signal s_addr : integer;
begin 
	s_addr <= to_integer(unsigned(i_addr));
	
	o_data <= (31 downto 8 => '0') & i_x when s_addr = 0 else
			  (31 downto 7 => '0') & i_y when s_addr = 4 else
			  r_main_mem(to_integer(unsigned(i_addr(5 downto 2)))) when s_addr < 64 else 
			  (others => '0');

	s_write_framebuffer <= '1' when i_addr(15) = '1' and i_write_en = '1' else '0';

	framebuffer_controller_inst: entity work.framebuffer_controller
	 port map(
	    i_clk => i_clk,
		i_read_addr => i_px_addr(14 downto 0),
		i_write_addr => i_addr(14 downto 0),
	    i_write_en => s_write_framebuffer,
	    i_data => i_data(11 downto 0),
	    o_data => o_px_color
	);
	
	process(i_clk) 
	begin 
		if rising_edge(i_clk) then 
			if i_write_en = '1' then 
				if s_addr < 64 then 
					r_main_mem(to_integer(unsigned(i_addr(5 downto 2)))) <= i_data;
				end if;
			end if; 
		end if;
	end process;
	
end architecture rtl;
