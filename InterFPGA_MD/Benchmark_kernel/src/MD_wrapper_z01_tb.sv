`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: 
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

import MD_pkg::*;   // Change OFFSET_WIDTH to 30 before simulating, or change the test cases below. 

module MD_wrapper_z01_tb;

logic                                 ap_clk;
logic                                 ap_rst_n;

// AXI4-Stream network layer to streaming kernel 
logic       [AXIS_TDATA_WIDTH-1:0]    S_AXIS_n2k_pos_tdata;
logic     [AXIS_TDATA_WIDTH/8-1:0]    S_AXIS_n2k_pos_tkeep;
logic                                 S_AXIS_n2k_pos_tvalid;
logic                                 S_AXIS_n2k_pos_tlast;
logic  [STREAMING_TDEST_WIDTH-1:0]    S_AXIS_n2k_pos_tdest;
logic                                 S_AXIS_n2k_pos_tready;
// AXI4-Stream streaming kernel to network layer
logic       [AXIS_TDATA_WIDTH-1:0]    k2n_pos_tdata;
logic     [AXIS_TDATA_WIDTH/8-1:0]    k2n_pos_tkeep;
logic                                 k2n_pos_tvalid;
logic                                 k2n_pos_tlast;
logic  [STREAMING_TDEST_WIDTH-1:0]    k2n_pos_tdest;
logic                                 k2n_pos_tready;

// AXI4-Stream network layer to streaming kernel 
logic       [AXIS_TDATA_WIDTH-1:0]    S_AXIS_n2k_frc_tdata;
logic     [AXIS_TDATA_WIDTH/8-1:0]    S_AXIS_n2k_frc_tkeep;
logic                                 S_AXIS_n2k_frc_tvalid;
logic                                 S_AXIS_n2k_frc_tlast;
logic  [STREAMING_TDEST_WIDTH-1:0]    S_AXIS_n2k_frc_tdest;
logic                                 S_AXIS_n2k_frc_tready;
// AXI4-Stream streaming kernel to network layer
logic       [AXIS_TDATA_WIDTH-1:0]    k2n_frc_tdata;
logic     [AXIS_TDATA_WIDTH/8-1:0]    k2n_frc_tkeep;
logic                                 k2n_frc_tvalid;
logic                                 k2n_frc_tlast;
logic  [STREAMING_TDEST_WIDTH-1:0]    k2n_frc_tdest;
logic                                 k2n_frc_tready;

// AXI4-Stream host to streaming kernel 
logic       [AXIS_TDATA_WIDTH-1:0]    S_AXIS_h2k_tdata;
logic     [AXIS_TDATA_WIDTH/8-1:0]    S_AXIS_h2k_tkeep;
logic                                 S_AXIS_h2k_tvalid;
logic                                 S_AXIS_h2k_tlast;
logic  [STREAMING_TDEST_WIDTH-1:0]    S_AXIS_h2k_tdest;
logic                                 S_AXIS_h2k_tready;
// AXI4-Stream streaming kernel to host
logic       [AXIS_TDATA_WIDTH-1:0]    M_AXIS_k2h_tdata;
logic     [AXIS_TDATA_WIDTH/8-1:0]    M_AXIS_k2h_tkeep;
logic                                 M_AXIS_k2h_tvalid;
logic                                 M_AXIS_k2h_tlast;
logic  [STREAMING_TDEST_WIDTH-1:0]    M_AXIS_k2h_tdest;
logic                                 M_AXIS_k2h_tready;

logic                         [2:0]   MD_state_w;
logic   [STREAMING_TDEST_WIDTH-1:0]   dest_id_w;
logic   [STREAMING_TDEST_WIDTH-1:0]   init_id_w;
logic       [PARTICLE_ID_WIDTH-1:0]   init_npc_w;
logic         [INIT_STEP_WIDTH-1:0]   dump_bank_sel_w;
logic             [NUM_FILTERS-1:0]   dump_filter_sel_w;
logic                        [31:0]   iter_target_w;
logic                                 network_pos_free;
logic                                 network_frc_free;

logic                                 fifo_pos_full;
logic                                 fifo_frc_full;
logic                                 all_pos_ring_nodes_empty;
logic                                 all_disp_back_pressure;
logic                                 all_dirty;
logic                                 home_buf_almost_full;
logic                                 nb_buf_almost_full;
logic                                 all_frc_output_ring_buf_empty;
logic                                 all_frc_output_ring_done;
logic                                 all_home_buf_empty;
logic                                 all_nb_buf_empty;
logic                                 all_disp_buf_empty;
logic                                 MU_buf_almost_full;
logic                                 all_MU_buf_empty;
logic                                 MU_spinning;
logic                                 MU_reading;
logic                                 MU_writing;
logic                                 MU_busy;
logic [4:0]                           MU_busy_cnt;
logic [3:0]                           pos_state;
logic                                 MU_started;
logic                                 MU_frc_once_valid;
logic                                 MU_offset_once_valid;
logic                                 MU_vel_once_valid;
logic                                 MU_once_writing;
logic                                 MU_once_reading;
logic                                 chk_nb_frc;
logic                                 chk_home_frc;
logic                                 chk_MU_vel_out;
logic                                 chk_MU_vel_produced;
logic                                 chk_MU_offset_in;
logic [PARTICLE_ID_WIDTH-1:0]         MU_num_particles;
logic [PARTICLE_ID_WIDTH-1:0]         MU_rd_cnt;
logic [31:0]                          iter_cnt;
logic [31:0]                          operation_cycle_cnt;
logic                                 MU_debug_migration_flag;
logic [31:0]                          num_particles_0;
logic [31:0]                          num_particles_1;
logic [31:0]                          num_particles_2;
logic [31:0]                          num_particles_3;
logic [31:0]                          num_particles_4;
logic [31:0]                          num_particles_5;
logic [31:0]                          num_particles_6;
logic [31:0]                          num_particles_7;
logic [INIT_STEP_WIDTH-1:0]           init_step;
logic [PARTICLE_ID_WIDTH-1:0]         init_wr_addr;
logic                                 remote_pos_buf_once_full;
logic                                 remote_frc_buf_once_full;
logic [31:0]                          last_pos_sent;
logic [31:0]                          last_frc_sent;
logic [31:0]                          pos_pkt_to_remote_valid_cntr;
logic [31:0]                          frc_pkt_to_remote_valid_cntr;
logic [31:0]                          remote_pos_tvalid_cntr;
logic [31:0]                          remote_frc_tvalid_cntr;
logic [31:0]                          last_pos_cntr;
logic [31:0]                          last_frc_cntr;
logic                                 pos_burst_running;
logic                                 frc_burst_running;

logic [31:0]                          pos_dummy_data;
logic [31:0]                          frc_dummy_data;

logic                                 all_filter_once_back_pressure;
logic                                 all_frc_output_ring_buf_once_full;
logic [31:0]                          pos_ring_cycle_cnt;
logic [31:0]                          frc_ring_cycle_cnt;
logic [31:0]                          filter_cycle_cnt;   // Divide by # of filters to get avg. filter cycles 
logic [31:0]                          PE_cycle_cnt;
logic [31:0]                          MU_cycle_cnt;
logic [31:0]                          MU_start_cnt;
logic [31:0]                          dest_cntr_0;
logic [31:0]                          dest_cntr_1;
logic [31:0]                          dest_cntr_4;
logic [31:0]                          dest_cntr_5;
logic [31:0]                          dest_x_cntr;
logic [31:0]                          dest_z_cntr;
logic [31:0]                          dest_xz_cntr;
logic                                 d_remote_pos_buf_empty;
logic                                 d_remote_frc_buf_empty;
logic                                 d_fifo_pos_empty;
logic                                 d_fifo_frc_empty;
logic                                 d_ring_pos_to_remote_bufs_empty;
logic [31:0]                          remote_frc_buf_ack_cntr;
logic [31:0]                          xcv_cooldown_cycles_w;

logic [PARTICLE_ID_WIDTH-1:0]         particle_id;

always #1 ap_clk <= ~ap_clk;
initial
	begin
	ap_clk <= 1'b0;
	ap_rst_n <= 1'b0;
	
	S_AXIS_h2k_tdata <= 0;
	S_AXIS_h2k_tkeep <= 0;
	S_AXIS_h2k_tvalid <= 0;
	S_AXIS_h2k_tlast <= 0;
	S_AXIS_h2k_tdest <= 0;
	M_AXIS_k2h_tready <= 0;
	
	S_AXIS_n2k_pos_tdata <= 0;
	S_AXIS_n2k_pos_tkeep <= 0;
	S_AXIS_n2k_pos_tvalid <= 0;
	S_AXIS_n2k_pos_tlast <= 0;
	S_AXIS_n2k_pos_tdest <= 0;
	k2n_pos_tready <= 0;
	
	S_AXIS_n2k_frc_tdata <= 0;
	S_AXIS_n2k_frc_tkeep <= 0;
	S_AXIS_n2k_frc_tvalid <= 0;
	S_AXIS_n2k_frc_tlast <= 0;
	S_AXIS_n2k_frc_tdest <= 0;
	k2n_frc_tready <= 0;
	
	MD_state_w <= 0;
	dest_id_w <= 0;
	init_id_w <= 0;
	init_npc_w <= 0;
	dump_bank_sel_w <= 0;
	particle_id <= 0;
	dump_filter_sel_w <= 0;
	
	pos_dummy_data <= 32'h00080000;
	frc_dummy_data <= 32'h3f800000;

/////////////////////////////////////////////////////
// Test
/////////////////////////////////////////////////////
    #10
    init_id_w <= 7;
	init_npc_w <= 15;
	xcv_cooldown_cycles_w <= 2;
    
	#100
	ap_rst_n <= 1;
	
	#10
	MD_state_w <= 1;
	network_pos_free <= 1;
	network_frc_free <= 1;
	iter_target_w <= 3;
	
	repeat (7) begin
        #2
        S_AXIS_n2k_pos_tdata  <= {(16){32'h0000000F}};
        S_AXIS_n2k_pos_tkeep <= 0;
        S_AXIS_n2k_pos_tvalid <= 1;
        S_AXIS_n2k_pos_tlast <= 1;
        S_AXIS_n2k_pos_tdest <= 0;
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00080000,32'h00080000,32'h00080000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00100000,32'h00100000,32'h00100000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00180000,32'h00180000,32'h00180000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00200000,32'h00200000,32'h00200000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00280000,32'h00280000,32'h00280000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00300000,32'h00300000,32'h00300000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00380000,32'h00380000,32'h00380000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00400000,32'h00400000,32'h00400000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00480000,32'h00480000,32'h00480000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00500000,32'h00500000,32'h00500000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00580000,32'h00580000,32'h00580000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00600000,32'h00600000,32'h00600000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00680000,32'h00680000,32'h00680000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00700000,32'h00700000,32'h00700000}};
        #2 S_AXIS_n2k_pos_tdata  <= {(4){32'h00000001,32'h00780000,32'h00780000,32'h00780000}};
	end
	#2
	S_AXIS_n2k_pos_tvalid <= 0;
	
	#10
	MD_state_w <= 2;
	
	#40
//	 header = {0000000 parid element gcid lifetime last} gcid {z, y, x}
//     from (0,0,0), node 0
//     header = {0000000 000000010 01 00/0000/010 0/001 1} 00024043, (200)  1
//     header = {0000000 000000010 01 01/0000/010 0/001 1} 00025043, (202)  1
//     header = {0000000 000000010 01 00/0010/010 0/001 1} 00024243, (220)  1
//     header = {0000000 000000010 01 01/0010/010 0/001 1} 00025243, (222)  1

//     from (0,0,1), node 1
//     header = {0000000 000000010 01 01/1000/010 0/010 1} 00025845, (203)  2
//     header = {0000000 000000010 01 10/0000/010 0/011 1} 00026047, (204)  3
//     header = {0000000 000000010 01 10/1000/010 0/010 1} 00026845, (205)  2
//     header = {0000000 000000010 01 01/1010/010 0/010 1} 00025a45, (223)  2
//     header = {0000000 000000010 01 10/0010/010 0/011 1} 00026247, (224)  3
//     header = {0000000 000000010 01 10/1010/010 0/010 1} 00026a45, (225)  2

//     from (0,1,0), node 2
//     header = {0000000 000000010 01 00/0011/010 0/010 1} 00024345, (230)  2
//     header = {0000000 000000010 01 01/0011/010 0/010 1} 00025345, (232)  2
//     header = {0000000 000000010 01 00/0100/010 0/011 1} 00024447, (240)  3
//     header = {0000000 000000010 01 01/0100/010 0/011 1} 00025447, (242)  3
//     header = {0000000 000000010 01 00/0101/010 0/010 1} 00024545, (250)  2
//     header = {0000000 000000010 01 01/0101/010 0/010 1} 00025545, (252)  2

//     from (0,1,1), node 3
//     header = {0000000 000000010 01 01/1011/010 0/100 1} 00025b49, (233)  4
//     header = {0000000 000000010 01 10/0011/010 0/110 1} 0002634d, (234)  6
//     header = {0000000 000000010 01 10/1011/010 0/100 1} 00026b49, (235)  4
//     header = {0000000 000000010 01 01/1100/010 0/110 1} 00025c4d, (243)  6
//     header = {0000000 000000010 01 10/0100/010 1/001 1} 00026553, (244)  9
//     header = {0000000 000000010 01 10/1100/010 0/110 1} 00026c4d, (245)  6
//     header = {0000000 000000010 01 01/1101/010 0/100 1} 00025d49, (253)  4
//     header = {0000000 000000010 01 10/0101/010 0/110 1} 0002654d, (254)  6
//     header = {0000000 000000010 01 10/1101/010 0/100 1} 00026d49, (255)  4

//     from (1,0,0), node 4
//     header = {0000000 000000010 01 00/0000/011 0/001 1} 00024063, (300)  1
//     header = {0000000 000000010 01 01/0000/011 0/001 1} 00025063, (302)  1
//     header = {0000000 000000010 01 00/0010/011 0/010 1} 00024265, (320)  2
//     header = {0000000 000000010 01 01/0010/011 0/010 1} 00025265, (322)  2
//     header = {0000000 000000010 01 00/0000/100 0/001 1} 00024083, (400)  1
//     header = {0000000 000000010 01 01/0000/100 0/001 1} 00025083, (402)  1
//     header = {0000000 000000010 01 00/0010/100 0/010 1} 00024285, (420)  2
//     header = {0000000 000000010 01 01/0010/100 0/010 1} 00025285, (422)  2
//     header = {0000000 000000010 01 00/0010/101 0/001 1} 000242a3, (520)  1
//     header = {0000000 000000010 01 01/0010/101 0/001 1} 000252a3, (522)  1

//     from (1,0,1), node 5
//     header = {0000000 000000010 01 01/1000/011 0/010 1} 00025865, (303)  2
//     header = {0000000 000000010 01 10/0000/011 0/011 1} 00026067, (304)  3
//     header = {0000000 000000010 01 10/1000/011 0/010 1} 00026865, (305)  2
//     header = {0000000 000000010 01 01/1010/011 0/100 1} 00025a69, (323)  4
//     header = {0000000 000000010 01 10/0010/011 0/110 1} 0002626d, (324)  6
//     header = {0000000 000000010 01 10/1010/011 0/100 1} 00026a69, (325)  4
//     header = {0000000 000000010 01 01/1000/100 0/010 1} 00025885, (403)  2
//     header = {0000000 000000010 01 10/0000/100 0/011 1} 00026087, (404)  3
//     header = {0000000 000000010 01 10/1000/100 0/010 1} 00026885, (405)  2
//     header = {0000000 000000010 01 01/1010/100 0/100 1} 00025a89, (423)  4
//     header = {0000000 000000010 01 10/0010/100 0/110 1} 0002628d, (424)  6
//     header = {0000000 000000010 01 10/1010/100 0/100 1} 00026a89, (425)  4
//     header = {0000000 000000010 01 01/1010/101 0/010 1} 00025aa5, (523)  2
//     header = {0000000 000000010 01 10/0010/101 0/011 1} 000262a7, (524)  3
//     header = {0000000 000000010 01 10/1010/101 0/010 1} 00026aa5, (525)  2

//     from (1,1,0), node 6
//     header = {0000000 000000010 01 00/0011/011 0/011 1} 00024367, (330)  3
//     header = {0000000 000000010 01 01/0011/011 0/100 1} 00025369, (332)  4
//     header = {0000000 000000010 01 00/0100/011 0/100 1} 00024469, (340)  4
//     header = {0000000 000000010 01 01/0100/011 0/101 1} 0002546b, (342)  5
//     header = {0000000 000000010 01 00/0101/011 0/010 1} 00024565, (350)  2
//     header = {0000000 000000010 01 01/0101/011 0/011 1} 00025567, (352)  3
//     header = {0000000 000000010 01 00/0011/100 0/011 1} 00024387, (430)  3
//     header = {0000000 000000010 01 01/0011/100 0/100 1} 00025389, (432)  4
//     header = {0000000 000000010 01 00/0100/100 0/100 1} 00024489, (440)  4
//     header = {0000000 000000010 01 01/0100/100 0/101 1} 0002548b, (442)  5
//     header = {0000000 000000010 01 00/0101/100 0/010 1} 00024585, (450)  2
//     header = {0000000 000000010 01 01/0101/100 0/011 1} 00025587, (452)  3
//     header = {0000000 000000010 01 00/0011/101 0/001 1} 000243a3, (530)  1
//     header = {0000000 000000010 01 01/0011/101 0/010 1} 000253a5, (532)  2
//     header = {0000000 000000010 01 00/0100/101 0/001 1} 000244a3, (540)  1
//     header = {0000000 000000010 01 01/0100/101 0/010 1} 000254a5, (542)  2
//     header = {0000000 000000010 01 01/0101/101 0/001 1} 000255a3, (552)  1
	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4042,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5042,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4242,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5242,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4042,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5042,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4242,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5243,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h5844,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6046,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6844,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5a44,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
                                    {4{32'h00000000}},
	                               7'h00,particle_id,16'h6276,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6a44,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
                                    {4{32'h00000000}},
	                               7'h00,particle_id,16'h6276,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6a45,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4344,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5344,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4446,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5446,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
                                    {4{32'h00000000}},
	                               7'h00,particle_id,16'h4544,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5544,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
                                    {4{32'h00000000}},
	                               7'h00,particle_id,16'h4544,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5545,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h5b48,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h634c,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6b48,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5c4c,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h6552,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6c4c,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5d48,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h654c,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
                                    {4{32'h00000000}},
                                    {4{32'h00000000}},
	                               7'h00,particle_id,16'h6d48,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
                                    {4{32'h00000000}},
                                    {4{32'h00000000}},
	                               7'h00,particle_id,16'h6d49,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4062,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5062,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4264,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5264,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4082,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5082,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4284,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5284,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
       S_AXIS_n2k_pos_tdata  <= {{4{32'h00000000}},
                                 {4{32'h00000000}},
                                 {7'h00,particle_id,16'h42a2,pos_dummy_data,pos_dummy_data,pos_dummy_data},
	                              7'h00,particle_id,16'h52a2,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
       S_AXIS_n2k_pos_tdata  <= {{4{32'h00000000}},
                                 {4{32'h00000000}},
                                 {7'h00,particle_id,16'h42a2,pos_dummy_data,pos_dummy_data,pos_dummy_data},
	                              7'h00,particle_id,16'h52a3,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h5864,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6066,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6864,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5a68,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h626c,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6a68,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5884,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6086,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h6884,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5a88,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h628c,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6a88,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
	                               7'h00,particle_id,16'h5aa4,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h62a6,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6aa4,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
	                               7'h00,particle_id,16'h5aa4,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h62a6,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h6aa5,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4366,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5368,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4468,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h546a,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4564,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5566,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4386,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5388,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4488,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h548a,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4584,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5586,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h43a2,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h53a4,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h44a2,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h54a4,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
	                               {4{32'h00000000}},
	                               {4{32'h00000000}},
	                               7'h00,particle_id,16'h55a2,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
	                               {4{32'h00000000}},
	                               {4{32'h00000000}},
	                               7'h00,particle_id,16'h55a3,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
    
    // header = {0000000 000000010 01 00/0000/000 0/100 1} 00024009, (000)
    // header = {0000000 000000010 01 00/0000/001 0/100 1} 00024029, (100)
    // header = {0000000 000000010 01 00/0000/010 0/100 1} 00024049, (200)
    // header = {0000000 000000010 01 00/0001/000 0/100 1} 00024109, (010)
    // header = {0000000 000000010 01 00/0001/001 0/100 1} 00024129, (110)
    // header = {0000000 000000010 01 00/0001/010 0/100 1} 00024149, (210)
    // header = {0000000 000000010 01 00/0010/000 0/100 1} 00024209, (020)
    // header = {0000000 000000010 01 00/0010/001 0/100 1} 00024229, (120)
    // header = {0000000 000000010 01 00/0010/010 0/100 1} 00024249, (220)
    
//	repeat(15) begin
//	   #2
//	   particle_id <= particle_id + 1'b1;
//	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h524a,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4008,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4028,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4048,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
	
//	   #2
//	   particle_id <= 0;
//	   S_AXIS_n2k_pos_tvalid <= 1'b0;
//	   pos_dummy_data <= 32'h00000000;
	   
//	repeat(15) begin
//	   #2
//	   particle_id <= particle_id + 1'b1;
//	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4108,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4128,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4148,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4208,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
	
//	   #2
//	   particle_id <= 0;
//	   S_AXIS_n2k_pos_tvalid <= 1'b0;
//	   pos_dummy_data <= 32'h00000000;
	   
//	repeat(14) begin
//	   #2
//	   particle_id <= particle_id + 1'b1;
//	   S_AXIS_n2k_pos_tdata  <=    {{(4){32'h00000000}},
//	                               {(4){32'h00000000}},
//	                               7'h00,particle_id,16'h4228,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4248,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
//	#2
//	particle_id <= particle_id + 1'b1;
//    S_AXIS_n2k_pos_tdata  <= {{4{32'h00000000}},
//                            {4{32'h00000000}},
//	                        7'h00,particle_id,16'h4228,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//                            7'h00,particle_id,16'h4249,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	#2
//	S_AXIS_n2k_pos_tvalid <= 1'b0;
	
	
	#200
	MD_state_w <= 3;
	// header = {0000000 parid element gcid lifetime last}
    // header = {0000000 000000010 01 01/0000/000 0/101 1} 0002500b, (002)
    // header = {0000000 000000010 01 01/0000/001 0/101 1} 0002502b, (102)
    // header = {0000000 000000010 01 01/0000/010 0/101 1} 0002504b, (202)
    // header = {0000000 000000010 01 01/0001/000 0/101 1} 0002510b, (012)
    // header = {0000000 000000010 01 01/0001/001 0/101 1} 0002512b, (112)
    // header = {0000000 000000010 01 01/0001/010 0/101 1} 0002514b, (212)
    // header = {0000000 000000010 01 01/0010/000 0/101 1} 0002520b, (022)
    // header = {0000000 000000010 01 01/0010/001 0/101 1} 0002522b, (122)
    // header = {0000000 000000010 01 01/0010/010 0/101 1} 0002524b, (222)
    // wrong header = {0000000 000000010 01 111111111 1001 1} 00027ff3,
//	repeat(15) begin
//	   #2
//	   particle_id <= particle_id + 1'b1;
//	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h500a,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h502a,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h504a,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h510a,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
	
//	   #2
//	   particle_id <= 0;
//	   S_AXIS_n2k_pos_tvalid <= 1'b0;
//	   pos_dummy_data <= 32'h00000000;
	   
//	repeat(15) begin
//	   #2
//	   particle_id <= particle_id + 1'b1;
//	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h512a,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h514a,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h520a,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h522a,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
	
//	   #2
//	   particle_id <= 0;
//	   S_AXIS_n2k_pos_tvalid <= 1'b0;
//	   pos_dummy_data <= 32'h00000000;
	   
    
    // header = {0000000 000000010 01 00/0000/000 0/100 1} 00024009, (000)
    // header = {0000000 000000010 01 00/0000/001 0/100 1} 00024029, (100)
    // header = {0000000 000000010 01 00/0000/010 0/100 1} 00024049, (200)
    // header = {0000000 000000010 01 00/0001/000 0/100 1} 00024109, (010)
    // header = {0000000 000000010 01 00/0001/001 0/100 1} 00024129, (110)
    // header = {0000000 000000010 01 00/0001/010 0/100 1} 00024149, (210)
    // header = {0000000 000000010 01 00/0010/000 0/100 1} 00024209, (020)
    // header = {0000000 000000010 01 00/0010/001 0/100 1} 00024229, (120)
    // header = {0000000 000000010 01 00/0010/010 0/100 1} 00024249, (220)
    
//	repeat(15) begin
//	   #2
//	   particle_id <= particle_id + 1'b1;
//	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h524a,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4008,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4028,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4048,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
	
//	   #2
//	   particle_id <= 0;
//	   S_AXIS_n2k_pos_tvalid <= 1'b0;
//	   pos_dummy_data <= 32'h00000000;
	   
//	repeat(15) begin
//	   #2
//	   particle_id <= particle_id + 1'b1;
//	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4108,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4128,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4148,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4208,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
	
//	   #2
//	   particle_id <= 0;
//	   S_AXIS_n2k_pos_tvalid <= 1'b0;
//	   pos_dummy_data <= 32'h00000000;
	   
//	repeat(14) begin
//	   #2
//	   particle_id <= particle_id + 1'b1;
//	   S_AXIS_n2k_pos_tdata  <=    {{(4){32'h00000000}},
//	                               {(4){32'h00000000}},
//	                               7'h00,particle_id,16'h4228,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               7'h00,particle_id,16'h4248,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
//	#2
//	particle_id <= particle_id + 1'b1;
//    S_AXIS_n2k_pos_tdata  <= {{4{32'h00000000}},
//                            {4{32'h00000000}},
//	                        7'h00,particle_id,16'h4228,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//                            7'h00,particle_id,16'h4249,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	#2
//	S_AXIS_n2k_pos_tvalid <= 1'b0;
////	 header = {0000000000000    parid       gcid        last}
////     header = {0000/0000/0000/0 000/0000/10 01/1000/101 1} 0000098b, (503)
////     header = {0000/0000/0000/0 000/0000/10 10/0000/101 1} 00000a0b, (504)
////     header = {0000/0000/0000/0 000/0000/10 10/1000/101 1} 00000a8b, (505)
////     header = {0000/0000/0000/0 000/0000/10 01/1001/101 1} 0000099b, (513)
////     header = {0000/0000/0000/0 000/0000/10 10/0001/101 1} 00000a1b, (514)
////     header = {0000/0000/0000/0 000/0000/10 10/1001/101 1} 00000a9b, (515)
////     header = {0000/0000/0000/0 000/0000/10 01/1010/101 1} 000009ab, (523)
////     header = {0000/0000/0000/0 000/0000/10 10/0010/101 1} 00000a2b, (524)
////     header = {0000/0000/0000/0 000/0000/10 10/1010/101 1} 00000aab, (525)
//    S_AXIS_n2k_frc_tdata  <=   {32'h0000098a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a0a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a8a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h0000099a,frc_dummy_data,frc_dummy_data,frc_dummy_data};
//    S_AXIS_n2k_frc_tvalid <= 1'b1;
    
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {32'h00000a1a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a9a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h000009aa,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a2a,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
//                               {(4){32'h00000000}},
//                               {(4){32'h00000000}},
//                               32'h00000aab,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
//	#2
//	S_AXIS_n2k_frc_tvalid <= 1'b0;
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {32'h0000098a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a0a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a8a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h0000099a,frc_dummy_data,frc_dummy_data,frc_dummy_data};
//    S_AXIS_n2k_frc_tvalid <= 1'b1;
    
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {32'h00000a1a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a9a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h000009aa,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a2a,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
//                               {(4){32'h00000000}},
//                               {(4){32'h00000000}},
//                               32'h00000aab,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
//	#2
//	S_AXIS_n2k_frc_tvalid <= 1'b0;
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {32'h0000098a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a0a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a8a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h0000099a,frc_dummy_data,frc_dummy_data,frc_dummy_data};
//    S_AXIS_n2k_frc_tvalid <= 1'b1;
    
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {32'h00000a1a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a9a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h000009aa,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h00000a2a,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
//                               {(4){32'h00000000}},
//                               {(4){32'h00000000}},
//                               32'h00000aab,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
//	#2
//	S_AXIS_n2k_frc_tvalid <= 1'b0;
	
//	#12
//	network_pos_free <= 0;
	
//	#10
//	network_pos_free <= 1;
	
//	#12
//	network_pos_free <= 0;
	
//	#6
//	network_pos_free <= 1;
	end
	
MD_wrapper inst_MD_wrapper (
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n),
    
    .S_AXIS_n2k_pos_tdata(S_AXIS_n2k_pos_tdata),
    .S_AXIS_n2k_pos_tkeep(S_AXIS_n2k_pos_tkeep),
    .S_AXIS_n2k_pos_tvalid(S_AXIS_n2k_pos_tvalid),
    .S_AXIS_n2k_pos_tlast(S_AXIS_n2k_pos_tlast),
    .S_AXIS_n2k_pos_tdest(S_AXIS_n2k_pos_tdest),
    .S_AXIS_n2k_pos_tready(S_AXIS_n2k_pos_tready),
    
    .k2n_pos_tdata(k2n_pos_tdata),
    .k2n_pos_tkeep(k2n_pos_tkeep),
    .k2n_pos_tvalid(k2n_pos_tvalid),
    .k2n_pos_tlast(k2n_pos_tlast),
    .k2n_pos_tdest(k2n_pos_tdest),
    .k2n_pos_tready(k2n_pos_tready),
    
    .S_AXIS_n2k_frc_tdata(S_AXIS_n2k_frc_tdata),
    .S_AXIS_n2k_frc_tkeep(S_AXIS_n2k_frc_tkeep),
    .S_AXIS_n2k_frc_tvalid(S_AXIS_n2k_frc_tvalid),
    .S_AXIS_n2k_frc_tlast(S_AXIS_n2k_frc_tlast),
    .S_AXIS_n2k_frc_tdest(S_AXIS_n2k_frc_tdest),
    .S_AXIS_n2k_frc_tready(S_AXIS_n2k_frc_tready),
    
    .k2n_frc_tdata(k2n_frc_tdata),
    .k2n_frc_tkeep(k2n_frc_tkeep),
    .k2n_frc_tvalid(k2n_frc_tvalid),
    .k2n_frc_tlast(k2n_frc_tlast),
    .k2n_frc_tdest(k2n_frc_tdest),
    .k2n_frc_tready(k2n_frc_tready),
    
    .S_AXIS_h2k_tdata(S_AXIS_h2k_tdata),
    .S_AXIS_h2k_tkeep(S_AXIS_h2k_tkeep),
    .S_AXIS_h2k_tvalid(S_AXIS_h2k_tvalid),
    .S_AXIS_h2k_tlast(S_AXIS_h2k_tlast),
    .S_AXIS_h2k_tdest(S_AXIS_h2k_tdest),
    .S_AXIS_h2k_tready(S_AXIS_h2k_tready),
    
    .M_AXIS_k2h_tdata(M_AXIS_k2h_tdata),
    .M_AXIS_k2h_tkeep(M_AXIS_k2h_tkeep),
    .M_AXIS_k2h_tvalid(M_AXIS_k2h_tvalid),
    .M_AXIS_k2h_tlast(M_AXIS_k2h_tlast),
    .M_AXIS_k2h_tdest(M_AXIS_k2h_tdest),
    .M_AXIS_k2h_tready(M_AXIS_k2h_tready),
    
    .MD_state_w(MD_state_w),
    .dest_id_w(dest_id_w),
    .init_id_w(init_id_w),
    .init_npc_w(init_npc_w),
    .dump_bank_sel_w(dump_bank_sel_w),
    .dump_filter_sel_w(dump_filter_sel_w),
    .xcv_cooldown_cycles_w(xcv_cooldown_cycles_w),
    .iter_target_w(iter_target_w),
    .network_pos_free(network_pos_free),
    .network_frc_free(network_frc_free),
    .fifo_pos_full(fifo_pos_full),
    .fifo_frc_full(fifo_frc_full),
    .d_all_pos_ring_nodes_empty(all_pos_ring_nodes_empty),
    .all_disp_once_back_pressure(all_disp_back_pressure),
    .d_all_dirty(all_dirty),
    .all_filter_once_back_pressure(all_filter_once_back_pressure),
    .all_frc_output_ring_buf_once_full(all_frc_output_ring_buf_once_full),
    .home_buf_once_almost_full(home_buf_almost_full),
    .nb_buf_once_almost_full(nb_buf_almost_full),
    .d_all_frc_output_ring_buf_empty(all_frc_output_ring_buf_empty),
    .d_all_frc_output_ring_done(all_frc_output_ring_done),
    .d_all_home_buf_empty(all_home_buf_empty),
    .d_all_nb_buf_empty(all_nb_buf_empty),
    .d_all_disp_buf_empty(all_disp_buf_empty),
    .MU_buf_almost_full(MU_buf_almost_full),
    .all_MU_buf_empty(all_MU_buf_empty),
    .MU_spinning(MU_spinning),
    .MU_reading(MU_reading),
    .MU_writing(MU_writing),
    .MU_busy(MU_busy),
    .MU_busy_cnt(MU_busy_cnt),
    .pos_state(pos_state),
    .MU_started(MU_started),
    .MU_frc_once_valid(MU_frc_once_valid),
    .MU_offset_once_valid(MU_offset_once_valid),
    .MU_vel_once_valid(MU_vel_once_valid),
    .MU_once_writing(MU_once_writing),
    .MU_once_reading(MU_once_reading),
    .chk_nb_frc(chk_nb_frc),
    .chk_home_frc(chk_home_frc),
    .chk_MU_vel_out(chk_MU_vel_out),
    .chk_MU_vel_produced(chk_MU_vel_produced),
    .chk_MU_offset_in(chk_MU_offset_in),
    .MU_num_particles(MU_num_particles),
    .MU_rd_cnt(MU_rd_cnt),
    .iter_cnt(iter_cnt),
    .operation_cycle_cnt(operation_cycle_cnt),
    .MU_debug_migration_flag(MU_debug_migration_flag), 
    .num_particles_0(num_particles_0), 
    .num_particles_1(num_particles_1), 
    .num_particles_2(num_particles_2), 
    .num_particles_3(num_particles_3), 
    .num_particles_4(num_particles_4), 
    .num_particles_5(num_particles_5), 
    .num_particles_6(num_particles_6), 
    .num_particles_7(num_particles_7),
    .init_step(init_step),
    .init_wr_addr(init_wr_addr),
    .remote_pos_buf_once_full(remote_pos_buf_once_full),
    .remote_frc_buf_once_full(remote_frc_buf_once_full),
    .last_pos_sent_cntr(last_pos_sent),
    .last_frc_sent_cntr(last_frc_sent),
    .pos_pkt_to_remote_valid_cntr(pos_pkt_to_remote_valid_cntr),
    .frc_pkt_to_remote_valid_cntr(frc_pkt_to_remote_valid_cntr),
    .remote_pos_tvalid_cntr(remote_pos_tvalid_cntr),
    .remote_frc_tvalid_cntr(remote_frc_tvalid_cntr),
    .last_pos_cntr(last_pos_cntr),
    .last_frc_cntr(last_frc_cntr),
    .d_pos_burst_running(pos_burst_running),
    .d_frc_burst_running(frc_burst_running),
    .pos_ring_cycle_cnt(pos_ring_cycle_cnt),
    .frc_ring_cycle_cnt(frc_ring_cycle_cnt),
    .filter_cycle_cnt(filter_cycle_cnt),
    .PE_cycle_cnt(PE_cycle_cnt),
    .MU_cycle_cnt(MU_cycle_cnt),
    .MU_start_cntr(MU_start_cnt),
    .dest_cntr_0(dest_cntr_0),
    .dest_cntr_1(dest_cntr_1),
    .dest_cntr_4(dest_cntr_4),
    .dest_cntr_5(dest_cntr_5),
    .dest_x_cntr(dest_x_cntr),
    .dest_z_cntr(dest_z_cntr),
    .dest_xz_cntr(dest_xz_cntr),
    .d_remote_pos_buf_empty(d_remote_pos_buf_empty),
    .d_remote_frc_buf_empty(d_remote_frc_buf_empty),
    .d_fifo_pos_empty(d_fifo_pos_empty),
    .d_fifo_frc_empty(d_fifo_frc_empty),
    .d_ring_pos_to_remote_bufs_empty(d_ring_pos_to_remote_bufs_empty),
    .remote_frc_buf_ack_cntr(remote_frc_buf_ack_cntr)
);

endmodule