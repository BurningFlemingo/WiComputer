library ieee; 
use ieee.std_logic_1164.all; 

entity control_unit is 
	port (
		i_opcode : in std_logic_vector(5 downto 0);
		i_funct : in std_logic_vector(5 downto 0);

		o_alu_op : out std_logic_vector(2 downto 0);
		o_reg_write_op : out std_logic;
		o_reg_dst_op : out std_logic;
		o_alu_src_op : out std_logic;
		o_mem_write_op : out std_logic;
		o_mem_to_reg_op : out std_logic;
		o_branch_op : out std_logic;
		o_invert_zero_op : out std_logic
	);
end entity control_unit; 

architecture rtl of control_unit is 
	signal s_funct_alu_op : std_logic_vector(2 downto 0);
begin 
	with i_funct select
		s_funct_alu_op <= "000" when "100000", 
						  "100" when "100110", 
						  "011" when "101010", 
						  "001" when "100010", 
						  "000" when others;
	with i_opcode select 
		o_alu_op <= s_funct_alu_op when "000000", 
					"000" when "001000" | "100011" | "101011", 
					"001" when  "000101" | "000100", 
					"000" when others;
			   
	with i_opcode select
		o_reg_write_op <= '0' when "101011" | "000101" | "000100", 
						'1' when others;

	o_reg_dst_op <= '1' when i_opcode = "000000" else '0';
	
	with i_opcode select
		o_alu_src_op <= '1' when "001000" | "100011" | "101011", 
						'0' when others;
	
	o_mem_write_op <= '1' when i_opcode = "101011" else '0';
	o_mem_to_reg_op <= '1' when i_opcode = "100011" else '0';
	o_branch_op <= '1' when i_opcode = "000101" or i_opcode = "000100" else '0';
	o_invert_zero_op <= '1' when i_opcode = "000101" else '0';
end architecture rtl;
