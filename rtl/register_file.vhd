library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity register_file is
	port(
		i_clk : in std_logic; 
		i_rst : in std_logic; 
	
		i_write_en : in std_logic;
		
		i_addr_read1 : in std_logic_vector(4 downto 0);
		i_addr_read2 : in std_logic_vector(4 downto 0);
		i_addr_write : in std_logic_vector(4 downto 0);

		i_data_write : in std_logic_vector(31 downto 0);

		o_data_read1 : out std_logic_vector(31 downto 0);
		o_data_read2 : out std_logic_vector(31 downto 0)
		);
end entity register_file;

architecture rtl of register_file is 
	type t_word_arr is array (natural range<>) of std_logic_vector(31 downto 0);
	signal r_registers : t_word_arr(31 downto 0) := (others => (others => '0'));
begin 

	o_data_read1 <= r_registers(to_integer(unsigned(i_addr_read1)));
	o_data_read2 <= r_registers(to_integer(unsigned(i_addr_read2)));

	process(i_clk, i_rst)
	begin 
		if i_rst = '1' then 
			for i in 0 to 31 loop 
				r_registers(i) <= (31 downto 0 => '0');
			end loop;
		elsif rising_edge(i_clk) then 
			if i_write_en = '1' then 
				r_registers(to_integer(unsigned(i_addr_write))) <= i_data_write;
			end if;
		end if; 
	end process;
end architecture rtl;
