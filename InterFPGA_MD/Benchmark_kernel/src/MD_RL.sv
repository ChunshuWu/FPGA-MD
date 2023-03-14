/************************************************
Copyright (c) 2020, Xilinx, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software 
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.// Copyright (c) 2020 Xilinx, Inc.
************************************************/

`default_nettype wire
`timescale 1 ns / 1 ps
// Top level of the kernel. Do not modify module name, parameters or ports.

import MD_pkg::*;

module MD_RL #(
      // Width of S_AXIS_n2k and M_AXIS_k2n interfaces
      parameter integer AXIS_TDATA_WIDTH      = 512,
      // Width of M_AXIS_summary interface
      parameter integer AXIS_SUMMARY_WIDTH    = 128,
      // Width of TDEST address bus
      parameter integer STREAMING_TDEST_WIDTH =  16,
      // Width of S_AXIL data bus
      parameter integer AXIL_DATA_WIDTH       = 32,
      // Width of S_AXIL address bus
      parameter integer AXIL_ADDR_WIDTH       =  9
)(
    // System clocks and resets
    input  wire                                 ap_clk,
    input  wire                                 ap_rst_n,

    // AXI4-Stream network layer to streaming kernel 
    input  wire       [AXIS_TDATA_WIDTH-1:0]    S_AXIS_n2k_pos_tdata,
    input  wire     [AXIS_TDATA_WIDTH/8-1:0]    S_AXIS_n2k_pos_tkeep,
    input  wire                                 S_AXIS_n2k_pos_tvalid,
    input  wire                                 S_AXIS_n2k_pos_tlast,
    input  wire  [STREAMING_TDEST_WIDTH-1:0]    S_AXIS_n2k_pos_tdest,
    output wire                                 S_AXIS_n2k_pos_tready,
    // AXI4-Stream streaming kernel to network layer
    output wire       [AXIS_TDATA_WIDTH-1:0]    M_AXIS_k2n_pos_tdata,
    output wire     [AXIS_TDATA_WIDTH/8-1:0]    M_AXIS_k2n_pos_tkeep,
    output wire                                 M_AXIS_k2n_pos_tvalid,
    output wire                                 M_AXIS_k2n_pos_tlast,
    output wire  [STREAMING_TDEST_WIDTH-1:0]    M_AXIS_k2n_pos_tdest,
    input  wire                                 M_AXIS_k2n_pos_tready,

    // AXI4-Stream network layer to streaming kernel 
    input  wire       [AXIS_TDATA_WIDTH-1:0]    S_AXIS_n2k_frc_tdata,
    input  wire     [AXIS_TDATA_WIDTH/8-1:0]    S_AXIS_n2k_frc_tkeep,
    input  wire                                 S_AXIS_n2k_frc_tvalid,
    input  wire                                 S_AXIS_n2k_frc_tlast,
    input  wire  [STREAMING_TDEST_WIDTH-1:0]    S_AXIS_n2k_frc_tdest,
    output wire                                 S_AXIS_n2k_frc_tready,
    // AXI4-Stream streaming kernel to network layer
    output wire       [AXIS_TDATA_WIDTH-1:0]    M_AXIS_k2n_frc_tdata,
    output wire     [AXIS_TDATA_WIDTH/8-1:0]    M_AXIS_k2n_frc_tkeep,
    output wire                                 M_AXIS_k2n_frc_tvalid,
    output wire                                 M_AXIS_k2n_frc_tlast,
    output wire  [STREAMING_TDEST_WIDTH-1:0]    M_AXIS_k2n_frc_tdest,
    input  wire                                 M_AXIS_k2n_frc_tready,

    // AXI4-Stream host to streaming kernel 
    input  wire       [AXIS_TDATA_WIDTH-1:0]    S_AXIS_h2k_tdata,
    input  wire     [AXIS_TDATA_WIDTH/8-1:0]    S_AXIS_h2k_tkeep,
    input  wire                                 S_AXIS_h2k_tvalid,
    input  wire                                 S_AXIS_h2k_tlast,
    input  wire  [STREAMING_TDEST_WIDTH-1:0]    S_AXIS_h2k_tdest,
    output wire                                 S_AXIS_h2k_tready,
    // AXI4-Stream streaming kernel to host
    output logic      [AXIS_TDATA_WIDTH-1:0]    M_AXIS_k2h_tdata,
    output wire     [AXIS_TDATA_WIDTH/8-1:0]    M_AXIS_k2h_tkeep,
    output wire                                 M_AXIS_k2h_tvalid,
    output wire                                 M_AXIS_k2h_tlast,
    output wire  [STREAMING_TDEST_WIDTH-1:0]    M_AXIS_k2h_tdest,
    input  wire                                 M_AXIS_k2h_tready,
    
    input  wire      [AXIL_ADDR_WIDTH-1 : 0]    S_AXIL_AWADDR,
    input  wire                                 S_AXIL_AWVALID,
    output wire                                 S_AXIL_AWREADY,
    input  wire      [AXIL_DATA_WIDTH-1 : 0]    S_AXIL_WDATA,
    input  wire  [(AXIL_DATA_WIDTH/8)-1 : 0]    S_AXIL_WSTRB,
    input  wire                                 S_AXIL_WVALID,
    output wire                                 S_AXIL_WREADY,
    output wire                      [1 : 0]    S_AXIL_BRESP,
    output wire                                 S_AXIL_BVALID,
    input  wire                                 S_AXIL_BREADY,
    input  wire      [AXIL_ADDR_WIDTH-1 : 0]    S_AXIL_ARADDR,
    input  wire                                 S_AXIL_ARVALID,
    output wire                                 S_AXIL_ARREADY,
    output wire      [AXIL_DATA_WIDTH-1 : 0]    S_AXIL_RDATA,
    output wire                      [1 : 0]    S_AXIL_RRESP,
    output wire                                 S_AXIL_RVALID,
    input  wire                                 S_AXIL_RREADY
);

    wire                                 ap_idle_pos_w;
    wire                                 ap_done_pos_w;
    wire                                 ap_idle_frc_w;
    wire                                 ap_done_frc_w;
    wire                                 ap_idle_w;
    wire                                 ap_done_w;
    wire                                 ap_start_w;
    wire   [STREAMING_TDEST_WIDTH-1:0]   init_id_w;
    wire         [INIT_STEP_WIDTH-1:0]   init_step_w;
    wire                         [2:0]   MD_state_w;
    wire                        [31:0]   iter_target_w;
    wire                                 reset_fsm_n_w;
    wire   [STREAMING_TDEST_WIDTH-1:0]   dest_id_w;
    wire                        [31:0]   number_packets_w;
    wire                       [191:0]   debug_slot_producer_pos;
    wire                       [191:0]   debug_slot_producer_frc;
    wire                       [191:0]   debug_slot_consumer_pos;
    wire                       [191:0]   debug_slot_consumer_frc;
    wire                                 debug_reset_n;
    
    logic                                k2pc_tvalid;
    logic       [AXIS_TDATA_WIDTH-1:0]   k2pc_tdata;
    
    logic       [AXIS_TDATA_WIDTH-1:0]   k2n_pos_tdata;
    logic     [AXIS_TDATA_WIDTH/8-1:0]   k2n_pos_tkeep;
    logic                                k2n_pos_tvalid;
    logic                                k2n_pos_tlast;
    logic  [STREAMING_TDEST_WIDTH-1:0]   k2n_pos_tdest;
    logic                                k2n_pos_tready;
    
    logic       [AXIS_TDATA_WIDTH-1:0]   k2n_frc_tdata;
    logic     [AXIS_TDATA_WIDTH/8-1:0]   k2n_frc_tkeep;
    logic                                k2n_frc_tvalid;
    logic                                k2n_frc_tlast;
    logic  [STREAMING_TDEST_WIDTH-1:0]   k2n_frc_tdest;
    logic                                k2n_frc_tready;
    
    wire                                 network_pos_free;
    wire                                 network_frc_free;
    wire                                 fifo_pos_full;
    wire                                 fifo_frc_full;
    wire       [PARTICLE_ID_WIDTH-1:0]   num_particles;
    wire                                 all_dirty;
    wire                                 disp_back_pressure;
    wire                                 home_buf_almost_full;
    wire                                 nb_buf_almost_full;
    wire                                 all_frc_output_ring_buf_empty;
    wire                                 all_frc_output_ring_done;
    wire                                 all_home_buf_empty;
    wire                                 all_nb_buf_empty;
    wire                                 all_disp_buf_empty;
    logic                                all_MU_buf_empty;
    logic                                MU_spinning;
    logic                                MU_reading;
    logic                                MU_writing;
    logic                                MU_busy;
    logic       [4:0]                    MU_busy_cnt;
    logic       [3:0]                    pos_state;
    logic                                MU_started;
    logic                                MU_data_once_valid;
    logic                                MU_once_writing;
    logic                                MU_once_reading;
    logic                                chk_nb_frc;
    logic                                chk_home_frc;
    logic                                chk_MU_vel_out;
    logic                                chk_MU_vel_produced;
    logic                                chk_MU_offset_in;
    logic       [PARTICLE_ID_WIDTH-1:0]  MU_num_particles;
    logic       [PARTICLE_ID_WIDTH-1:0]  MU_rd_cnt;
    logic       [31:0]                   iter_cnt;
    logic       [31:0]                   operation_cycle_cnt;
    logic                                MU_debug_migration_flag;
    logic       [31:0]                   num_particles_0;
    logic       [31:0]                   num_particles_1;
    logic       [31:0]                   num_particles_2;
    logic       [31:0]                   num_particles_3;
    logic       [31:0]                   num_particles_4;
    logic       [31:0]                   num_particles_5;
    logic       [31:0]                   num_particles_6;
    logic       [31:0]                   num_particles_7;
    logic       [31:0]                   num_particles_8;
    logic       [31:0]                   num_particles_9;
    logic       [31:0]                   num_particles_10;
    logic       [31:0]                   num_particles_11;
    logic       [31:0]                   num_particles_12;
    logic       [31:0]                   num_particles_13;
    logic       [31:0]                   num_particles_14;
    logic       [31:0]                   num_particles_15;
    logic       [31:0]                   num_particles_16;
    logic       [31:0]                   num_particles_17;
    logic       [31:0]                   num_particles_18;
    logic       [31:0]                   num_particles_19;
    logic       [31:0]                   num_particles_20;
    logic       [31:0]                   num_particles_21;
    logic       [31:0]                   num_particles_22;
    logic       [31:0]                   num_particles_23;
    logic       [31:0]                   num_particles_24;
    logic       [31:0]                   num_particles_25;
    logic       [31:0]                   num_particles_26;
    logic       [INIT_STEP_WIDTH-1:0]    init_step;
    logic       [PARTICLE_ID_WIDTH-1:0]  init_wr_addr;
    logic       [31:0]                   first_migration_iter;
    logic       [31:0]                   first_anomaly_nop_iter;

    assign ap_idle_w = ap_idle_pos_w;
    assign ap_done_w = ap_done_pos_w;
    
//////////////////////////////////////////////////////////////////
// User Logic
//////////////////////////////////////////////////////////////////

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
    .iter_target_w(iter_target_w),
    .dest_id_w(dest_id_w),
    .init_id_w(init_id_w),
    .dump_bank_sel_w(dump_bank_sel_w),
    .network_pos_free(network_pos_free),
    .network_frc_free(network_frc_free),
    .fifo_pos_full(fifo_pos_full),
    .fifo_frc_full(fifo_frc_full),
//    .num_particles(num_particles),
    .all_dirty(all_dirty),
    .all_disp_back_pressure(disp_back_pressure),
    .home_buf_almost_full(home_buf_almost_full),
    .nb_buf_almost_full(nb_buf_almost_full),
    .all_frc_output_ring_buf_empty(all_frc_output_ring_buf_empty),
    .all_frc_output_ring_done(all_frc_output_ring_done),
    .all_home_buf_empty(all_home_buf_empty),
    .all_nb_buf_empty(all_nb_buf_empty),
    .all_disp_buf_empty(all_disp_buf_empty),
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
    .num_particles_8(num_particles_8), 
    .num_particles_9(num_particles_9), 
    .num_particles_10(num_particles_10), 
    .num_particles_11(num_particles_11), 
    .num_particles_12(num_particles_12), 
    .num_particles_13(num_particles_13), 
    .num_particles_14(num_particles_14), 
    .num_particles_15(num_particles_15),
    .num_particles_16(num_particles_16), 
    .num_particles_17(num_particles_17), 
    .num_particles_18(num_particles_18), 
    .num_particles_19(num_particles_19), 
    .num_particles_20(num_particles_20), 
    .num_particles_21(num_particles_21), 
    .num_particles_22(num_particles_22), 
    .num_particles_23(num_particles_23),
    .num_particles_24(num_particles_24), 
    .num_particles_25(num_particles_25), 
    .num_particles_26(num_particles_26),
    .init_step(init_step),
    .init_wr_addr(init_wr_addr),
    .first_migration_iter(first_migration_iter),
    .first_anomaly_nop_iter(first_anomaly_nop_iter)
);

////////////////////////////////////////////////////////////////////////
// Network Forwarding Interfaces
////////////////////////////////////////////////////////////////////////

    network_interface_pos #(
        .AXIS_TDATA_WIDTH      ( AXIS_TDATA_WIDTH       ),
        .STREAMING_TDEST_WIDTH ( STREAMING_TDEST_WIDTH  )
    ) NI_pos (
        .ap_clk                ( ap_clk                 ),
        .ap_rst_n              ( ap_rst_n               ),
        
        .S_AXIS_n2k_tdata      ( k2n_pos_tdata          ),
        .S_AXIS_n2k_tkeep      ( k2n_pos_tkeep          ),
        .S_AXIS_n2k_tvalid     ( k2n_pos_tvalid         ),
        .S_AXIS_n2k_tlast      ( k2n_pos_tlast          ),
        .S_AXIS_n2k_tdest      ( k2n_pos_tdest          ),
        .S_AXIS_n2k_tready     ( k2n_pos_tready         ),
        
        .M_AXIS_k2n_tdata      ( M_AXIS_k2n_pos_tdata   ),
        .M_AXIS_k2n_tkeep      ( M_AXIS_k2n_pos_tkeep   ),
        .M_AXIS_k2n_tvalid     ( M_AXIS_k2n_pos_tvalid  ),
        .M_AXIS_k2n_tlast      ( M_AXIS_k2n_pos_tlast   ),
        .M_AXIS_k2n_tdest      ( M_AXIS_k2n_pos_tdest   ),
        .M_AXIS_k2n_tready     ( M_AXIS_k2n_pos_tready  ),
        
        .reset_fsm_n           ( reset_fsm_n_w          ),
        .ap_start              ( ap_start_w             ),
        .ap_idle               ( ap_idle_pos_w          ),
        .ap_done               ( ap_done_pos_w          ),
        .axis_producer_free    ( network_pos_free       )
    );

    network_interface_frc #(
        .AXIS_TDATA_WIDTH      ( AXIS_TDATA_WIDTH       ),
        .STREAMING_TDEST_WIDTH ( STREAMING_TDEST_WIDTH  )
    ) NI_frc (
        .ap_clk                ( ap_clk                 ),
        .ap_rst_n              ( ap_rst_n               ),
        
        .S_AXIS_n2k_tdata      ( k2n_frc_tdata          ),
        .S_AXIS_n2k_tkeep      ( k2n_frc_tkeep          ),
        .S_AXIS_n2k_tvalid     ( k2n_frc_tvalid         ),
        .S_AXIS_n2k_tlast      ( k2n_frc_tlast          ),
        .S_AXIS_n2k_tdest      ( k2n_frc_tdest          ),
        .S_AXIS_n2k_tready     ( k2n_frc_tready         ),
        
        .M_AXIS_k2n_tdata      ( M_AXIS_k2n_frc_tdata   ),
        .M_AXIS_k2n_tkeep      ( M_AXIS_k2n_frc_tkeep   ),
        .M_AXIS_k2n_tvalid     ( M_AXIS_k2n_frc_tvalid  ),
        .M_AXIS_k2n_tlast      ( M_AXIS_k2n_frc_tlast   ),
        .M_AXIS_k2n_tdest      ( M_AXIS_k2n_frc_tdest   ),
        .M_AXIS_k2n_tready     ( M_AXIS_k2n_frc_tready  ),
        
        .reset_fsm_n           ( reset_fsm_n_w          ),
        .ap_start              ( ap_start_w             ),
        .ap_idle               ( ap_idle_frc_w          ),
        .ap_done               ( ap_done_frc_w          ),
        .axis_producer_free    ( network_frc_free       )
    );

////////////////////////////////////////////////////////////////////////
// AXI-LITE and DEBUG
////////////////////////////////////////////////////////////////////////

    axi4lite #(
        .AXIL_DATA_WIDTH(AXIL_DATA_WIDTH),
        .AXIL_ADDR_WIDTH  (AXIL_ADDR_WIDTH),
        .STREAMING_TDEST_WIDTH(STREAMING_TDEST_WIDTH),
        .INIT_STEP_WIDTH(INIT_STEP_WIDTH)
    ) axi4lite_i (
        .S_AXIL_ACLK                ( ap_clk                  ),
        .S_AXIL_ARESETN             ( ap_rst_n                ),
        .S_AXIL_AWADDR              ( S_AXIL_AWADDR           ),
        .S_AXIL_AWVALID             ( S_AXIL_AWVALID          ),
        .S_AXIL_AWREADY             ( S_AXIL_AWREADY          ),
        .S_AXIL_WDATA               ( S_AXIL_WDATA            ),
        .S_AXIL_WSTRB               ( S_AXIL_WSTRB            ),
        .S_AXIL_WVALID              ( S_AXIL_WVALID           ),
        .S_AXIL_WREADY              ( S_AXIL_WREADY           ),
        .S_AXIL_BRESP               ( S_AXIL_BRESP            ),
        .S_AXIL_BVALID              ( S_AXIL_BVALID           ),
        .S_AXIL_BREADY              ( S_AXIL_BREADY           ),
        .S_AXIL_ARADDR              ( S_AXIL_ARADDR           ),
        .S_AXIL_ARVALID             ( S_AXIL_ARVALID          ),
        .S_AXIL_ARREADY             ( S_AXIL_ARREADY          ),
        .S_AXIL_RDATA               ( S_AXIL_RDATA            ),
        .S_AXIL_RRESP               ( S_AXIL_RRESP            ),
        .S_AXIL_RVALID              ( S_AXIL_RVALID           ),
        .S_AXIL_RREADY              ( S_AXIL_RREADY           ),
        .ap_done                    ( ap_done_w               ),
        .ap_idle                    ( ap_idle_w               ),
        .ap_start                   ( ap_start_w              ),
        .MD_state                   ( MD_state_w              ),
        .iter_target                ( iter_target_w           ),
        .init_id                    ( init_id_w               ),
        .dump_bank_sel              ( dump_bank_sel_w         ),
        .dest_id                    ( dest_id_w               ),
        .number_packets             ( number_packets_w        ),
        .reset_fsm_n                ( reset_fsm_n_w           ),
        .debug_reset_n              ( debug_reset_n           ),
        .debug_slot_producer_pos    ( debug_slot_producer_pos ),
        .debug_slot_producer_frc    ( debug_slot_producer_frc ),
        .debug_slot_consumer_pos    ( debug_slot_consumer_pos ),
        .debug_slot_consumer_frc    ( debug_slot_consumer_frc ),
        .debug_fifo_pos_full        ( fifo_pos_full           ),
        .debug_fifo_frc_full        ( fifo_frc_full           ),
//        .debug_num_particles        ( num_particles           ),
        .debug_all_dirty            ( all_dirty               ),
        .debug_disp_back_pressure   ( disp_back_pressure      ),
        .debug_home_buf_almost_full ( home_buf_almost_full    ),
        .debug_nb_buf_almost_full   ( nb_buf_almost_full      ),
        .debug_all_frc_output_ring_buf_empty    ( all_frc_output_ring_buf_empty ),
        .debug_all_frc_output_ring_done         ( all_frc_output_ring_done      ),
        .debug_all_home_buf_empty               ( all_home_buf_empty            ),
        .debug_all_nb_buf_empty                 ( all_nb_buf_empty              ),
        .debug_all_disp_buf_empty               ( all_disp_buf_empty            ),
        .debug_all_MU_buf_empty                 ( all_MU_buf_empty              ),
        .debug_MU_spinning                      ( MU_spinning                   ),
        .debug_MU_reading                       ( MU_reading                    ),
        .debug_MU_writing                       ( MU_writing                    ),
        .debug_MU_busy                          ( MU_busy                       ),
        .debug_MU_busy_cnt                      ( MU_busy_cnt                   ),
        .debug_pos_state                        ( pos_state                     ),
        .debug_MU_started                       ( MU_started                    ),
        .debug_MU_frc_once_valid                ( MU_frc_once_valid             ),
        .debug_MU_offset_once_valid             ( MU_offset_once_valid          ),
        .debug_MU_vel_once_valid                ( MU_vel_once_valid             ),
        .debug_MU_once_writing                  ( MU_once_writing               ),
        .debug_MU_once_reading                  ( MU_once_reading               ),
        .debug_chk_nb_frc                       ( chk_nb_frc                    ),
        .debug_chk_home_frc                     ( chk_home_frc                  ),
        .debug_chk_MU_vel_out                   ( chk_MU_vel_out                ),
        .debug_chk_MU_vel_produced              ( chk_MU_vel_produced           ),
        .debug_chk_MU_offset_in                 ( chk_MU_offset_in              ),
        .debug_MU_num_particles                 ( MU_num_particles              ),
        .debug_MU_rd_cnt                        ( MU_rd_cnt                     ),
        .debug_iter_cnt                         ( iter_cnt                      ),
        .debug_operation_cycle_cnt              ( operation_cycle_cnt           ),
        .debug_MU_migration                     ( MU_debug_migration_flag       ),
        .debug_num_particles_0                  ( num_particles_0               ),
        .debug_num_particles_1                  ( num_particles_1               ),
        .debug_num_particles_2                  ( num_particles_2               ),
        .debug_num_particles_3                  ( num_particles_3               ),
        .debug_num_particles_4                  ( num_particles_4               ),
        .debug_num_particles_5                  ( num_particles_5               ),
        .debug_num_particles_6                  ( num_particles_6               ),
        .debug_num_particles_7                  ( num_particles_7               ),
        .debug_num_particles_8                  ( num_particles_8               ), 
        .debug_num_particles_9                  ( num_particles_9               ), 
        .debug_num_particles_10                 ( num_particles_10              ), 
        .debug_num_particles_11                 ( num_particles_11              ), 
        .debug_num_particles_12                 ( num_particles_12              ), 
        .debug_num_particles_13                 ( num_particles_13              ), 
        .debug_num_particles_14                 ( num_particles_14              ), 
        .debug_num_particles_15                 ( num_particles_15              ),
        .debug_num_particles_16                 ( num_particles_16              ), 
        .debug_num_particles_17                 ( num_particles_17              ), 
        .debug_num_particles_18                 ( num_particles_18              ), 
        .debug_num_particles_19                 ( num_particles_19              ), 
        .debug_num_particles_20                 ( num_particles_20              ), 
        .debug_num_particles_21                 ( num_particles_21              ), 
        .debug_num_particles_22                 ( num_particles_22              ), 
        .debug_num_particles_23                 ( num_particles_23              ),
        .debug_num_particles_24                 ( num_particles_24              ), 
        .debug_num_particles_25                 ( num_particles_25              ), 
        .debug_num_particles_26                 ( num_particles_26              ),
        .debug_init_step                        ( init_step                     ),
        .debug_init_wr_addr                     ( init_wr_addr                  ),
        .debug_first_migration_iter             ( first_migration_iter          ),
        .debug_first_anomaly_nop_iter           ( first_anomaly_nop_iter        )
    );

    bandwidth_reg #(
        .C_AXIS_DATA_WIDTH(AXIS_TDATA_WIDTH)
    ) bw_producer_i_pos (
        .S_AXI_ACLK    ( ap_clk                     ),
        .S_AXI_ARESETN ( ap_rst_n                   ),

        .S_AXIS_TDATA  ( {AXIS_TDATA_WIDTH{1'b0}}   ),
        .S_AXIS_TKEEP  ( M_AXIS_k2n_pos_tkeep       ),
        .S_AXIS_TVALID ( M_AXIS_k2n_pos_tvalid      ),
        .M_AXIS_TREADY ( M_AXIS_k2n_pos_tready      ),
        .S_AXIS_TLAST  ( M_AXIS_k2n_pos_tlast       ),
        .S_AXIS_TUSER  ( 0                          ),
        .S_AXIS_TDEST  ( 0                          ),

        .debug_slot    ( debug_slot_producer_pos    ),
        .user_rst_n    ( debug_reset_n              )
    );

    bandwidth_reg #(
        .C_AXIS_DATA_WIDTH(AXIS_TDATA_WIDTH)
    ) bw_consumer_i_pos (
        .S_AXI_ACLK    ( ap_clk                     ),
        .S_AXI_ARESETN ( ap_rst_n                   ),

        .S_AXIS_TDATA  ( {AXIS_TDATA_WIDTH{1'b0}}   ),
        .S_AXIS_TKEEP  ( S_AXIS_n2k_pos_tkeep       ),
        .S_AXIS_TVALID ( S_AXIS_n2k_pos_tvalid      ),
        .M_AXIS_TREADY ( S_AXIS_n2k_pos_tready      ),
        .S_AXIS_TLAST  ( S_AXIS_n2k_pos_tlast       ),
        .S_AXIS_TUSER  ( 0                          ),
        .S_AXIS_TDEST  ( 0                          ),

        .debug_slot    ( debug_slot_consumer_pos    ),
        .user_rst_n    ( debug_reset_n              )
    );

    bandwidth_reg #(
        .C_AXIS_DATA_WIDTH(AXIS_TDATA_WIDTH)
    ) bw_producer_i_frc (
        .S_AXI_ACLK    ( ap_clk                     ),
        .S_AXI_ARESETN ( ap_rst_n                   ),

        .S_AXIS_TDATA  ( {AXIS_TDATA_WIDTH{1'b0}}   ),
        .S_AXIS_TKEEP  ( M_AXIS_k2n_frc_tkeep       ),
        .S_AXIS_TVALID ( M_AXIS_k2n_frc_tvalid      ),
        .M_AXIS_TREADY ( M_AXIS_k2n_frc_tready      ),
        .S_AXIS_TLAST  ( M_AXIS_k2n_frc_tlast       ),
        .S_AXIS_TUSER  ( 0                          ),
        .S_AXIS_TDEST  ( 0                          ),

        .debug_slot    ( debug_slot_producer_frc    ),
        .user_rst_n    ( debug_reset_n              )
    );

    bandwidth_reg #(
        .C_AXIS_DATA_WIDTH(AXIS_TDATA_WIDTH)
    ) bw_consumer_i_frc (
        .S_AXI_ACLK    ( ap_clk                     ),
        .S_AXI_ARESETN ( ap_rst_n                   ),

        .S_AXIS_TDATA  ( {AXIS_TDATA_WIDTH{1'b0}}   ),
        .S_AXIS_TKEEP  ( S_AXIS_n2k_frc_tkeep       ),
        .S_AXIS_TVALID ( S_AXIS_n2k_frc_tvalid      ),
        .M_AXIS_TREADY ( S_AXIS_n2k_frc_tready      ),
        .S_AXIS_TLAST  ( S_AXIS_n2k_frc_tlast       ),
        .S_AXIS_TUSER  ( 0                          ),
        .S_AXIS_TDEST  ( 0                          ),

        .debug_slot    ( debug_slot_consumer_frc    ),
        .user_rst_n    ( debug_reset_n              )
    );


endmodule

