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

	signal s_px_addr : std_logic_vector(15 downto 0);

	signal r_program_ctr : std_logic_vector(31 downto 0);
	signal s_next_instruction_addr : std_logic_vector(31 downto 0);

	signal s_instruction_addr : std_logic_vector(31 downto 0);
	signal s_instruction : std_logic_vector(31 downto 0);

	signal s_reg_data_read1 : std_logic_vector(31 downto 0);
	signal s_reg_data_read2 : std_logic_vector(31 downto 0);

	signal s_mem_data_read : std_logic_vector(31 downto 0);

	signal s_alu_op : std_logic_vector(2 downto 0);
	signal s_reg_dst_op : std_logic;
	signal s_alu_src_op : std_logic;
	signal s_reg_write_op : std_logic;
	signal s_mem_write_op : std_logic;
	signal s_mem_to_reg_op : std_logic;
	signal s_branch_op : std_logic;
	signal s_invert_zero_op : std_logic;
	
	signal s_alu_result : std_logic_vector(31 downto 0);
	signal s_branch_addr : std_logic_vector(31 downto 0);

	signal s_sign_extended_imm : std_logic_vector(31 downto 0);
	signal s_shifted_imm : std_logic_vector(31 downto 0);
	signal s_alu_zero : std_logic;
	signal s_alu_b : std_logic_vector(31 downto 0);
	signal s_fixed_zero : std_logic;
	signal s_pc_src : std_logic;
	
	signal s_reg_addr_write : std_logic_vector(4 downto 0);

	signal s_wb : std_logic_vector(31 downto 0);
begin 
	s_rst <= not r_n_rst_sync;
	o_vs <= s_vs;
	s_n_vs <= not s_vs;

	s_sign_extended_imm <= (31 downto 16 => '0') & s_instruction(15 downto 0) when s_instruction(15) = '1' else -- only do unsigned immediates rn
						   (31 downto 16 => '0') & s_instruction(15 downto 0);
	
	s_shifted_imm <= s_sign_extended_imm(29 downto 0) & "00";
	
	s_alu_b <= s_reg_data_read2 when s_alu_src_op = '0' else 
			   s_sign_extended_imm;
	
	s_instruction_addr <= s_next_instruction_addr when s_pc_src = '0' else 
						  s_branch_addr;
	
	s_wb <= s_alu_result when s_mem_to_reg_op = '0' else 
			s_mem_data_read;
	
	s_reg_addr_write <= s_instruction(20 downto 16) when s_reg_dst_op = '0' else
						s_instruction(15 downto 11);

	s_fixed_zero <= s_alu_zero when s_invert_zero_op = '0' else 
					not s_alu_zero; 
	
	s_pc_src <= '1' when s_branch_op = '1' and s_fixed_zero = '1' else 
				'0';

	next_instruction_adder_inst: entity work.ripple_adder
	 generic map(
	    g_bit_size => 32
	)
	 port map(
	    i_subtract => '0',
	    i_a => (31 downto 3 => '0') & "100",
	    i_b => r_program_ctr,
	    o_result => s_next_instruction_addr
	);

	branch_address_inst: entity work.ripple_adder
	 generic map(
	    g_bit_size => 32
	)
	 port map(
	    i_subtract => '0',
	    i_a => s_next_instruction_addr,
	    i_b => s_shifted_imm,
	    o_result => s_branch_addr
	);

	instruction_mem_inst: entity work.instruction_mem
	 port map(
	    i_addr => r_program_ctr(9 downto 0),
	    o_instruction => s_instruction
	);

	control_unit_inst: entity work.control_unit 
	 port map(
		i_opcode => s_instruction(31 downto 26), 
		i_funct => s_instruction(5 downto 0),
		o_alu_op => s_alu_op,
		o_reg_write_op => s_reg_write_op, 
		o_reg_dst_op => s_reg_dst_op, 
		o_alu_src_op => s_alu_src_op, 
		o_mem_write_op => s_mem_write_op, 
		o_mem_to_reg_op => s_mem_to_reg_op, 
		o_branch_op => s_branch_op, 
		o_invert_zero_op => s_invert_zero_op
	);

	alu_inst: entity work.alu
	 port map(
	    i_op => s_alu_op,
	    i_a => s_reg_data_read1,
	    i_b => s_alu_b,
	    o_result => s_alu_result,
	    o_zero => s_alu_zero
	);

	register_file_inst: entity work.register_file
	 port map(
	    i_clk => i_clk,
	    i_rst => s_rst,
	    i_write_en => s_reg_write_op,
	    i_addr_read1 => s_instruction(25 downto 21),
	    i_addr_read2 => s_instruction(20 downto 16),
	    i_addr_write => s_reg_addr_write,
	    i_data_write => s_wb,
	    o_data_read1 => s_reg_data_read1,
	    o_data_read2 => s_reg_data_read2
	);

	data_mem_inst : entity work.data_mem 
	 port map (
		i_clk => i_clk,
		i_write_en => s_mem_write_op,
		i_x => s_x(7 downto 0),
		i_y => s_y(6 downto 0),
		i_px_addr => s_px_addr,
		i_addr => s_alu_result(15 downto 0),
		i_data => s_reg_data_read2,
		o_data => s_mem_data_read,
		o_px_color => s_px_color
	);


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
		
		o_px_addr => s_px_addr,

	    o_hs => o_hs,
	    o_vs => s_vs
	);

	process(i_clk) 
	begin 
		if rising_edge(i_clk) then 
			r_n_rst_meta <= i_n_rst_async;
			r_n_rst_sync <= r_n_rst_meta;
		end if; 
	end process;

	process(i_clk, s_rst) 
	begin 
		if s_rst = '1' then 
			r_program_ctr <= (others => '0'); 
		elsif rising_edge(i_clk) then 
			r_program_ctr <= s_instruction_addr;
		end if; 
	end process;
end architecture rtl;
