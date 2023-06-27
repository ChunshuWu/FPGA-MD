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

module MD_wrapper_8c_8b_tb;

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
logic [31:0]                          pos_dest_cntr_0;
logic [31:0]                          pos_dest_cntr_1;
logic [31:0]                          pos_dest_cntr_2;
logic [31:0]                          pos_dest_cntr_3;
logic [31:0]                          pos_dest_cntr_4;
logic [31:0]                          pos_dest_cntr_5;
logic [31:0]                          pos_dest_cntr_6;
logic [31:0]                          pos_dest_cntr_7;
logic [31:0]                          frc_dest_cntr_0;
logic [31:0]                          frc_dest_cntr_1;
logic [31:0]                          frc_dest_cntr_2;
logic [31:0]                          frc_dest_cntr_3;
logic [31:0]                          frc_dest_cntr_4;
logic [31:0]                          frc_dest_cntr_5;
logic [31:0]                          frc_dest_cntr_6;
logic [31:0]                          frc_dest_cntr_7;
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
logic [31:0]                          remote_pos_buf_ack_cntr;
logic                                 last_pos_over_received;
logic [31:0]                          single_iter_cycle_cnt;

logic                                 d_all_PE_nb_buf_empty;
logic                                 all_PE_nb_buf_once_full;
logic                                 d_all_filter_buf_empty;

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
	init_npc_w <= 64;
	xcv_cooldown_cycles_w <= 2;
    
	#100
	ap_rst_n <= 1;
	
	#10
	MD_state_w <= 1;
	network_pos_free <= 1;
	network_frc_free <= 1;
	iter_target_w <= 1;
	
	
	repeat (2) begin
        #2
        S_AXIS_h2k_tdata  <= {(16){32'h00000040}};
        S_AXIS_h2k_tkeep <= 0;
        S_AXIS_h2k_tvalid <= 1;
        S_AXIS_h2k_tlast <= 1;
        S_AXIS_h2k_tdest <= 7;
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00100000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00100000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00100000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00100000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00300000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00300000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00300000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00300000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00500000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00500000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00500000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00500000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00700000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00700000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00700000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00700000,32'h00700000}};
        
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00100000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00100000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00100000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00100000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00300000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00300000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00300000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00300000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00500000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00500000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00500000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00500000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00700000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00700000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00700000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00700000,32'h00700000}};
        
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00100000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00100000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00100000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00100000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00300000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00300000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00300000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00300000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00500000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00500000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00500000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00500000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00700000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00700000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00700000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00700000,32'h00700000}};
        
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00100000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00100000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00100000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00100000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00300000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00300000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00300000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00300000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00500000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00500000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00500000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00500000,32'h00700000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00700000,32'h00100000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00700000,32'h00300000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00700000,32'h00500000}};
        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00700000,32'h00700000}};
	end
//	repeat (2) begin
//        #2
//        S_AXIS_h2k_tdata  <= {(16){32'h0000000F}};
//        S_AXIS_h2k_tkeep <= 0;
//        S_AXIS_h2k_tvalid <= 1;
//        S_AXIS_h2k_tlast <= 1;
//        S_AXIS_h2k_tdest <= 7;
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00080000,32'h00080000,32'h00080000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00100000,32'h00100000,32'h00100000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00180000,32'h00180000,32'h00180000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00200000,32'h00200000,32'h00200000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00280000,32'h00280000,32'h00280000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00300000,32'h00300000,32'h00300000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00380000,32'h00380000,32'h00380000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00400000,32'h00400000,32'h00400000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00480000,32'h00480000,32'h00480000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00500000,32'h00500000,32'h00500000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00580000,32'h00580000,32'h00580000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00600000,32'h00600000,32'h00600000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00680000,32'h00680000,32'h00680000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00700000,32'h00700000,32'h00700000}};
//        #2 S_AXIS_h2k_tdata  <= {(4){32'h00000001,32'h00780000,32'h00780000,32'h00780000}};
//	end
	#2
	S_AXIS_h2k_tvalid <= 0;
	
	#10
	MD_state_w <= 2;
	
	#40
//	 header = {0000000 parid element gcid lifetime last} gcid {z, y, x}
//     from (0,0,0), node 0
//     header = {0000000 000000010 01 00/0000/001 0/001 1} 00024023, (100)  1
//     header = {0000000 000000010 01 00/1000/001 0/001 1} 00024823, (101)  1
//     header = {0000000 000000010 01 00/0001/001 0/001 1} 00024123, (110)  1
//     header = {0000000 000000010 01 00/1001/001 0/001 1} 00024923, (111)  1

//     from (0,0,1), node 1
//     header = {0000000 000000010 01 01/0000/001 0/010 1} 00025025, (102)  2
//     header = {0000000 000000010 01 01/1000/001 0/010 1} 00025825, (103)  2
//     header = {0000000 000000010 01 01/0001/001 0/010 1} 00025125, (112)  2
//     header = {0000000 000000010 01 01/1001/001 0/010 1} 00025925, (113)  2

//     from (0,1,0), node 2
//     header = {0000000 000000010 01 00/0010/001 0/010 1} 00024225, (120)  2
//     header = {0000000 000000010 01 00/1010/001 0/010 1} 00024a25, (121)  2
//     header = {0000000 000000010 01 00/0011/001 0/010 1} 00024325, (130)  2
//     header = {0000000 000000010 01 00/1011/001 0/010 1} 00024b25, (131)  2

//     from (0,1,1), node 3
//     header = {0000000 000000010 01 01/0010/001 0/100 1} 00025229, (122)  4
//     header = {0000000 000000010 01 01/1010/001 0/100 1} 00025a29, (123)  4
//     header = {0000000 000000010 01 01/0011/001 0/100 1} 00025329, (132)  4
//     header = {0000000 000000010 01 01/1011/001 0/100 1} 00025b29, (133)  4

//     from (1,0,0), node 4
//     header = {0000000 000000010 01 00/0000/010 0/001 1} 00024043, (200)  1
//     header = {0000000 000000010 01 00/1000/010 0/001 1} 00024843, (201)  1
//     header = {0000000 000000010 01 00/0001/010 0/010 1} 00024145, (210)  2
//     header = {0000000 000000010 01 00/1001/010 0/010 1} 00024945, (211)  2
//     header = {0000000 000000010 01 00/0001/011 0/001 1} 00024163, (310)  1
//     header = {0000000 000000010 01 00/1001/011 0/001 1} 00024963, (311)  1

//     from (1,0,1), node 5
//     header = {0000000 000000010 01 01/0000/010 0/010 1} 00025045, (202)  2
//     header = {0000000 000000010 01 01/1000/010 0/010 1} 00025845, (203)  2
//     header = {0000000 000000010 01 01/0001/010 0/100 1} 00025149, (212)  4
//     header = {0000000 000000010 01 01/1001/010 0/100 1} 00025949, (213)  4
//     header = {0000000 000000010 01 01/0001/011 0/010 1} 00025165, (312)  2
//     header = {0000000 000000010 01 01/1001/011 0/010 1} 00025965, (313)  2

//     from (1,1,0), node 6
//     header = {0000000 000000010 01 00/0010/010 0/011 1} 00024247, (220)  3
//     header = {0000000 000000010 01 00/1010/010 0/100 1} 00024a49, (221)  4
//     header = {0000000 000000010 01 00/0011/010 0/010 1} 00024345, (230)  2
//     header = {0000000 000000010 01 00/1011/010 0/011 1} 00024b47, (231)  3
//     header = {0000000 000000010 01 00/0010/011 0/001 1} 00024263, (320)  1
//     header = {0000000 000000010 01 00/1010/011 0/010 1} 00024a65, (321)  2
//     header = {0000000 000000010 01 00/1011/011 0/001 1} 00024b63, (331)  1

	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4022,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4822,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4122,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4922,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4022,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4822,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4122,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4923,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;

	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h5024,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5824,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5124,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5924,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h5024,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5824,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5124,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5925,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;

	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4224,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4a24,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4324,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4b24,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4224,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4a24,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4324,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4b25,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;

	repeat(14) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h5228,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5a28,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5328,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5b28,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h5228,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5a28,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5328,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5b29,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4042,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4842,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4144,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4944,pos_dummy_data,pos_dummy_data,pos_dummy_data};
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
	                               7'h00,particle_id,16'h4162,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4962,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
                                    {4{32'h00000000}},
	                               7'h00,particle_id,16'h4162,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4963,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h5044,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5844,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5148,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5948,pos_dummy_data,pos_dummy_data,pos_dummy_data};
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
	                               7'h00,particle_id,16'h5164,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5964,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
                                    {4{32'h00000000}},
	                               7'h00,particle_id,16'h5164,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h5965,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	
	   #2
	   particle_id <= 0;
	   S_AXIS_n2k_pos_tvalid <= 1'b0;
	   pos_dummy_data <= 32'h00000000;
	   
	repeat(15) begin
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {7'h00,particle_id,16'h4246,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4a48,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4344,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4b46,pos_dummy_data,pos_dummy_data,pos_dummy_data};
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
	                               7'h00,particle_id,16'h4262,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4a64,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4b62,pos_dummy_data,pos_dummy_data,pos_dummy_data};
	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
	   S_AXIS_n2k_pos_tvalid <= 1'b1;
	end
	
	   #2
	   particle_id <= particle_id + 1'b1;
	   S_AXIS_n2k_pos_tdata  <=    {{4{32'h00000000}},
	                               7'h00,particle_id,16'h4262,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4a64,pos_dummy_data,pos_dummy_data,pos_dummy_data,
	                               7'h00,particle_id,16'h4b63,pos_dummy_data,pos_dummy_data,pos_dummy_data};
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
	#2
	S_AXIS_n2k_pos_tvalid <= 1'b0;
//	 header = {0000000000000    parid       gcid        last}
//     header = {0000/0000/0000/0 000/0000/10 01/0010/010 1} 00000925, (222)
//     header = {0000/0000/0000/0 000/0000/10 01/1010/010 1} 000009a5, (223)
//     header = {0000/0000/0000/0 000/0000/10 01/0011/010 1} 00000935, (232)
//     header = {0000/0000/0000/0 000/0000/10 01/1011/010 1} 000009b5, (233)
//     header = {0000/0000/0000/0 000/0000/10 01/0010/011 1} 00000927, (322)
//     header = {0000/0000/0000/0 000/0000/10 01/1010/011 1} 000009a7, (323)
//     header = {0000/0000/0000/0 000/0000/10 01/0011/011 1} 00000937, (332)
//     header = {0000/0000/0000/0 000/0000/10 01/1011/011 1} 000009b7, (333)
    S_AXIS_n2k_frc_tdata  <=   {32'h00000924,frc_dummy_data,frc_dummy_data,frc_dummy_data,
                                32'h000009a4,frc_dummy_data,frc_dummy_data,frc_dummy_data,
                                32'h00000934,frc_dummy_data,frc_dummy_data,frc_dummy_data,
                                32'h000009b4,frc_dummy_data,frc_dummy_data,frc_dummy_data};
    S_AXIS_n2k_frc_tvalid <= 1'b1;
    
	#2
    S_AXIS_n2k_frc_tdata  <=   {32'h00000926,frc_dummy_data,frc_dummy_data,frc_dummy_data,
                                32'h000009a6,frc_dummy_data,frc_dummy_data,frc_dummy_data,
                                32'h00000936,frc_dummy_data,frc_dummy_data,frc_dummy_data,
                                32'h000009b6,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
	#2
    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
                               {(4){32'h00000000}},
                               {(4){32'h00000000}},
                               32'h000009b7,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
	#2
    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
                               {(4){32'h00000000}},
                               {(4){32'h00000000}},
                               32'h000009b7,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
	#2
    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
                               {(4){32'h00000000}},
                               {(4){32'h00000000}},
                               32'h000009b7,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
	#2
    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
                               {(4){32'h00000000}},
                               {(4){32'h00000000}},
                               32'h000009b7,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
	#2
    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
                               {(4){32'h00000000}},
                               {(4){32'h00000000}},
                               32'h000009b7,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
	#2
    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
                               {(4){32'h00000000}},
                               {(4){32'h00000000}},
                               32'h000009b7,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
	#2
    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
                               {(4){32'h00000000}},
                               {(4){32'h00000000}},
                               32'h000009b7,frc_dummy_data,frc_dummy_data,frc_dummy_data};
	#2
	S_AXIS_n2k_frc_tvalid <= 1'b0;
	
                                
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
    .pos_dest_cntr_0(pos_dest_cntr_0),
    .pos_dest_cntr_1(pos_dest_cntr_1),
    .pos_dest_cntr_2(pos_dest_cntr_2),
    .pos_dest_cntr_3(pos_dest_cntr_3),
    .pos_dest_cntr_4(pos_dest_cntr_4),
    .pos_dest_cntr_5(pos_dest_cntr_5),
    .pos_dest_cntr_6(pos_dest_cntr_6),
    .pos_dest_cntr_7(pos_dest_cntr_7),
    .frc_dest_cntr_0(frc_dest_cntr_0),
    .frc_dest_cntr_1(frc_dest_cntr_1),
    .frc_dest_cntr_2(frc_dest_cntr_2),
    .frc_dest_cntr_3(frc_dest_cntr_3),
    .frc_dest_cntr_4(frc_dest_cntr_4),
    .frc_dest_cntr_5(frc_dest_cntr_5),
    .frc_dest_cntr_6(frc_dest_cntr_6),
    .frc_dest_cntr_7(frc_dest_cntr_7),
    .dest_x_cntr(dest_x_cntr),
    .dest_z_cntr(dest_z_cntr),
    .dest_xz_cntr(dest_xz_cntr),
    .d_remote_pos_buf_empty(d_remote_pos_buf_empty),
    .d_remote_frc_buf_empty(d_remote_frc_buf_empty),
    .d_fifo_pos_empty(d_fifo_pos_empty),
    .d_fifo_frc_empty(d_fifo_frc_empty),
    .d_ring_pos_to_remote_bufs_empty(d_ring_pos_to_remote_bufs_empty),
    .remote_pos_buf_ack_cntr(remote_pos_buf_ack_cntr),
    .remote_frc_buf_ack_cntr(remote_frc_buf_ack_cntr),
    .last_pos_over_received(last_pos_over_received),
    .single_iter_cycle_cnt(single_iter_cycle_cnt),
    .d_all_PE_nb_buf_empty(d_all_PE_nb_buf_empty),
    .all_PE_nb_buf_once_full(all_PE_nb_buf_once_full),
    .d_all_filter_buf_empty(d_all_filter_buf_empty)
);

endmodule