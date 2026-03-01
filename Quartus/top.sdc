create_clock -period 20 -name i_clk [get_ports {i_clk}]

derive_clock_uncertainty
