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

module ring_and_PEs_tb;


logic                           clk;
logic                           rst;

pos_packet_t [NUM_CELLS-1:0]    nb_pos_pkt;
logic        [NUM_CELLS-1:0]    nb_pos_pkt_valid;
logic        [NUM_CELLS-1:0]    disp_back_pressure;
logic [1:0] MD_state_w;
logic           [NUM_CELLS-1:0]                                         dirty_feedback;


logic         [PARTICLE_ID_WIDTH-1:0]               init_wr_addr;
offset_data_t [NUM_CELLS-1:0]                       init_data;
logic         [NUM_CELLS-1:0][ELEMENT_WIDTH-1:0]    init_element;
logic         [NUM_INIT_STEPS-1:0]                  init_wr_en;

force_packet_t  [NUM_CELLS-1:0]                                         dump_frc_data;
logic           [NUM_CELLS-1:0]                                         dump_frc_valid;
logic           [AXIS_TDATA_WIDTH-1:0]                                  dump_data_512;

offset_packet_t [NUM_CELLS-1:0]                                         raw_offset_pkt;
logic           [NUM_CELLS-1:0]         [3*GLOBAL_CELL_ID_WIDTH-1:0]    cur_gcid;
logic           [NUM_CELLS-1:0]                                         raw_offset_valid;
logic           [NUM_CELLS-1:0]                                         raw_offset_dirty;
logic           [NUM_CELLS-1:0]         [PARTICLE_ID_WIDTH-1:0]         debug_num_particles;
logic           [NUM_CELLS-1:0]                                         debug_all_dirty;

logic                                                                   debug_frc_eval_done;
float_data_t                                                            o_nb_frc;
logic         [PARTICLE_ID_WIDTH-1:0]                                   o_nb_frc_parid;
logic                                                                   o_nb_frc_valid;

always #1 clk <= ~clk;
initial begin
	clk <= 1'b0;
	rst <= 1'b1;
	MD_state_w <= 0;
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 0;
        init_data[i] <= 0;
        init_element[i] <= 1;
    end
    init_wr_en <= 0;
	
	#10
	rst <= 1'b0;
	MD_state_w <= 1;
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 0;
        init_data[i].offset_x <= 15;
        init_element[i] <= 1;
    end
    init_wr_en <= 2'b11;
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 1;
        init_data[i].offset_x <= 23'h080000;
        init_data[i].offset_y <= 23'h080000;
        init_data[i].offset_z <= 23'h080000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 2;
        init_data[i].offset_x <= 23'h100000;
        init_data[i].offset_y <= 23'h100000;
        init_data[i].offset_z <= 23'h100000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 3;
        init_data[i].offset_x <= 23'h180000;
        init_data[i].offset_y <= 23'h180000;
        init_data[i].offset_z <= 23'h180000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 4;
        init_data[i].offset_x <= 23'h200000;
        init_data[i].offset_y <= 23'h200000;
        init_data[i].offset_z <= 23'h200000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 5;
        init_data[i].offset_x <= 23'h280000;
        init_data[i].offset_y <= 23'h280000;
        init_data[i].offset_z <= 23'h280000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 6;
        init_data[i].offset_x <= 23'h300000;
        init_data[i].offset_y <= 23'h300000;
        init_data[i].offset_z <= 23'h300000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 7;
        init_data[i].offset_x <= 23'h380000;
        init_data[i].offset_y <= 23'h380000;
        init_data[i].offset_z <= 23'h380000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 8;
        init_data[i].offset_x <= 23'h400000;
        init_data[i].offset_y <= 23'h400000;
        init_data[i].offset_z <= 23'h400000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 9;
        init_data[i].offset_x <= 23'h480000;
        init_data[i].offset_y <= 23'h480000;
        init_data[i].offset_z <= 23'h480000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 10;
        init_data[i].offset_x <= 23'h500000;
        init_data[i].offset_y <= 23'h500000;
        init_data[i].offset_z <= 23'h500000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 11;
        init_data[i].offset_x <= 23'h580000;
        init_data[i].offset_y <= 23'h580000;
        init_data[i].offset_z <= 23'h580000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 12;
        init_data[i].offset_x <= 23'h600000;
        init_data[i].offset_y <= 23'h600000;
        init_data[i].offset_z <= 23'h600000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 13;
        init_data[i].offset_x <= 23'h680000;
        init_data[i].offset_y <= 23'h680000;
        init_data[i].offset_z <= 23'h680000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 14;
        init_data[i].offset_x <= 23'h700000;
        init_data[i].offset_y <= 23'h700000;
        init_data[i].offset_z <= 23'h700000;
    end
	
	#2
    for (int i = 0; i < NUM_CELLS; i++) begin
        init_wr_addr <= 15;
        init_data[i].offset_x <= 23'h780000;
        init_data[i].offset_y <= 23'h780000;
        init_data[i].offset_z <= 23'h780000;
    end
    
    #2
    init_wr_en <= 0;
    
    #10
    MD_state_w <= 3;
    
    #1000
    debug_frc_eval_done <= 1'b1;
    
end


all_pos_caches all_pos_caches
(
    .clk                    ( clk                     ), 
    .rst                    ( rst                     ), 
	.i_PE_start             ( MD_state_w == 3         ),
    .i_init_wr_addr         ( init_wr_addr            ), 
    .i_init_data            ( init_data               ), 
    .i_init_element         ( init_element            ),
    .i_init_wr_en           ( init_wr_en              ), 
    .i_dirty                ( dirty_feedback          ),
    
    .o_pos_pkt              ( raw_offset_pkt          ),
    .o_cur_gcid             ( cur_gcid                ),
    .o_valid                ( raw_offset_valid        ),
    .o_dirty                ( raw_offset_dirty        ),
    .o_debug_num_particles  ( debug_num_particles     ),
    .o_debug_all_dirty      ( debug_all_dirty         )
);

pos_input_ring inst_pos_input_ring (
    .clk                        ( clk                   ), 
    .rst                        ( rst                   ),
    .local_offset_pkt           ( raw_offset_pkt        ),
    .local_gcid                 ( cur_gcid              ),
    .local_valid                ( raw_offset_valid      ),
    .local_dirty                ( raw_offset_dirty      ),
    .dispatcher_back_pressure   ( 8'h00    ),
    
    .pos_pkt_to_pe              ( nb_pos_pkt            ),
    .pos_pkt_to_pe_valid        ( nb_pos_pkt_valid      ),
    .dirty_feedback             ( dirty_feedback        )
);

//genvar j;
//generate
//	for (j = 0; j < 2; j++) begin: PEs
//		PE inst_PE (
//			.clk                 ( ap_clk                    ), 
//			.rst                 ( ~ap_rst_n                 ), 
			
//			.home_offset         ( raw_offset_pkt[j]         ), 
//			.home_offset_valid   ( raw_offset_valid[j]       ), 
//			.nb_pos              ( nb_pos_pkt[j]             ), 
//			.nb_pos_valid        ( nb_pos_pkt_valid[j]       ), 
			
//			.home_frc            (   ), 
//			.home_frc_parid      (   ),
//			.home_frc_valid      (   ),
//			.nb_frc_acc          ( dump_frc_data[j]          ), 
//			.nb_frc_acc_valid    ( dump_frc_valid[j]         ),
//			.disp_back_pressure  ( disp_back_pressure[j]     )
//		);
//	end
//endgenerate
//PE inst_PE_0 (
//    .clk                 ( clk                       ), 
//    .rst                 ( rst                       ), 
    
//    .home_offset         ( raw_offset_pkt[0]         ), 
//    .home_offset_valid   ( raw_offset_valid[0]       ), 
//    .nb_pos              ( nb_pos_pkt[0]             ), 
//    .nb_pos_valid        ( nb_pos_pkt_valid[0]       ), 
    
//    .home_frc            (   ), 
//    .home_frc_parid      (   ),
//    .home_frc_valid      (   ),
//    .nb_frc_acc          ( dump_frc_data[0]          ), 
//    .nb_frc_acc_valid    ( dump_frc_valid[0]         ),
//    .disp_back_pressure  ( disp_back_pressure[0]     )
//);

PE inst_PE_1 (
    .clk                 ( clk                       ), 
    .rst                 ( rst                       ), 
    
    .home_offset         ( raw_offset_pkt[1]         ), 
    .home_offset_valid   ( raw_offset_valid[1]       ), 
    .nb_pos              ( nb_pos_pkt[1]             ), 
    .nb_pos_valid        ( nb_pos_pkt_valid[1]       ), 
    
    .home_frc            (   ), 
    .home_frc_parid      (   ),
    .home_frc_valid      (   ),
    .nb_frc_acc          ( dump_frc_data[1]          ), 
    .nb_frc_acc_valid    ( dump_frc_valid[1]         ),
    .disp_back_pressure  ( disp_back_pressure[1]     )
);

force_cache_control inst_force_cache_control
(
    .clk(clk),
    .rst(rst),
    .debug_frc_eval_done(debug_frc_eval_done),
    .i_home_frc(),
    .i_home_frc_valid(),
    .i_home_frc_parid(),
    .i_nb_frc(),//dump_frc_data[1].f),
    .i_nb_frc_valid(dump_frc_valid[1]),
    .i_nb_frc_parid(dump_frc_data[1].parid),
    
    .o_home_frc(),
    .o_nb_frc(o_nb_frc),
    .o_home_frc_parid       (        ),
    .o_home_frc_valid       (        ),
    .o_home_buf_almost_full (    ),
    .o_home_buf_empty       (          ),
    .o_nb_frc_parid         ( o_nb_frc_parid         ),
    .o_nb_frc_valid         ( o_nb_frc_valid         ),
    .o_nb_buf_almost_full   (      ),
    .o_nb_buf_empty         (            )
);
//PE inst_PE_2 (
//    .clk                 ( clk                       ), 
//    .rst                 ( rst                       ), 
    
//    .home_offset         ( raw_offset_pkt[2]         ), 
//    .home_offset_valid   ( raw_offset_valid[2]       ), 
//    .nb_pos              ( nb_pos_pkt[2]             ), 
//    .nb_pos_valid        ( nb_pos_pkt_valid[2]       ), 
    
//    .home_frc            (   ), 
//    .home_frc_parid      (   ),
//    .home_frc_valid      (   ),
//    .nb_frc_acc          ( dump_frc_data[2]          ), 
//    .nb_frc_acc_valid    ( dump_frc_valid[2]         ),
//    .disp_back_pressure  ( disp_back_pressure[2]     )
//);

//PE inst_PE_3 (
//    .clk                 ( clk                       ), 
//    .rst                 ( rst                       ), 
    
//    .home_offset         ( raw_offset_pkt[3]         ), 
//    .home_offset_valid   ( raw_offset_valid[3]       ), 
//    .nb_pos              ( nb_pos_pkt[3]             ), 
//    .nb_pos_valid        ( nb_pos_pkt_valid[3]       ), 
    
//    .home_frc            (   ), 
//    .home_frc_parid      (   ),
//    .home_frc_valid      (   ),
//    .nb_frc_acc          ( dump_frc_data[3]          ), 
//    .nb_frc_acc_valid    ( dump_frc_valid[3]         ),
//    .disp_back_pressure  ( disp_back_pressure[3]     )
//);

//PE inst_PE_4 (
//    .clk                 ( clk                       ), 
//    .rst                 ( rst                       ), 
    
//    .home_offset         ( raw_offset_pkt[4]         ), 
//    .home_offset_valid   ( raw_offset_valid[4]       ), 
//    .nb_pos              ( nb_pos_pkt[4]             ), 
//    .nb_pos_valid        ( nb_pos_pkt_valid[4]       ), 
    
//    .home_frc            (   ), 
//    .home_frc_parid      (   ),
//    .home_frc_valid      (   ),
//    .nb_frc_acc          ( dump_frc_data[4]          ), 
//    .nb_frc_acc_valid    ( dump_frc_valid[4]         ),
//    .disp_back_pressure  ( disp_back_pressure[4]     )
//);

//PE inst_PE_5 (
//    .clk                 ( clk                       ), 
//    .rst                 ( rst                       ), 
    
//    .home_offset         ( raw_offset_pkt[5]         ), 
//    .home_offset_valid   ( raw_offset_valid[5]       ), 
//    .nb_pos              ( nb_pos_pkt[5]             ), 
//    .nb_pos_valid        ( nb_pos_pkt_valid[5]       ), 
    
//    .home_frc            (   ), 
//    .home_frc_parid      (   ),
//    .home_frc_valid      (   ),
//    .nb_frc_acc          ( dump_frc_data[5]          ), 
//    .nb_frc_acc_valid    ( dump_frc_valid[5]         ),
//    .disp_back_pressure  ( disp_back_pressure[5]     )
//);

//PE inst_PE_6 (
//    .clk                 ( clk                       ), 
//    .rst                 ( rst                       ), 
    
//    .home_offset         ( raw_offset_pkt[6]         ), 
//    .home_offset_valid   ( raw_offset_valid[6]       ), 
//    .nb_pos              ( nb_pos_pkt[6]             ), 
//    .nb_pos_valid        ( nb_pos_pkt_valid[6]       ), 
    
//    .home_frc            (   ), 
//    .home_frc_parid      (   ),
//    .home_frc_valid      (   ),
//    .nb_frc_acc          ( dump_frc_data[6]          ), 
//    .nb_frc_acc_valid    ( dump_frc_valid[6]         ),
//    .disp_back_pressure  ( disp_back_pressure[6]     )
//);

//PE inst_PE_7 (
//    .clk                 ( clk                       ), 
//    .rst                 ( rst                       ), 
    
//    .home_offset         ( raw_offset_pkt[7]         ), 
//    .home_offset_valid   ( raw_offset_valid[7]       ), 
//    .nb_pos              ( nb_pos_pkt[7]             ), 
//    .nb_pos_valid        ( nb_pos_pkt_valid[7]       ), 
    
//    .home_frc            (   ), 
//    .home_frc_parid      (   ),
//    .home_frc_valid      (   ),
//    .nb_frc_acc          ( dump_frc_data[7]          ), 
//    .nb_frc_acc_valid    ( dump_frc_valid[7]         ),
//    .disp_back_pressure  ( disp_back_pressure[7]     )
//);
endmodule
