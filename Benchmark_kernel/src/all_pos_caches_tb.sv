//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 09:59:06 PM
// Design Name: 
// Module Name: pos_input_ring_node_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;  

module all_pos_caches_tb;

logic clk;
logic rst;

logic                                                           i_PE_start;
logic                                                           i_MU_working;
logic  [PARTICLE_ID_WIDTH-1:0]                                  i_init_wr_addr;
offset_data_t                   [NUM_CELLS-1:0]                 i_init_data;
logic  [NUM_CELLS-1:0]          [ELEMENT_WIDTH-1:0]             i_init_element;
logic  [NUM_INIT_STEPS-1:0]                                     i_init_wr_en;
logic  [NUM_CELLS-1:0]                                          i_dirty;
logic  [NUM_CELLS-1:0]          [PARTICLE_ID_WIDTH-1:0]         i_MU_rd_addr;
logic  [NUM_CELLS-1:0]                                          i_MU_rd_en;
logic  [NUM_CELLS-1:0]                                          i_MU_wr_en;
offset_data_t                   [NUM_CELLS-1:0]                 i_MU_wr_pos;
logic  [NUM_CELLS-1:0]          [ELEMENT_WIDTH-1:0]             i_MU_wr_element;

offset_packet_t                 [NUM_CELLS-1:0]                 o_pos_pkt;
logic [NUM_CELLS-1:0]           [3*GLOBAL_CELL_ID_WIDTH-1:0]    o_cur_gcid;
logic [NUM_CELLS-1:0]                                           o_valid;
logic [NUM_CELLS-1:0]                                           o_MU_offset_valid;
logic [NUM_CELLS-1:0]                                           o_dirty;
logic [NUM_CELLS-1:0]           [PARTICLE_ID_WIDTH-1:0]         o_debug_num_particles;
logic [NUM_CELLS-1:0]                                           o_debug_all_dirty;

always #1 clk <= ~clk;
initial begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_PE_start <= 0;
	i_init_wr_addr <= 0;
	i_init_data <= 0;
	i_init_element <= 0;
	i_init_wr_en <= 0;
	i_dirty <= 0;
	i_MU_rd_addr <= 0;
	i_MU_rd_en <= 0;
	i_MU_wr_en <= 0;
	i_MU_wr_pos <= 0;
	i_MU_wr_element <= 0;
	
	#10
	rst <= 1'b0;
	
	#10
	i_init_wr_addr <= 0;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 15;
	   i_init_data[i].offset_y <= 0;
	   i_init_data[i].offset_z <= 0;
	end
	i_init_element <= 0;
	i_init_wr_en <= 2'b11;
	
	#2
	i_init_wr_addr <= 1;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h080000;
	   i_init_data[i].offset_y <= 23'h080000;
	   i_init_data[i].offset_z <= 23'h080000;
	   i_init_element[i] <= 1;
	end
	
	#2
	i_init_wr_addr <= 2;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h100000;
	   i_init_data[i].offset_y <= 23'h100000;
	   i_init_data[i].offset_z <= 23'h100000;
	end
	
	#2
	i_init_wr_addr <= 3;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h180000;
	   i_init_data[i].offset_y <= 23'h180000;
	   i_init_data[i].offset_z <= 23'h180000;
	end
	
	#2
	i_init_wr_addr <= 4;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h200000;
	   i_init_data[i].offset_y <= 23'h200000;
	   i_init_data[i].offset_z <= 23'h200000;
	end
	
	#2
	i_init_wr_addr <= 5;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h280000;
	   i_init_data[i].offset_y <= 23'h280000;
	   i_init_data[i].offset_z <= 23'h280000;
	end
	
	#2
	i_init_wr_addr <= 6;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h300000;
	   i_init_data[i].offset_y <= 23'h300000;
	   i_init_data[i].offset_z <= 23'h300000;
	end
	
	#2
	i_init_wr_addr <= 7;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h380000;
	   i_init_data[i].offset_y <= 23'h380000;
	   i_init_data[i].offset_z <= 23'h380000;
	end
	
	#2
	i_init_wr_addr <= 8;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h400000;
	   i_init_data[i].offset_y <= 23'h400000;
	   i_init_data[i].offset_z <= 23'h400000;
	end
	
	#2
	i_init_wr_addr <= 9;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h480000;
	   i_init_data[i].offset_y <= 23'h480000;
	   i_init_data[i].offset_z <= 23'h480000;
	end
	
	#2
	i_init_wr_addr <= 10;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h500000;
	   i_init_data[i].offset_y <= 23'h500000;
	   i_init_data[i].offset_z <= 23'h500000;
	end
	
	#2
	i_init_wr_addr <= 11;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h580000;
	   i_init_data[i].offset_y <= 23'h580000;
	   i_init_data[i].offset_z <= 23'h580000;
	end
	
	#2
	i_init_wr_addr <= 12;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h600000;
	   i_init_data[i].offset_y <= 23'h600000;
	   i_init_data[i].offset_z <= 23'h600000;
	end
	
	#2
	i_init_wr_addr <= 13;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h680000;
	   i_init_data[i].offset_y <= 23'h680000;
	   i_init_data[i].offset_z <= 23'h680000;
	end
	
	#2
	i_init_wr_addr <= 14;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h700000;
	   i_init_data[i].offset_y <= 23'h700000;
	   i_init_data[i].offset_z <= 23'h700000;
	end
	
	#2
	i_init_wr_addr <= 15;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_init_data[i].offset_x <= 23'h780000;
	   i_init_data[i].offset_y <= 23'h780000;
	   i_init_data[i].offset_z <= 23'h780000;
	end
	
	#2
	i_init_wr_en <= 0;
	
	#20
	i_MU_working <= 1'b1;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_MU_rd_addr[i] <= 0;
	   i_MU_rd_en[i]   <= 1'b1;
	end
	
	#2
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_MU_rd_addr[i]         <= 1;
	   i_MU_wr_en[i]           <= 1'b1;
	   i_MU_wr_pos[i].offset_x <= 23'h400000;
	   i_MU_wr_pos[i].offset_y <= 23'h400000;
	   i_MU_wr_pos[i].offset_z <= 23'h400000;
	   i_MU_wr_element[i]      <= 1;
	end
	
	#2
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_MU_rd_addr[i]         <= 2;
	   i_MU_wr_pos[i].offset_x <= 23'h400001;
	   i_MU_wr_pos[i].offset_y <= 23'h400001;
	   i_MU_wr_pos[i].offset_z <= 23'h400001;
	end
	
	#2
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_MU_rd_addr[i]         <= 3;
	   i_MU_wr_pos[i].offset_x <= 23'h400002;
	   i_MU_wr_pos[i].offset_y <= 23'h400002;
	   i_MU_wr_pos[i].offset_z <= 23'h400002;
	end
	
	#2
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_MU_rd_addr[i]         <= 4;
	   i_MU_wr_pos[i].offset_x <= 23'h400003;
	   i_MU_wr_pos[i].offset_y <= 23'h400003;
	   i_MU_wr_pos[i].offset_z <= 23'h400003;
	end
	
	#2
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_MU_rd_addr[i]         <= 5;
	   i_MU_wr_pos[i].offset_x <= 23'h400004;
	   i_MU_wr_pos[i].offset_y <= 23'h400004;
	   i_MU_wr_pos[i].offset_z <= 23'h400004;
	end
	
	#2
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_MU_rd_en[i]           <= 1'b0;
	   i_MU_wr_pos[i].offset_x <= 23'h400005;
	   i_MU_wr_pos[i].offset_y <= 23'h400005;
	   i_MU_wr_pos[i].offset_z <= 23'h400005;
	end
	
	#2
	i_MU_working <= 1'b0;
	for (int i = 0; i < NUM_CELLS; i++) begin
	   i_MU_wr_en[i]           <= 1'b0;
	end
	
	#20
	i_PE_start <= 1'b1;
end

all_pos_caches all_pos_caches
(
    .clk                    ( clk                       ), 
    .rst                    ( rst                       ), 
	.i_PE_start             ( i_PE_start                ),
	.i_MU_working           ( i_MU_working              ),
    .i_init_wr_addr         ( i_init_wr_addr            ), 
    .i_init_data            ( i_init_data               ), 
    .i_init_element         ( i_init_element            ),
    .i_init_wr_en           ( i_init_wr_en              ), 
    .i_dirty                ( i_dirty                   ),
    .i_MU_rd_addr           ( i_MU_rd_addr              ), 
    .i_MU_rd_en             ( i_MU_rd_en                ), 
    .i_MU_wr_en             ( i_MU_wr_en                ),
    .i_MU_wr_pos            ( i_MU_wr_pos               ), 
    .i_MU_wr_element        ( i_MU_wr_element           ),
    
    .o_pos_pkt              ( o_pos_pkt                 ),
    .o_cur_gcid             ( o_cur_gcid                ),
    .o_valid                ( o_valid                   ),
    .o_dirty                ( o_dirty                   ),
    .o_MU_offset_valid      ( o_MU_offset_valid         ),
    .o_debug_num_particles  ( o_debug_num_particles     ),
    .o_debug_all_dirty      ( o_debug_all_dirty         )
);

endmodule
