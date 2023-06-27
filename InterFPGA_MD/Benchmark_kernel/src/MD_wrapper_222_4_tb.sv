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

module MD_wrapper_222_4_tb;

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
logic         [INIT_STEP_WIDTH-1:0]   dump_bank_sel_w;
logic                        [31:0]   iter_target_w;
logic                                 network_pos_free;
logic                                 network_frc_free;

logic                                 fifo_pos_full;
logic                                 fifo_frc_full;
//logic       [PARTICLE_ID_WIDTH-1:0]   num_particles;
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
logic                                 last_pos_sent;
logic                                 last_frc_sent;
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
	dump_bank_sel_w <= 0;
	
	pos_dummy_data <= 32'h00080000;
	frc_dummy_data <= 32'h3f800000;

/////////////////////////////////////////////////////
// Test
/////////////////////////////////////////////////////
    #10
    init_id_w <= 4;
    
	#100
	ap_rst_n <= 1;
	
	#10
	MD_state_w <= 1;
	network_pos_free <= 1;
	network_frc_free <= 1;
	iter_target_w <= 3;
	
	repeat (2) begin
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
	
//	#40
//	// header = {0000000 parid element gcid lifetime last}
//    // header = {0000000 000000010 01 00/0000/010 1001 1} 00024053, (200)
//    // header = {0000000 000000010 01 00/1000/010 1001 1} 00024853, (201)
//    // header = {0000000 000000010 01 01/0000/010 1001 1} 00025053, (202)
//    // header = {0000000 000000010 01 00/0001/010 1001 1} 00024153, (210)
//    // header = {0000000 000000010 01 00/1001/010 1001 1} 00024953, (211)
//    // header = {0000000 000000010 01 01/0001/010 1001 1} 00025153, (212)
//    // header = {0000000 000000010 01 00/0010/010 1001 1} 00024253, (220)
//    // header = {0000000 000000010 01 00/1010/010 1001 1} 00024a53, (221)
//    // header = {0000000 000000010 01 01/0010/010 1001 1} 00025253, (222)
//    // wrong header = {0000000 000000010 01 111111111 1001 1} 00027ff3,
//	repeat(15) begin
//	   #2
//	   S_AXIS_n2k_pos_tdata  <=    {32'h00024052,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               32'h00024852,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               32'h00025052,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               32'h00024152,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
	
//	   #2
//	   S_AXIS_n2k_pos_tvalid <= 1'b0;
//	   pos_dummy_data <= 32'h00000000;
	   
//	repeat(15) begin
//	   #2
//	   S_AXIS_n2k_pos_tdata  <=    {32'h00024952,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               32'h00025152,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               32'h00024252,pos_dummy_data,pos_dummy_data,pos_dummy_data,
//	                               32'h00024a52,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
	
//	   #2
//	   S_AXIS_n2k_pos_tvalid <= 1'b0;
//	   pos_dummy_data <= 32'h00000000;
	   
//	repeat(14) begin
//	   #2
//	   S_AXIS_n2k_pos_tdata  <=    {{(4){32'h00000000}},
//	                               {(4){32'h00000000}},
//	                               {(4){32'h00000000}},
//	                               32'h00025252,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	   pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	   S_AXIS_n2k_pos_tvalid <= 1'b1;
//	end
//	#2
//    S_AXIS_n2k_pos_tdata  <= {{4{32'h00000000}},
//                            {4{32'h00000000}},
//                            {4{32'h00000000}},
//                            32'h00025253,pos_dummy_data,pos_dummy_data,pos_dummy_data};
//	pos_dummy_data <= pos_dummy_data + 32'h00080000;
//	#2
//	S_AXIS_n2k_pos_tvalid <= 1'b0;
	
	#200
	MD_state_w <= 3;
	
//	#100
//	// header = {0000000000000    parid       gcid        last}
//    // header = {0000/0000/0000/0 000/0000/10 00/0000/101 1} 0000080b, (500)
//    // header = {0000/0000/0000/0 000/0000/10 00/1000/101 1} 0000088b, (501)
//    // header = {0000/0000/0000/0 000/0000/10 01/0000/101 1} 0000090b, (502)
//    // header = {0000/0000/0000/0 000/0000/10 00/0001/101 1} 0000081b, (510)
//    // header = {0000/0000/0000/0 000/0000/10 00/1001/101 1} 0000089b, (511)
//    // header = {0000/0000/0000/0 000/0000/10 01/0001/101 1} 0000091b, (512)
//    // header = {0000/0000/0000/0 000/0000/10 00/0010/101 1} 0000082b, (520)
//    // header = {0000/0000/0000/0 000/0000/10 00/1010/101 1} 000008ab, (521)
//    // header = {0000/0000/0000/0 000/0000/10 01/0010/101 1} 0000092b, (522)
//    S_AXIS_n2k_frc_tdata  <=   {32'h0000080a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h0000088a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h0000090a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h0000081a,frc_dummy_data,frc_dummy_data,frc_dummy_data};
//    S_AXIS_n2k_frc_tvalid <= 1'b1;
    
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {32'h0000089a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h0000091a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h0000082a,frc_dummy_data,frc_dummy_data,frc_dummy_data,
//                                32'h000008aa,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
//	#2
//    S_AXIS_n2k_frc_tdata  <=   {{(4){32'h00000000}},
//                               {(4){32'h00000000}},
//                               {(4){32'h00000000}},
//                               32'h0000092b,frc_dummy_data,frc_dummy_data,frc_dummy_data};
                                
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
    .dump_bank_sel_w(dump_bank_sel_w),
    .iter_target_w(iter_target_w),
    .network_pos_free(network_pos_free),
    .network_frc_free(network_frc_free),
    
    .fifo_pos_full(fifo_pos_full),
    .fifo_frc_full(fifo_frc_full),
//    .num_particles(num_particles),
    .all_disp_back_pressure(all_disp_back_pressure),
    .all_dirty(all_dirty),
    .home_buf_almost_full(home_buf_almost_full),
    .nb_buf_almost_full(nb_buf_almost_full),
    .all_frc_output_ring_buf_empty(all_frc_output_ring_buf_empty),
    .all_frc_output_ring_done(all_frc_output_ring_done),
    .all_home_buf_empty(all_home_buf_empty),
    .all_nb_buf_empty(all_nb_buf_empty),
    .all_disp_buf_empty(all_disp_buf_empty),
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
    .last_pos_sent(last_pos_sent),
    .last_frc_sent(last_frc_sent),
    .pos_pkt_to_remote_valid_cntr(pos_pkt_to_remote_valid_cntr),
    .frc_pkt_to_remote_valid_cntr(frc_pkt_to_remote_valid_cntr),
    .remote_pos_tvalid_cntr(remote_pos_tvalid_cntr),
    .remote_frc_tvalid_cntr(remote_frc_tvalid_cntr),
    .last_pos_cntr(last_pos_cntr),
    .last_frc_cntr(last_frc_cntr),
    .pos_burst_running(pos_burst_running),
    .frc_burst_running(frc_burst_running)
);

endmodule