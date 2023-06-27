`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2022 06:40:27 PM
// Design Name: 
// Module Name: MD_wrapper
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

module MD_wrapper(
    input  wire                                 ap_clk,
    input  wire                                 ap_rst_n,

    // AXI4-Stream network layer to streaming kernel 
    input  wire       [AXIS_TDATA_WIDTH-1:0]    S_AXIS_n2k_pos_tdata,
    input  wire     [AXIS_TDATA_WIDTH/8-1:0]    S_AXIS_n2k_pos_tkeep,
    input  wire                                 S_AXIS_n2k_pos_tvalid,
    input  wire                                 S_AXIS_n2k_pos_tlast,
    input  wire  [STREAMING_TDEST_WIDTH-1:0]    S_AXIS_n2k_pos_tdest,
    output wire                                 S_AXIS_n2k_pos_tready,
    // Custom output pkts to pos network interface
    output logic      [AXIS_TDATA_WIDTH-1:0]    k2n_pos_tdata,
    output logic    [AXIS_TDATA_WIDTH/8-1:0]    k2n_pos_tkeep,
    output logic                                k2n_pos_tvalid,
    output logic                                k2n_pos_tlast,
    output logic [STREAMING_TDEST_WIDTH-1:0]    k2n_pos_tdest,
    input  wire                                 k2n_pos_tready,

    // AXI4-Stream network layer to streaming kernel 
    input  wire       [AXIS_TDATA_WIDTH-1:0]    S_AXIS_n2k_frc_tdata,
    input  wire     [AXIS_TDATA_WIDTH/8-1:0]    S_AXIS_n2k_frc_tkeep,
    input  wire                                 S_AXIS_n2k_frc_tvalid,
    input  wire                                 S_AXIS_n2k_frc_tlast,
    input  wire  [STREAMING_TDEST_WIDTH-1:0]    S_AXIS_n2k_frc_tdest,
    output wire                                 S_AXIS_n2k_frc_tready,
    
    // Custom output pkts to frc network interface
    output logic      [AXIS_TDATA_WIDTH-1:0]    k2n_frc_tdata,
    output logic    [AXIS_TDATA_WIDTH/8-1:0]    k2n_frc_tkeep,
    output logic                                k2n_frc_tvalid,
    output logic                                k2n_frc_tlast,
    output logic [STREAMING_TDEST_WIDTH-1:0]    k2n_frc_tdest,
    input  wire                                 k2n_frc_tready,

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
    
    input  wire                        [2:0]    MD_state_w,
    input  wire                       [31:0]    iter_target_w,
    input  wire  [STREAMING_TDEST_WIDTH-1:0]    dest_id_w,
    input  wire  [STREAMING_TDEST_WIDTH-1:0]    init_id_w,      // Up to 8 nodes for now, so 0~7 [xyz]
    input  wire      [PARTICLE_ID_WIDTH-1:0]    init_npc_w,
    input  wire        [INIT_STEP_WIDTH-1:0]    dump_bank_sel_w,
    input  wire            [NUM_FILTERS-1:0]    dump_filter_sel_w,
    input  wire                       [31:0]    xcv_cooldown_cycles_w,
    input  wire                                 network_pos_free,
    input  wire                                 network_frc_free,
    
    output logic                                fifo_pos_full,
    output logic                                fifo_frc_full,
    output logic                                d_all_pos_ring_nodes_empty,
    output logic                                d_all_dirty,
    output logic                                all_disp_once_back_pressure,
    output logic                                all_filter_once_back_pressure,
    output logic                                all_frc_output_ring_buf_once_full,
    output logic                                home_buf_once_almost_full,
    output logic                                nb_buf_once_almost_full,
    output logic                                d_all_frc_output_ring_buf_empty,
    output logic                                d_all_frc_output_ring_done,
    output logic                                d_all_home_buf_empty,
    output logic                                d_all_nb_buf_empty,
    output logic                                d_all_disp_buf_empty,
    output logic                                MU_buf_almost_full,
    output logic                                all_MU_buf_empty,
    output logic                                MU_spinning,
    output logic                                MU_reading,
    output logic                                MU_writing,
    output logic                                MU_busy,
    output logic [4:0]                          MU_busy_cnt,
    output logic [3:0]                          pos_state,
    output logic                                MU_started,
    output logic                                MU_frc_once_valid,
    output logic                                MU_offset_once_valid,
    output logic                                MU_vel_once_valid,
    output logic                                MU_once_writing,
    output logic                                MU_once_reading,
    output logic                                chk_nb_frc,
    output logic                                chk_home_frc,
    output logic                                chk_MU_vel_out,
    output logic                                chk_MU_vel_produced,
    output logic                                chk_MU_offset_in,
    output logic [PARTICLE_ID_WIDTH-1:0]        MU_num_particles,
    output logic [PARTICLE_ID_WIDTH-1:0]        MU_rd_cnt,
    output logic [31:0]                         iter_cnt,
    output logic [31:0]                         operation_cycle_cnt,
    output logic                                MU_debug_migration_flag, 
    output wire  [31:0]                         num_particles_0, 
    output wire  [31:0]                         num_particles_1, 
    output wire  [31:0]                         num_particles_2, 
    output wire  [31:0]                         num_particles_3, 
    output wire  [31:0]                         num_particles_4, 
    output wire  [31:0]                         num_particles_5, 
    output wire  [31:0]                         num_particles_6, 
    output wire  [31:0]                         num_particles_7,
    output logic [INIT_STEP_WIDTH-1:0]          init_step,
    output logic [PARTICLE_ID_WIDTH-1:0]        init_wr_addr,
    output logic                                remote_pos_buf_once_full,
    output logic                                remote_frc_buf_once_full,
    output logic [31:0]                         last_pos_sent_cntr,
    output logic [31:0]                         last_frc_sent_cntr,
    output logic [31:0]                         pos_pkt_to_remote_valid_cntr,
    output logic [31:0]                         frc_pkt_to_remote_valid_cntr,
    output logic [31:0]                         remote_pos_tvalid_cntr,
    output logic [31:0]                         remote_frc_tvalid_cntr,
    output logic [31:0]                         last_pos_cntr,
    output logic [31:0]                         last_frc_cntr,
    output logic                                d_pos_burst_running,
    output logic                                d_frc_burst_running,
    output logic [31:0]                         pos_ring_cycle_cnt,
    output logic [31:0]                         frc_ring_cycle_cnt,
    output logic [31:0]                         filter_cycle_cnt,   // Divide by # of filters to get avg. filter cycles 
    output logic [31:0]                         PE_cycle_cnt,
    output logic [31:0]                         MU_cycle_cnt,
    output logic [31:0]                         MU_start_cntr,
    output logic [31:0]                         pos_dest_cntr_0,
    output logic [31:0]                         pos_dest_cntr_1,
    output logic [31:0]                         pos_dest_cntr_2,
    output logic [31:0]                         pos_dest_cntr_3,
    output logic [31:0]                         pos_dest_cntr_4,
    output logic [31:0]                         pos_dest_cntr_5,
    output logic [31:0]                         pos_dest_cntr_6,
    output logic [31:0]                         pos_dest_cntr_7,
    output logic [31:0]                         frc_dest_cntr_0,
    output logic [31:0]                         frc_dest_cntr_1,
    output logic [31:0]                         frc_dest_cntr_2,
    output logic [31:0]                         frc_dest_cntr_3,
    output logic [31:0]                         frc_dest_cntr_4,
    output logic [31:0]                         frc_dest_cntr_5,
    output logic [31:0]                         frc_dest_cntr_6,
    output logic [31:0]                         frc_dest_cntr_7,
    output logic [31:0]                         dest_x_cntr,
    output logic [31:0]                         dest_z_cntr,
    output logic [31:0]                         dest_xz_cntr,
    output logic                                d_remote_pos_buf_empty,
    output logic                                d_remote_frc_buf_empty,
    output logic                                d_fifo_pos_empty,
    output logic                                d_fifo_frc_empty,
    output logic                                d_ring_pos_to_remote_bufs_empty,
    output logic [31:0]                         remote_pos_buf_ack_cntr,
    output logic [31:0]                         remote_frc_buf_ack_cntr,
    output logic                                last_pos_over_received,
    output logic [31:0]                         single_iter_cycle_cnt,
    output logic                                d_all_PE_nb_buf_empty,
    output logic                                all_PE_nb_buf_once_full,
    output logic                                d_all_filter_buf_empty
);

logic                                 k2pc_tvalid;
logic       [AXIS_TDATA_WIDTH-1:0]    k2pc_tdata;

logic                                 k2h_tvalid;
logic       [AXIS_TDATA_WIDTH-1:0]    k2h_tdata;

logic                                 remote_pos_tvalid;					        // from remote
logic       [AXIS_TDATA_WIDTH-1:0]    remote_pos_tdata;

logic                                 remote_frc_tvalid;					        // from remote
logic       [AXIS_TDATA_WIDTH-1:0]    remote_frc_tdata;

// Ready to upstream, tbc
assign S_AXIS_n2k_pos_tready = 1'b1;
assign S_AXIS_n2k_frc_tready = M_AXIS_k2h_tready;
//assign S_AXIS_h2k_tready = k2n_pos_tready;        May lead to pkt duplication
assign S_AXIS_h2k_tready = 1'b1;        // Always ready, bp is handled by network output buffers. 

logic                                 fifo_pos_full_w;
logic                                 fifo_frc_full_w;

// Used to check if the buffer is once full
always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        fifo_pos_full <= 1'b0;
        fifo_frc_full <= 1'b0;
    end
    else begin
        if (fifo_pos_full_w) begin
            fifo_pos_full <= 1'b1;
        end
        if (fifo_frc_full_w) begin
            fifo_frc_full <= 1'b1;
        end
    end
end
    
logic [AXIS_PKT_STRUCT_WIDTH-1:0] axi_init_k2n_pos;
logic [AXIS_PKT_STRUCT_WIDTH-1:0] axi_infifo_k2n_pos;
logic [AXIS_PKT_STRUCT_WIDTH-1:0] axi_infifo_k2n_frc;
logic [AXIS_PKT_STRUCT_WIDTH-1:0] axis_pos_pkt_to_remote;
logic [AXIS_PKT_STRUCT_WIDTH-1:0] axis_frc_pkt_to_remote;

always@(*) begin
    if (MD_state_w == 3) begin
        axi_infifo_k2n_pos = axis_pos_pkt_to_remote;
        axi_infifo_k2n_frc = axis_frc_pkt_to_remote;
    end
    else begin
        axi_infifo_k2n_pos = axi_init_k2n_pos;
        axi_infifo_k2n_frc = 0;
    end
end

//////////////////////////////////////////////////////////////////
// Init data dispatching
//////////////////////////////////////////////////////////////////

logic                                                                   iter_target_reached;
logic           [NUM_CELLS-1:0]                                         dirty_feedback;

logic           [NUM_CELLS-1:0]         [FLOAT_STRUCT_WIDTH-1:0]        dump_data;
logic           [NUM_CELLS-1:0]         [PARTICLE_ID_WIDTH-1:0]         dump_parid;
logic           [NUM_CELLS-1:0]                                         dump_valid;
logic           [AXIS_TDATA_WIDTH-1:0]                                  dump_data_512;
logic           [INIT_STEP_WIDTH+1:0]                                   bank_sel;

init_axis_dispatcher inst_init_dispatcher
(
    .clk(ap_clk),
    .rst(~ap_rst_n),
    
    .i_init_start               ( MD_state_w == 1                      ),
    .i_MD_ready                 ( MD_state_w == 2                      ),
    .i_MD_start                 ( MD_state_w == 3                      ),
    .i_dump_start               ( iter_target_reached                  ),     // Target reached meaning the last MU starts meaning dump starts
    .i_init_ID                  ( init_id_w                            ),
    
    .o_m_axis_k2pc_tvalid       ( k2pc_tvalid                          ),     // To pos caches for init
    .o_m_axis_k2pc_tdata        ( k2pc_tdata                           ),
    
    .o_m_axis_k2h_tvalid        ( k2h_tvalid                           ),     // To host for dump
    .o_m_axis_k2h_tdata         ( k2h_tdata                            ),
    
    .o_m_axis_k2pr_tvalid       ( remote_pos_tvalid                    ),     // To pos ring
    .o_m_axis_k2pr_tdata        ( remote_pos_tdata                     ),
    
    .o_m_axis_k2fr_tvalid       ( remote_frc_tvalid                    ),     // To frc ring
    .o_m_axis_k2fr_tdata        ( remote_frc_tdata                     ),
    
    .i_dump_data                ( dump_data_512                        ),
    .i_dump_valid               ( dump_valid[0+bank_sel] & iter_target_reached),
    
    .i_s_axis_h2k_tvalid        ( S_AXIS_h2k_tvalid                    ),
    .i_s_axis_h2k_tdata         ( S_AXIS_h2k_tdata                     ),
    .i_s_axis_h2k_tkeep         ( S_AXIS_h2k_tkeep                     ),
    .i_s_axis_h2k_tlast         ( S_AXIS_h2k_tlast                     ),
    .i_s_axis_h2k_tdest         ( S_AXIS_h2k_tdest                     ),
    
    .o_m_axis_k2n_pos_tvalid    ( axi_init_k2n_pos[AXIS_PKT_STRUCT_WIDTH-1]                                        ),
    .o_m_axis_k2n_pos_tdata     ( axi_init_k2n_pos[0 +: AXIS_TDATA_WIDTH]                                          ),
    .o_m_axis_k2n_pos_tkeep     ( axi_init_k2n_pos[AXIS_TDATA_WIDTH +: AXIS_TDATA_WIDTH/8]                         ),
    .o_m_axis_k2n_pos_tlast     ( axi_init_k2n_pos[AXIS_PKT_STRUCT_WIDTH-2]                                        ),
    .o_m_axis_k2n_pos_tdest     ( axi_init_k2n_pos[AXIS_TDATA_WIDTH+AXIS_TDATA_WIDTH/8 +: STREAMING_TDEST_WIDTH]   ),
    
    .i_s_axis_n2k_pos_tvalid    ( S_AXIS_n2k_pos_tvalid                ),
    .i_s_axis_n2k_pos_tdata     ( S_AXIS_n2k_pos_tdata                 ),
    .i_s_axis_n2k_pos_tkeep     ( S_AXIS_n2k_pos_tkeep                 ),
    .i_s_axis_n2k_pos_tlast     ( S_AXIS_n2k_pos_tlast                 ),
    .i_s_axis_n2k_pos_tdest     ( S_AXIS_n2k_pos_tdest                 ),
    
    .i_s_axis_n2k_frc_tvalid    ( S_AXIS_n2k_frc_tvalid                ),
    .i_s_axis_n2k_frc_tdata     ( S_AXIS_n2k_frc_tdata                 ),
    .i_s_axis_n2k_frc_tkeep     ( S_AXIS_n2k_frc_tkeep                 ),
    .i_s_axis_n2k_frc_tlast     ( S_AXIS_n2k_frc_tlast                 ),
    .i_s_axis_n2k_frc_tdest     ( S_AXIS_n2k_frc_tdest                 )
);

//////////////////////////////////////////////////////////////////
// Init packaging for pos caches
//////////////////////////////////////////////////////////////////

//logic         [PARTICLE_ID_WIDTH-1:0]               init_wr_addr;
offset_data_t [NUM_CELLS-1:0]                       init_data;
logic         [NUM_CELLS-1:0][ELEMENT_WIDTH-1:0]    init_element;
logic         [NUM_INIT_STEPS-1:0]                  init_wr_en;
//logic         [INIT_STEP_WIDTH+1:0]                 init_bank_sel;
    
MD_init inst_MD_init
(
    .clk(ap_clk), 
    .rst(~ap_rst_n), 
    .i_init_tvalid   ( k2pc_tvalid        ), 
    .i_init_tdata    ( k2pc_tdata         ), 
    .i_init_npc      ( init_npc_w         ),
 //   .i_init_step     ( init_step_w        ),
    
    .o_init_wr_addr  ( init_wr_addr       ),
    .o_init_data     ( init_data          ),
    .o_init_element  ( init_element       ),
    .o_init_wr_en    ( init_wr_en         ),
    .o_init_step     ( init_step          )
//    .o_init_bank_sel ( init_bank_sel      )
);

//////////////////////////////////////////////////////////////////////
// Position Caches
//////////////////////////////////////////////////////////////////////

//logic           [PARTICLE_ID_WIDTH-1:0]                                 dump_rd_addr;
//logic           [NUM_INIT_STEPS-1:0]                                    dump_rd_en;
//logic           [AXIS_TDATA_WIDTH-1:0]                                  d3_dump_data_512;
//logic                                                                   d3_dump_valid;

logic           [NUM_CELLS-1:0]         [OFFSET_PKT_STRUCT_WIDTH-1:0]   raw_offset_pkt;
logic           [NUM_CELLS-1:0]         [3*GLOBAL_CELL_ID_WIDTH-1:0]    cur_gcid;
logic           [NUM_CELLS-1:0]         [(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:0]       split_lifetime;
logic           [NUM_CELLS-1:0]                                         raw_offset_valid;
logic           [NUM_CELLS-1:0]                                         raw_offset_dirty;
logic           [NUM_CELLS-1:0]         [PARTICLE_ID_WIDTH-1:0]         debug_num_particles;
logic           [NUM_CELLS-1:0]                                         debug_all_dirty;
logic           [NUM_CELLS-1:0]         [3:0]                           debug_state;

logic                                                                   MU_start;
logic           [NUM_CELLS-1:0]         [ELEMENT_WIDTH-1:0]             MU_element;
logic           [NUM_CELLS-1:0]         [OFFSET_STRUCT_WIDTH-1:0]       MU_offset;
logic           [NUM_CELLS-1:0]                                         MU_offset_valid;
logic           [NUM_CELLS-1:0]                                         MU_rd_en;
logic           [NUM_CELLS-1:0]         [PARTICLE_ID_WIDTH-1:0]         MU_rd_addr;
logic                                                                   MU_working;

logic           [NUM_CELLS-1:0]         [OFFSET_STRUCT_WIDTH-1:0]       MU_offset_return;
logic           [NUM_CELLS-1:0]         [FLOAT_STRUCT_WIDTH-1:0]        MU_vel_return;
logic           [NUM_CELLS-1:0]         [ELEMENT_WIDTH-1:0]             MU_element_return;
logic           [NUM_CELLS-1:0]                                         MU_return_valid;
logic           [NUM_CELLS-1:0]                                         MU_vel_valid;
logic           [NUM_CELLS-1:0]         [FLOAT_STRUCT_WIDTH-1:0]        MU_vel;

assign num_particles_0 = debug_num_particles[0];
assign num_particles_1 = debug_num_particles[1];
assign num_particles_2 = debug_num_particles[2];
assign num_particles_3 = debug_num_particles[3];
assign num_particles_4 = debug_num_particles[4];
assign num_particles_5 = debug_num_particles[5];
assign num_particles_6 = debug_num_particles[6];
assign num_particles_7 = debug_num_particles[7];

logic [NUM_CELLS-1:0] d1_debug_all_dirty;

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        d1_debug_all_dirty   <= 0;
    end
    else begin
        d1_debug_all_dirty   <= debug_all_dirty;
    end
end

assign all_dirty        = &d1_debug_all_dirty;


genvar j;
generate
    for (j = 0; j < NUM_CELLS; j++) begin
        assign MU_element[j]       = raw_offset_pkt[j][3*OFFSET_WIDTH +: ELEMENT_WIDTH];
        assign MU_offset[j]        = raw_offset_pkt[j][0 +: 3*OFFSET_WIDTH];
    end
endgenerate

all_pos_caches all_pos_caches
(
    .clk                    ( ap_clk                  ), 
    .rst                    ( ~ap_rst_n               ), 
    .i_PE_start             ( MD_state_w == 3         ),
    .i_MU_start             ( MU_start                ),
    .i_MU_working           ( MU_working              ),
    .i_iter_target_reached  ( iter_target_reached     ),
    .i_init_wr_addr         ( init_wr_addr            ), 
    .i_init_data            ( init_data               ), 
    .i_init_element         ( init_element            ),
    .i_init_wr_en           ( init_wr_en              ), 
    .i_dirty                ( dirty_feedback          ),
    .i_MU_rd_addr           ( MU_rd_addr              ),
    .i_MU_rd_en             ( MU_rd_en                ),
    .i_MU_wr_en             ( MU_return_valid         ),
    .i_MU_wr_pos            ( MU_offset_return        ),
    .i_MU_wr_element        ( MU_element_return       ),
    
    .o_pos_pkt              ( raw_offset_pkt          ),
    .o_cur_gcid             ( cur_gcid                ),
    .o_split_lifetime       ( split_lifetime          ),
    .o_valid                ( raw_offset_valid        ),
    .o_MU_offset_valid      ( MU_offset_valid         ),
    .o_dirty                ( raw_offset_dirty        ),
    .o_debug_num_particles  ( debug_num_particles     ),
    .o_debug_all_dirty      ( debug_all_dirty         ),
    .o_debug_state          ( debug_state             )
);

assign dump_data = MU_vel_return;
assign dump_parid = 0;
assign dump_valid = MU_return_valid;
assign bank_sel = dump_bank_sel_w << 2;

integer i;
always@(*) begin
    dump_data_512 = 0;
    for (i = 0; i < NUM_SUB_PACKETS; i = i + 1) begin
            dump_data_512[i*SUB_PACKET_WIDTH+96 +: PARTICLE_ID_WIDTH]    = dump_parid[i+bank_sel];
            dump_data_512[i*SUB_PACKET_WIDTH+64 +: FLOAT_WIDTH]          = dump_data[i+bank_sel][3*FLOAT_WIDTH-1:2*FLOAT_WIDTH];
            dump_data_512[i*SUB_PACKET_WIDTH+32 +: FLOAT_WIDTH]          = dump_data[i+bank_sel][2*FLOAT_WIDTH-1:FLOAT_WIDTH];
            dump_data_512[i*SUB_PACKET_WIDTH +: FLOAT_WIDTH]             = dump_data[i+bank_sel][FLOAT_WIDTH-1:0];
        end
    end

assign M_AXIS_k2h_tdata  = k2h_tdata;
assign M_AXIS_k2h_tvalid = k2h_tvalid;
assign M_AXIS_k2h_tkeep  = {(AXIS_TDATA_WIDTH/8){1'b1}};
assign M_AXIS_k2h_tlast  = 1;
assign M_AXIS_k2h_tdest  = 0;

////////////////////////////////////////////////////////////////////////
// Pos input ring
////////////////////////////////////////////////////////////////////////

logic        [NUM_CELLS-1:0][POS_PKT_STRUCT_WIDTH-1:0]  nb_pos_pkt;
logic        [NUM_CELLS-1:0][NODE_ID_WIDTH-1:0]         node_id_to_pe;
logic        [NUM_CELLS-1:0]                            nb_pos_pkt_valid;
logic        [NUM_CELLS-1:0]                            disp_back_pressure;
logic        [NUM_CELLS-1:0]                            filter_back_pressure;

logic        [OFFSET_PKT_STRUCT_WIDTH-1:0]   remote_offset_pkt; 						// from remote
logic        [3*GLOBAL_CELL_ID_WIDTH-1:0]    remote_pos_gcid; 
logic                                        remote_pos_valid; 
logic        [NB_CELL_COUNT_WIDTH-1:0]       remote_lifetime;

logic        [OFFSET_PKT_STRUCT_WIDTH-1:0]   offset_pkt_to_remote; 						// to remote
logic        [3*GLOBAL_CELL_ID_WIDTH-1:0]    pos_gcid_to_remote;
logic                                        offset_pkt_to_remote_valid;
logic        [NUM_REMOTE_DEST_NODES*NB_CELL_COUNT_WIDTH-1:0]    lifetime_to_remote;
logic                                        all_pos_ring_nodes_empty;
logic                                        remote_ack_from_pos_ring;
logic                                        ring_pos_to_remote_bufs_empty;

logic        [NUM_REMOTE_DEST_NODES-1:0]     last_pos_sent;
logic        [NUM_REMOTE_DEST_NODES-1:0]     last_frc_sent;

pos_input_ring inst_pos_input_ring (
    .clk                            ( ap_clk                        ), 
    .rst                            ( ~ap_rst_n                     ),
    .local_node_id                  ( init_id_w[NODE_ID_WIDTH-1:0]  ),
    .local_offset_pkt               ( raw_offset_pkt                ),
    .local_split_lifetime           ( split_lifetime                ),
    .local_gcid                     ( cur_gcid                      ),
    .local_valid                    ( raw_offset_valid              ),
    .local_dirty                    ( raw_offset_dirty              ),
    .dispatcher_back_pressure       ( disp_back_pressure            ),
    .remote_offset_pkt              ( remote_offset_pkt             ),
    .remote_gcid                    ( remote_pos_gcid               ),
    .remote_valid                   ( remote_pos_valid              ),
    .remote_lifetime                ( remote_lifetime               ),
    .remote_buffer_back_pressure    ( fifo_pos_full_w               ),
    
    .pos_pkt_to_pe                  ( nb_pos_pkt                    ),
    .node_id_to_pe                  ( node_id_to_pe                 ),
    .pos_pkt_to_pe_valid            ( nb_pos_pkt_valid              ),
    .dirty_feedback                 ( dirty_feedback                ),
    .offset_pkt_to_remote           ( offset_pkt_to_remote          ),
    .gcid_to_remote                 ( pos_gcid_to_remote            ),
    .offset_pkt_to_remote_valid     ( offset_pkt_to_remote_valid    ),
    .lifetime_to_remote             ( lifetime_to_remote            ),
    .all_nodes_empty                ( all_pos_ring_nodes_empty      ),
    .remote_ack                     ( remote_ack_from_pos_ring      )
);

////////////////////////////////////////////////////////////////////////
// Remote Pos Controller
////////////////////////////////////////////////////////////////////////

logic                                   last_pos_transfer_from_remote;
logic                                   remote_pos_buf_valid;					        // from remote in buf
logic                                   remote_pos_buf_empty;
logic    [AXIS_TDATA_WIDTH-1:0]         remote_pos_buf_data;
logic                                   remote_pos_buf_ack;
logic                                   remote_pos_buf_full;
logic                                   pos_burst_running;

REMOTE_IN_FIFO remote_pos_in_fifo (
    .clk        ( ap_clk                ),
    .rst        ( ~ap_rst_n             ),
    .din        ( remote_pos_tdata      ),
    .wr_en      ( remote_pos_tvalid     ),
    .rd_en      ( remote_pos_buf_ack    ),
    
    .empty      ( remote_pos_buf_empty  ),
    .prog_full  ( remote_pos_buf_full   ),
    .dout       ( remote_pos_buf_data   )
);

assign remote_pos_buf_valid = ~remote_pos_buf_empty;

remote_pos_to_ring_controller remote_pos_to_ring_controller (
    .clk                            ( ap_clk                        ), 
    .rst                            ( ~ap_rst_n                     ),
    .i_remote_tdata                 ( remote_pos_buf_data           ),
    .i_remote_tvalid                ( remote_pos_buf_valid          ),
    .i_remote_ack_from_ring         ( remote_ack_from_pos_ring      ),
    
    .o_remote_offset_pkt            ( remote_offset_pkt             ),
    .o_remote_gcid                  ( remote_pos_gcid               ),
    .o_remote_valid                 ( remote_pos_valid              ),
    .o_remote_lifetime              ( remote_lifetime               ),
    .o_last_transfer_from_remote    ( last_pos_transfer_from_remote ),      // sys signal, resets to 0 in the next iter
    .o_remote_input_buf_ack         ( remote_pos_buf_ack            )
);

ring_pos_to_remote_controller_chain ring_pos_to_remote_controller_chain (
    .clk                            ( ap_clk                        ), 
    .rst                            ( ~ap_rst_n                     ),
    .i_init_id                      ( init_id_w[NODE_ID_WIDTH-1:0]  ),      // tbc
    .i_all_pos_ring_nodes_empty     ( all_pos_ring_nodes_empty      ),
    .i_all_dirty                    ( all_dirty                     ),
    .i_offset_pkt_to_remote         ( offset_pkt_to_remote          ),
    .i_gcid_to_remote               ( pos_gcid_to_remote            ),
    .i_offset_pkt_to_remote_valid   ( offset_pkt_to_remote_valid    ),
    .i_lifetime_to_remote           ( lifetime_to_remote            ),
    
    .o_axis_pos_pkt_to_remote       ( axis_pos_pkt_to_remote        ),
    .o_ring_pos_to_remote_bufs_empty( ring_pos_to_remote_bufs_empty ),
    .o_pos_burst_running            ( pos_burst_running             ),
    .o_last_pos_sent                ( last_pos_sent                 )       // Each high for one remote node
);

////////////////////////////////////////////////////////////////////////
// Output Buffers
////////////////////////////////////////////////////////////////////////

logic fifo_pos_empty;
logic fifo_frc_empty;
logic ready_to_send;
logic [15:0] send_cooldown;

// Temporary cooldown mechanism to ensure there's no network congestion
always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        ready_to_send <= 1'b0;
        send_cooldown <= 0;
    end
    else begin
        if (send_cooldown == xcv_cooldown_cycles_w) begin
            send_cooldown <= 0;
            ready_to_send <= 1'b1;
        end
        else begin
            send_cooldown <= send_cooldown + 1'b1;
            ready_to_send <= 1'b0;
        end
    end
end

logic k2n_pos_data_valid;
logic k2n_frc_data_valid;

// First word falls through, so valid needs to be controlled by ready_to_send, to avoid repeated reading
assign k2n_pos_tvalid = k2n_pos_data_valid & ready_to_send;
assign k2n_frc_tvalid = k2n_frc_data_valid & ready_to_send;

NETWORK_OUT_FIFO net_fifo_pos (
    .clk_0          ( ap_clk                                ),
    .srst_0         ( ~ap_rst_n                             ),
    .din_0          ( axi_infifo_k2n_pos[AXIS_PKT_STRUCT_WIDTH-2:0]           ),
    .wr_en_0        ( axi_infifo_k2n_pos[AXIS_PKT_STRUCT_WIDTH-1]             ),        // tbc
    .rd_en_0        ( network_pos_free & ~fifo_pos_empty & ready_to_send   ),
    
    .prog_full_0    ( fifo_pos_full_w                       ),
    .empty_0        ( fifo_pos_empty                        ),
    .valid_0        ( k2n_pos_data_valid                    ),
    .dout_0         ( {k2n_pos_tlast,
                       k2n_pos_tdest, 
                       k2n_pos_tkeep, 
                       k2n_pos_tdata}                       )
);

NETWORK_OUT_FIFO net_fifo_frc (
    .clk_0          ( ap_clk                                ),
    .srst_0         ( ~ap_rst_n                             ),
    .din_0          ( axi_infifo_k2n_frc[AXIS_PKT_STRUCT_WIDTH-2:0]),
    .wr_en_0        ( axi_infifo_k2n_frc[AXIS_PKT_STRUCT_WIDTH-1]  ),        // tbc
    .rd_en_0        ( network_frc_free & ~fifo_frc_empty & ready_to_send   ),
    
    .prog_full_0    ( fifo_frc_full_w                       ),
    .empty_0        ( fifo_frc_empty                        ),
    .valid_0        ( k2n_frc_data_valid                    ),
    .dout_0         ( {k2n_frc_tlast, 
                       k2n_frc_tdest, 
                       k2n_frc_tkeep, 
                       k2n_frc_tdata}                       )
);

////////////////////////////////////////////////////////////////////////
// PE
////////////////////////////////////////////////////////////////////////
logic [NUM_CELLS-1:0] d1_disp_back_pressure;
logic [NUM_CELLS-1:0] d1_filter_back_pressure;
logic all_disp_back_pressure;
logic all_filter_back_pressure;
logic all_PE_nb_buf_empty;
logic all_PE_nb_buf_full;
logic all_filter_buf_empty;

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        d1_disp_back_pressure   <= 0;
        d1_filter_back_pressure <= 0;
    end
    else begin
        d1_disp_back_pressure   <= all_disp_back_pressure;
        d1_filter_back_pressure <= all_filter_back_pressure;
    end
end

assign all_disp_back_pressure = | d1_disp_back_pressure;
assign all_filter_back_pressure = | d1_filter_back_pressure;

logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH*NUM_PES_PER_CELL-1:0]  home_frc;
logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH*NUM_PES_PER_CELL-1:0]   home_frc_parid;
logic [NUM_CELLS-1:0][NUM_PES_PER_CELL-1:0]                     home_frc_valid;
logic [NUM_CELLS-1:0][FRC_PKT_STRUCT_WIDTH-1:0]                 nb_frc_to_ring;
logic [NUM_CELLS-1:0][NODE_ID_WIDTH-1:0]                        frc_node_id_to_ring;
logic [NUM_CELLS-1:0]                                           nb_frc_to_ring_valid;
logic [NUM_CELLS-1:0]                                           disp_buf_empty;
logic [NUM_CELLS-1:0][NUM_FILTERS-1:0]                          filtering_flag;
logic [NUM_CELLS-1:0]                                           pair_valid;
logic                                                           pos_spinning;
logic [NUM_CELLS-1:0]                                           PE_nb_buf_empty;
logic [NUM_CELLS-1:0]                                           PE_nb_buf_full;
logic [NUM_CELLS-1:0]                                           filter_buf_empty;

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        pos_state       <= 0;
        pos_spinning    <= 0;
    end
    else begin
        pos_state       <= debug_state[0];
        pos_spinning    <= pos_state == 3; //broadcast state
    end
end

assign all_disp_buf_empty     = & disp_buf_empty;
assign all_PE_nb_buf_empty    = & PE_nb_buf_empty;
assign all_PE_nb_buf_full     = | PE_nb_buf_full;
assign all_filter_buf_empty   = & filter_buf_empty;

generate
	for (j = 0; j < NUM_CELLS; j++) begin: PE_wrappers
		PE_wrapper inst_PE_wrapper (
			.clk                 ( ap_clk                    ), 
			.rst                 ( ~ap_rst_n                 ), 
			
			.pos_spinning        ( pos_spinning              ),
			.home_offset         ( raw_offset_pkt[j]         ), 
			.home_offset_valid   ( raw_offset_valid[j]       ), 
			.nb_pos              ( nb_pos_pkt[j]             ), 
			.pos_node_id         ( node_id_to_pe[j]          ),
			.nb_pos_valid        ( nb_pos_pkt_valid[j]       ), 
			
			.home_frc            ( home_frc[j]               ), 
			.home_frc_parid      ( home_frc_parid[j]         ),
			.home_frc_valid      ( home_frc_valid[j]         ),
			.nb_frc_acc          ( nb_frc_to_ring[j]         ), 
			.frc_node_id         ( frc_node_id_to_ring[j]    ), 
			.nb_frc_acc_valid    ( nb_frc_to_ring_valid[j]   ),
			.disp_back_pressure  ( disp_back_pressure[j]     ),
			.disp_buf_empty      ( disp_buf_empty[j]         ),
			.filter_back_pressure( filter_back_pressure[j]   ),
			.filtering_flag      ( filtering_flag[j]         ),
			.pair_valid          ( pair_valid[j]             ),
			.PE_nb_buf_empty     ( PE_nb_buf_empty[j]        ),
			.PE_nb_buf_full      ( PE_nb_buf_full[j]         ),
			.filter_buf_empty    ( filter_buf_empty[j]       )
		);
	end
endgenerate

logic [NUM_FILTERS-1:0][31:0] filter_cntr;

generate
    for (j = 0; j < NUM_FILTERS; j++) begin: filter_cntrs
        always@(posedge ap_clk) begin
            if (~ap_rst_n) begin
                filter_cntr[j] <= 0;
            end
            else begin
                if (filtering_flag[0][j]) begin
                    filter_cntr[j] <= filter_cntr[j] + 1'b1;
                end
            end
        end
    end
endgenerate

////////////////////////////////////////////////////////////////////////
// Force output ring
////////////////////////////////////////////////////////////////////////
	
logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]   nb_frc;
logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0]    nb_frc_parid;
logic [NUM_CELLS-1:0]                           nb_frc_valid;
logic [NUM_CELLS-1:0]                           frc_output_ring_buf_full;
logic [NUM_CELLS-1:0]                           frc_output_ring_buf_empty;
logic [NUM_CELLS-1:0]                           frc_output_ring_running;
logic                                           frc_output_ring_running_ext;

logic [FLOAT_STRUCT_WIDTH-1:0]                  remote_frc;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]              remote_frc_gcid;
logic [PARTICLE_ID_WIDTH-1:0]                   remote_frc_parid;
logic                                           remote_frc_valid;

logic [FLOAT_STRUCT_WIDTH-1:0]                  frc_to_remote;          // to remote
logic                                           frc_to_remote_valid;
logic [PARTICLE_ID_WIDTH-1:0]                   frc_parid_to_remote;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]              frc_gcid_to_remote;
logic                                           remote_ack_from_frc_ring;

logic [REMOTE_NODE_IDX_WIDTH+1:0]               last_pos_received;      // Different from 2 nodes, now need more than 1 last received
logic [REMOTE_NODE_IDX_WIDTH+1:0]               last_frc_received;

logic                                           all_frc_output_ring_buf_full;
logic [NUM_REMOTE_DEST_NODES-1:0]               frc_ticket_onehot;

logic [NUM_CELLS-1:0] d1_frc_output_ring_buf_full;
logic [NUM_CELLS-1:0] d1_frc_output_ring_buf_empty;
logic [NUM_CELLS-1:0] d1_frc_output_ring_running;
logic                 d1_frc_output_ring_running_ext;


always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        d1_frc_output_ring_buf_full     <= 0;
        d1_frc_output_ring_buf_empty    <= 0;
        d1_frc_output_ring_running      <= 0;
        d1_frc_output_ring_running_ext  <= 1'b0;
    end
    else begin
        d1_frc_output_ring_buf_full     <= frc_output_ring_buf_full;
        d1_frc_output_ring_buf_empty    <= frc_output_ring_buf_empty;
        d1_frc_output_ring_running      <= frc_output_ring_running;
        d1_frc_output_ring_running_ext  <= frc_output_ring_running_ext;
    end
end

assign all_frc_output_ring_buf_full  = | d1_frc_output_ring_buf_full;
assign all_frc_output_ring_buf_empty = & d1_frc_output_ring_buf_empty;
assign all_frc_output_ring_done = (& (~d1_frc_output_ring_running)) & (~d1_frc_output_ring_running_ext);

force_output_ring inst_frc_output_ring (
    .clk                                ( ap_clk                        ),
    .rst                                ( ~ap_rst_n                     ),
    .i_nb_force                         ( nb_frc_to_ring                ),
    .i_node_id                          ( frc_node_id_to_ring           ),
    .i_nb_force_valid                   ( nb_frc_to_ring_valid          ),
    .i_local_node_id                    ( init_id_w[NODE_ID_WIDTH-1:0]  ),
    .i_remote_force                     ( remote_frc                    ),
    .i_remote_gcid                      ( remote_frc_gcid               ),
    .i_remote_parid                     ( remote_frc_parid              ),
    .i_remote_force_valid               ( remote_frc_valid              ),
    .i_remote_buffer_back_pressure      ( fifo_frc_full_w               ),
    
    .o_nb_force_to_force_cache          ( nb_frc                        ),
    .o_nb_parid_to_force_cache          ( nb_frc_parid                  ),
    .o_nb_force_to_force_cache_valid    ( nb_frc_valid                  ),
    .o_force_output_ring_buf_full       ( frc_output_ring_buf_full      ),
    .o_force_output_ring_buf_empty      ( frc_output_ring_buf_empty     ),
    .o_nb_valid_ring                    ( frc_output_ring_running       ),
    .o_nb_valid_ext                     ( frc_output_ring_running_ext   ),
    .o_force_to_remote                  ( frc_to_remote                 ),
    .o_force_to_remote_valid            ( frc_to_remote_valid           ),
    .o_parid_to_remote                  ( frc_parid_to_remote           ),
    .o_gcid_to_remote                   ( frc_gcid_to_remote            ),
    .o_nb_ticket_onehot                 ( frc_ticket_onehot             ),
    .o_remote_ack                       ( remote_ack_from_frc_ring      )
);

////////////////////////////////////////////////////////////////////////
// Remote Frc Controller
////////////////////////////////////////////////////////////////////////

logic                                   last_frc_transfer_from_remote;
logic                                   remote_frc_eval_flag;
logic                                   remote_frc_eval_complete;
logic                                   remote_frc_buf_valid;					        // from remote in buf
logic                                   remote_frc_buf_empty;
logic    [AXIS_TDATA_WIDTH-1:0]         remote_frc_buf_data;
logic                                   remote_frc_buf_ack;
logic                                   remote_frc_buf_full;
logic                                   frc_burst_running;

REMOTE_IN_FIFO remote_frc_in_fifo (
    .clk        ( ap_clk                ),
    .rst        ( ~ap_rst_n             ),
    .din        ( remote_frc_tdata      ),
    .wr_en      ( remote_frc_tvalid     ),
    .rd_en      ( remote_frc_buf_ack    ),
    
    .empty      ( remote_frc_buf_empty ),
    .prog_full  ( remote_frc_buf_full   ),
    .dout       ( remote_frc_buf_data   )
);

assign remote_frc_buf_valid = ~remote_frc_buf_empty;

remote_frc_to_ring_controller remote_frc_to_ring_controller (
    .clk                            ( ap_clk                        ), 
    .rst                            ( ~ap_rst_n                     ),
    .i_remote_tdata                 ( remote_frc_buf_data           ),
    .i_remote_tvalid                ( remote_frc_buf_valid          ),
    .i_remote_ack_from_ring         ( remote_ack_from_frc_ring      ),
    
    .o_remote_frc                   ( remote_frc                    ),
    .o_remote_gcid                  ( remote_frc_gcid               ),
    .o_remote_frc_parid             ( remote_frc_parid              ),
    .o_remote_valid                 ( remote_frc_valid              ),
    .o_last_transfer_from_remote    ( last_frc_transfer_from_remote ),      // sys signal, resets to 0 in the next iter
    .o_remote_input_buf_ack         ( remote_frc_buf_ack            )
);
    
ring_frc_to_remote_controller ring_frc_to_remote_controller (
    .clk                            ( ap_clk                        ), 
    .rst                            ( ~ap_rst_n                     ),
    .i_init_id                      ( init_id_w[NODE_ID_WIDTH-1:0]  ),
    .i_remote_frc_eval_flag         ( remote_frc_eval_complete      ),      // remote frc eval done
    .i_frc_to_remote                ( frc_to_remote                 ),
    .i_frc_gcid_to_remote           ( frc_gcid_to_remote            ),
    .i_frc_to_remote_valid          ( frc_to_remote_valid           ),
    .i_frc_parid_to_remote          ( frc_parid_to_remote           ),
    .i_frc_ticket                   ( frc_ticket_onehot             ),
    
    .o_axis_frc_pkt_to_remote       ( axis_frc_pkt_to_remote        ),
    .o_frc_burst_running            ( frc_burst_running             ),
    .o_last_frc_sent                ( last_frc_sent                 )
);

////////////////////////////////////////////////////////////////////////
// Force Caches
////////////////////////////////////////////////////////////////////////
                                        
logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH*NUM_PES_PER_CELL-1:0]  MU_home_frc;
logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]                   MU_nb_frc;
logic [NUM_CELLS-1:0]                                           MU_frc_valid;
logic                                                           home_buf_almost_full;
logic                                                           nb_buf_almost_full;

all_force_caches all_force_caches (
    .clk                    ( ap_clk                ),
    .rst                    ( ~ap_rst_n             ),
    .i_home_frc             ( home_frc              ),
    .i_home_frc_parid       ( home_frc_parid        ),
    .i_home_frc_valid       ( home_frc_valid        ),
    .i_nb_frc               ( nb_frc                ),
    .i_nb_frc_parid         ( nb_frc_parid          ),
    .i_nb_frc_valid         ( nb_frc_valid          ),
    .i_MU_rd_addr           ( MU_rd_addr            ),
    .i_MU_rd_en             ( MU_rd_en              ),
    
    .o_home_frc             ( MU_home_frc           ),
    .o_home_buf_almost_full ( home_buf_almost_full  ),
    .o_home_buf_empty       ( all_home_buf_empty    ),
    .o_nb_frc               ( MU_nb_frc             ),
    .o_nb_buf_almost_full   ( nb_buf_almost_full    ),
    .o_nb_buf_empty         ( all_nb_buf_empty      ),
    .o_frc_valid            ( MU_frc_valid          )
);

////////////////////////////////////////////////////////////////////////
// Velocity Caches
////////////////////////////////////////////////////////////////////////

all_velocity_caches all_velocity_caches (
    .clk                    ( ap_clk          ), 
    .rst                    ( ~ap_rst_n       ), 
    .i_MU_start             ( MU_start        ),
	.i_MU_working           ( MU_working      ),
    .i_MU_rd_addr           ( MU_rd_addr      ), 
    .i_MU_rd_en             ( MU_rd_en        ), 
    .i_MU_wr_en             ( MU_return_valid ),
    .i_MU_wr_vel            ( MU_vel_return   ), 
    
    .o_MU_vel               ( MU_vel          ),
    .o_MU_vel_valid         ( MU_vel_valid    )
);

////////////////////////////////////////////////////////////////////////
// Motion Update Control
////////////////////////////////////////////////////////////////////////

logic                                           frc_eval_complete;
logic                                           d1_frc_eval_complete;
logic                                           frc_eval_flag;
logic [5:0]                                     frc_eval_cnt;
logic [5:0]                                     remote_frc_eval_cnt;

logic [NUM_CELLS-1:0][OFFSET_STRUCT_WIDTH-1:0]  offset_fwd_link;
logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]   vel_fwd_link;
logic [NUM_CELLS-1:0][ELEMENT_WIDTH-1:0]        element_fwd_link;
logic [NUM_CELLS-1:0][MU_ID_WIDTH-1:0]          MU_id_fwd_link;
logic [NUM_CELLS-1:0]                           fwd_link_valid;
logic [NUM_CELLS-1:0]                           MU_data_valid;
logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]   MU_debug_vel;
logic [NUM_CELLS-1:0]                           MU_debug_vel_valid;
logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0]    MU_debug_particle_num;
logic [NUM_CELLS-1:0]                           MU_debug_migration;
logic [NUM_CELLS-1:0]                           d1_MU_debug_migration;

assign MU_num_particles = MU_debug_particle_num[0];

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        d1_MU_debug_migration <= 0;
    end
    else begin
        d1_MU_debug_migration <= MU_debug_migration;
    end
end

assign MU_debug_migration_flag = |d1_MU_debug_migration;

assign MU_data_valid = MU_frc_valid & MU_offset_valid & MU_vel_valid;

logic [NUM_CELLS-1:0]                           MU_buf_full;
logic [NUM_CELLS-1:0]                           MU_buf_empty;

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        frc_eval_complete       <= 1'b0;
        d1_frc_eval_complete    <= 1'b0;
        frc_eval_cnt            <= 0;
    end
    else begin
        d1_frc_eval_complete <= frc_eval_complete;
        if (frc_eval_flag) begin            // This state is lasted for more than 35 cycles to ensure frc eval is done
            if (frc_eval_cnt < 50) begin
                frc_eval_complete <= 1'b0;
                frc_eval_cnt <= frc_eval_cnt + 1'b1;
            end
            else begin
                frc_eval_complete <= 1'b1;
            end
        end
        else begin
            frc_eval_complete <= 1'b0;
            frc_eval_cnt <= 0;
        end
    end
end

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        remote_frc_eval_complete       <= 1'b0;
        remote_frc_eval_cnt            <= 0;
    end
    else begin
        if (remote_frc_eval_flag) begin            // This state is lasted for more than 35 cycles to ensure frc eval is done
            if (remote_frc_eval_cnt < 50) begin
                remote_frc_eval_complete <= 1'b0;
                remote_frc_eval_cnt <= remote_frc_eval_cnt + 1'b1;
            end
            else begin
                remote_frc_eval_complete <= 1'b1;
            end
        end
        else begin
            remote_frc_eval_complete <= 1'b0;
            remote_frc_eval_cnt <= 0;
        end
    end
end

// System signals delay to avoid critical path
logic [REMOTE_NODE_IDX_WIDTH+1:0]   d_last_pos_received;
logic [REMOTE_NODE_IDX_WIDTH+1:0]   d_last_frc_received;
logic                               d_remote_pos_buf_ack;
logic                               d_remote_frc_buf_ack;
logic                               remote_frc_eval_flag_lv1_0;
logic                               remote_frc_eval_flag_lv1_1;
logic                               remote_frc_eval_flag_lv1_2;
logic                               remote_frc_eval_flag_lv1_3;

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        d_all_dirty                        <= 1'b0;
        d_all_frc_output_ring_buf_empty    <= 1'b0;
        d_all_frc_output_ring_done         <= 1'b0;
        d_all_pos_ring_nodes_empty         <= 1'b0;
        d_remote_pos_buf_empty             <= 1'b0;
        d_remote_frc_buf_empty             <= 1'b0;    
        d_all_home_buf_empty               <= 1'b0;
        d_all_nb_buf_empty                 <= 1'b0;
        d_all_disp_buf_empty               <= 1'b0;
        d_last_pos_received                <= 0;
        d_last_frc_received                <= 0;  
        d_pos_burst_running                <= 1'b0;
        d_frc_burst_running                <= 1'b0;
        d_fifo_pos_empty                   <= 1'b0;
        d_fifo_frc_empty                   <= 1'b0;
        d_ring_pos_to_remote_bufs_empty    <= 1'b0;
        remote_frc_eval_flag               <= 1'b0; 
        remote_frc_eval_flag_lv1_0         <= 1'b0; 
        remote_frc_eval_flag_lv1_1         <= 1'b0; 
        remote_frc_eval_flag_lv1_2         <= 1'b0; 
        remote_frc_eval_flag_lv1_3         <= 1'b0; 
        d_remote_pos_buf_ack               <= 1'b0;
        d_remote_frc_buf_ack               <= 1'b0;
        d_all_PE_nb_buf_empty              <= 1'b0;
        d_all_filter_buf_empty             <= 1'b0;
    end
    else begin
        d_all_dirty                        <= all_dirty;
        d_all_frc_output_ring_buf_empty    <= all_frc_output_ring_buf_empty;
        d_all_frc_output_ring_done         <= all_frc_output_ring_done;
        d_all_pos_ring_nodes_empty         <= all_pos_ring_nodes_empty;
        d_remote_pos_buf_empty             <= remote_pos_buf_empty;
        d_remote_frc_buf_empty             <= remote_frc_buf_empty;
        d_all_home_buf_empty               <= all_home_buf_empty;
        d_all_nb_buf_empty                 <= all_nb_buf_empty;
        d_all_disp_buf_empty               <= all_disp_buf_empty;
        d_last_pos_received                <= last_pos_received;
        d_pos_burst_running                <= pos_burst_running;
        d_frc_burst_running                <= frc_burst_running;
        d_last_frc_received                <= last_frc_received; 
        d_fifo_pos_empty                   <= fifo_pos_empty; 
        d_fifo_frc_empty                   <= fifo_frc_empty; 
        d_ring_pos_to_remote_bufs_empty    <= ring_pos_to_remote_bufs_empty;
        remote_frc_eval_flag_lv1_0         <= d_all_dirty & d_all_frc_output_ring_buf_empty & d_all_frc_output_ring_done & d_all_PE_nb_buf_empty;
        remote_frc_eval_flag_lv1_1         <= d_fifo_pos_empty & d_fifo_frc_empty & d_ring_pos_to_remote_bufs_empty & d_all_filter_buf_empty;
        remote_frc_eval_flag_lv1_2         <= d_all_pos_ring_nodes_empty & d_remote_pos_buf_empty 
                                            & d_remote_frc_buf_empty & (d_last_pos_received >= NUM_REMOTE_DEST_NODES);
        remote_frc_eval_flag_lv1_3         <= d_all_home_buf_empty & d_all_nb_buf_empty & d_all_disp_buf_empty & (~d_pos_burst_running);
        remote_frc_eval_flag               <= remote_frc_eval_flag_lv1_0 & remote_frc_eval_flag_lv1_1 
                                            & remote_frc_eval_flag_lv1_2 & remote_frc_eval_flag_lv1_3;
        d_remote_pos_buf_ack               <= remote_pos_buf_ack;
        d_remote_frc_buf_ack               <= remote_frc_buf_ack;
        d_all_PE_nb_buf_empty              <= all_PE_nb_buf_empty;
        d_all_filter_buf_empty             <= all_filter_buf_empty;
    end
end

assign last_pos_cntr = d_last_pos_received;
assign last_frc_cntr = d_last_frc_received;

assign frc_eval_flag        = remote_frc_eval_flag & (d_last_frc_received == NUM_REMOTE_DEST_NODES);
assign MU_start             = frc_eval_complete & ~d1_frc_eval_complete;

logic [NUM_CELLS-1:0] d1_MU_buf_empty;
logic [NUM_CELLS-1:0] d1_fwd_link_valid;
logic [NUM_CELLS-1:0] d1_MU_rd_en;
logic [NUM_CELLS-1:0] d1_MU_return_valid;
logic [NUM_CELLS-1:0] d1_MU_buf_full;

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        d1_MU_buf_empty     <= 0;
        d1_fwd_link_valid   <= 0;
        d1_MU_rd_en         <= 0;
        d1_MU_return_valid  <= 0;
        MU_busy             <= 0;
        d1_MU_buf_full      <= 0;
    end
    else begin
        d1_MU_buf_empty     <= MU_buf_empty;
        d1_fwd_link_valid   <= fwd_link_valid;
        d1_MU_rd_en         <= MU_rd_en;
        d1_MU_return_valid  <= MU_return_valid;
        MU_busy             <= ~all_MU_buf_empty | MU_spinning | MU_reading | MU_writing;
        d1_MU_buf_full      <= MU_buf_full;
    end
end

assign all_MU_buf_empty     = & d1_MU_buf_empty;
assign MU_spinning          = | d1_fwd_link_valid;
assign MU_reading           = | d1_MU_rd_en;
assign MU_writing           = | d1_MU_return_valid;
assign iter_target_reached  = iter_cnt == iter_target_w;
assign MU_buf_almost_full   = | d1_MU_buf_full;

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        MU_busy_cnt         <= 0;
        MU_working          <= 1'b0;
        iter_cnt            <= 0;
        last_pos_received   <= 0;
        last_frc_received   <= 0;
    end
    else begin
        if (MU_start) begin
            MU_working <= 1'b1;
            iter_cnt   <= iter_cnt + 1'b1;
            last_pos_received <= last_pos_received - NUM_REMOTE_DEST_NODES;          // Reset the communication flags
            last_frc_received <= last_frc_received - NUM_REMOTE_DEST_NODES;
        end
        else begin
            if (last_pos_transfer_from_remote) begin
                last_pos_received <= last_pos_received + 1'b1;
            end
            if (last_frc_transfer_from_remote) begin
                last_frc_received <= last_frc_received + 1'b1;
            end
            if (MU_working) begin
                if (~MU_busy) begin
                    MU_busy_cnt <= MU_busy_cnt + 1'b1;
                end
                else begin
                    MU_busy_cnt <= 0;
                end
                if (MU_busy_cnt == 20) begin
                    MU_working <= 1'b0;
                end
            end
            else begin
                MU_busy_cnt <= 0;
            end
        end
    end
end
                                        
generate
	for (j = 0; j < NUM_CELLS; j++) begin: MUs
        motion_update_control #(
			.GCELL_X   ( {j / (Y_DIM * Z_DIM)}   ), 
			.GCELL_Y   ( {j / Z_DIM % Y_DIM}     ), 
			.GCELL_Z   ( {j % Z_DIM}             )
        )
        inst_motion_update_units (
            .clk                    ( ap_clk                    ),
            .rst                    ( ~ap_rst_n                 ), 
            .MU_start               ( MU_start                  ), 
            .i_home_frc             ( MU_home_frc[j]            ), 
            .i_nb_frc               ( MU_nb_frc[j]              ), 
            .i_offset               ( MU_offset[j]              ), 
            .i_vel                  ( MU_vel[j]                 ), 
            .i_element              ( MU_element[j]             ), 
            .i_data_valid           ( MU_data_valid[j]          ), 
            .i_MU_id                ( MU_id_fwd_link[(j+NUM_CELLS-1)%NUM_CELLS]   ), 
            .i_offset_fwd           ( offset_fwd_link[(j+NUM_CELLS-1)%NUM_CELLS]  ), 
            .i_vel_fwd              ( vel_fwd_link[(j+NUM_CELLS-1)%NUM_CELLS]     ), 
            .i_element_fwd          ( element_fwd_link[(j+NUM_CELLS-1)%NUM_CELLS] ), 
            .i_fwd_valid            ( fwd_link_valid[(j+NUM_CELLS-1)%NUM_CELLS]   ), 
            
            .o_offset               ( MU_offset_return[j]       ),  
            .o_vel                  ( MU_vel_return[j]          ),  
            .o_element              ( MU_element_return[j]      ),  
            .o_data_valid           ( MU_return_valid[j]        ),  
            .o_MU_id                ( MU_id_fwd_link[j]         ),  
            .o_offset_fwd           ( offset_fwd_link[j]        ),  
            .o_vel_fwd              ( vel_fwd_link[j]           ), 
            .o_element_fwd          ( element_fwd_link[j]       ), 
            .o_fwd_valid            ( fwd_link_valid[j]         ), 
            .o_rd_addr              ( MU_rd_addr[j]             ), 
            .o_rd_en                ( MU_rd_en[j]               ), 
            .o_MU_buf_full          ( MU_buf_full[j]            ), 
            .o_MU_buf_empty         ( MU_buf_empty[j]           ),
            .o_debug_vel            ( MU_debug_vel[j]           ),
            .o_debug_vel_valid      ( MU_debug_vel_valid[j]     ),
            .o_debug_particle_num   ( MU_debug_particle_num[j]  ),
            .o_debug_migration      ( MU_debug_migration[j]     )
            
        );
	end
endgenerate

logic [31:0]            PE_cntr;
logic [NUM_CELLS-1:0]   d1_MU_frc_valid;
logic [NUM_CELLS-1:0]   d1_MU_offset_valid;
logic [NUM_CELLS-1:0]   d1_MU_vel_valid;

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        MU_started <= 1'b0;
        MU_frc_once_valid <= 1'b0;
        MU_offset_once_valid <= 1'b0;
        MU_vel_once_valid <= 1'b0;
        MU_once_writing <= 1'b0;
        MU_once_reading <= 1'b0;
        chk_nb_frc <= 1'b0;
        chk_home_frc <= 1'b0;
        chk_MU_vel_out <= 1'b0;
        chk_MU_vel_produced <= 1'b0;
        chk_MU_offset_in <= 1'b0;
        MU_rd_cnt <= 0;
        operation_cycle_cnt <= 0;
        remote_pos_buf_once_full <= 0;
        remote_frc_buf_once_full <= 0;
        pos_pkt_to_remote_valid_cntr <= 0;
        frc_pkt_to_remote_valid_cntr <= 0;
        remote_pos_tvalid_cntr <= 0;
        remote_frc_tvalid_cntr <= 0;
        all_disp_once_back_pressure <= 0;
        all_filter_once_back_pressure <= 0;
        all_frc_output_ring_buf_once_full <= 0;
        home_buf_once_almost_full <= 0;
        nb_buf_once_almost_full <= 0;
        pos_ring_cycle_cnt <= 0;
        frc_ring_cycle_cnt <= 0;
        filter_cycle_cnt <= 0;
        PE_cycle_cnt <= 0;
        MU_cycle_cnt <= 0;
        PE_cntr <= 0;
        d1_MU_frc_valid <= 0;
        d1_MU_offset_valid <= 0;
        d1_MU_vel_valid <= 0;
        last_pos_sent_cntr <= 0;
        last_frc_sent_cntr <= 0;
        MU_start_cntr <= 0;
        pos_dest_cntr_0 <= 0;
        pos_dest_cntr_1 <= 0;
        pos_dest_cntr_2 <= 0;
        pos_dest_cntr_3 <= 0;
        pos_dest_cntr_4 <= 0;
        pos_dest_cntr_5 <= 0;
        pos_dest_cntr_6 <= 0;
        pos_dest_cntr_7 <= 0;
        frc_dest_cntr_0 <= 0;
        frc_dest_cntr_1 <= 0;
        frc_dest_cntr_2 <= 0;
        frc_dest_cntr_3 <= 0;
        frc_dest_cntr_4 <= 0;
        frc_dest_cntr_5 <= 0;
        frc_dest_cntr_6 <= 0;
        frc_dest_cntr_7 <= 0;
        dest_x_cntr <= 0;
        dest_z_cntr <= 0;
        dest_xz_cntr <= 0;
        remote_pos_buf_ack_cntr <= 0;
        remote_frc_buf_ack_cntr <= 0;
        last_pos_over_received <= 1'b0;
        single_iter_cycle_cnt <= 0;
        all_PE_nb_buf_once_full <= 1'b0;
    end
    else begin
        d1_MU_frc_valid <= MU_frc_valid;
        d1_MU_offset_valid <= MU_offset_valid;
        d1_MU_vel_valid <= MU_vel_valid;
        if (MU_start) begin
            MU_started <= 1'b1;
        end
        if ( | d1_MU_frc_valid) begin
            MU_frc_once_valid <= 1'b1;
        end
        if ( | d1_MU_offset_valid) begin
            MU_offset_once_valid <= 1'b1;
        end
        if ( | d1_MU_vel_valid) begin
            MU_vel_once_valid <= 1'b1;
        end
        if (MU_reading) begin
            MU_once_reading <= 1'b1;
        end
        if (MU_writing) begin
            MU_once_writing <= 1'b1;
        end
        if ((MU_nb_frc[0][FLOAT_WIDTH-2:0] != 0) & MU_frc_valid[0]) begin
            chk_nb_frc <= 1'b1;
        end 
        if ((MU_home_frc[0][FLOAT_WIDTH-2:0] != 0) & MU_frc_valid[0]) begin
            chk_home_frc <= 1'b1;
        end 
        if ((MU_vel_return[0][FLOAT_WIDTH-2:0] != 0) & MU_return_valid[0]) begin
            chk_MU_vel_out <= 1'b1;
        end 
        if ((MU_debug_vel[0][FLOAT_WIDTH-2:0] != 0) & MU_debug_vel_valid[0]) begin
            chk_MU_vel_produced <= 1'b1;
        end 
        if ((MU_offset[0][OFFSET_WIDTH-1:0] != 0) & MU_data_valid[0]) begin
            chk_MU_offset_in <= 1'b1;
        end 
        if (MU_rd_en[0]) begin
            MU_rd_cnt <= MU_rd_cnt + 1'b1;
        end
        if (MD_state_w > 2) begin
            if (~iter_target_reached & debug_state != {(NUM_CELLS){4'h8}}) begin
                operation_cycle_cnt <= operation_cycle_cnt + 1'b1;
            end
        end
        if (remote_pos_buf_full) begin
            remote_pos_buf_once_full <= 1'b1;
        end
        if (remote_frc_buf_full) begin
            remote_frc_buf_once_full <= 1'b1;
        end
        if (axis_pos_pkt_to_remote[AXIS_PKT_STRUCT_WIDTH-1]) begin
            pos_pkt_to_remote_valid_cntr <= pos_pkt_to_remote_valid_cntr + 1'b1;
        end
        if (axis_frc_pkt_to_remote[AXIS_PKT_STRUCT_WIDTH-1]) begin
            frc_pkt_to_remote_valid_cntr <= frc_pkt_to_remote_valid_cntr + 1'b1;
        end
        if (remote_pos_tvalid) begin
            remote_pos_tvalid_cntr <= remote_pos_tvalid_cntr + 1'b1;
        end
        if (remote_frc_tvalid) begin
            remote_frc_tvalid_cntr <= remote_frc_tvalid_cntr + 1'b1;
        end
        if (all_disp_back_pressure) begin
            all_disp_once_back_pressure <= 1'b1;
        end
        if (all_filter_back_pressure) begin
            all_filter_once_back_pressure <= 1'b1;
        end
        if (all_frc_output_ring_buf_full) begin
            all_frc_output_ring_buf_once_full <= 1'b1;
        end
        if (home_buf_almost_full) begin
            home_buf_once_almost_full <= 1'b1;
        end
        if (nb_buf_almost_full) begin
            nb_buf_once_almost_full <= 1'b1;
        end
        if (~all_pos_ring_nodes_empty) begin
            pos_ring_cycle_cnt <= pos_ring_cycle_cnt + 1'b1;
        end
        if (~all_frc_output_ring_done) begin
            frc_ring_cycle_cnt <= frc_ring_cycle_cnt + 1'b1;
        end
        if (MU_working) begin
            MU_cycle_cnt <= MU_cycle_cnt + 1'b1;
        end
        last_pos_sent_cntr <= last_pos_sent_cntr + last_pos_sent;
        last_frc_sent_cntr <= last_frc_sent_cntr + last_frc_sent;
        if (MU_start) begin
            MU_start_cntr <= MU_start_cntr + 1'b1;
        end
        if (k2n_frc_tdest == 0 && k2n_frc_tvalid && k2n_frc_tdata[96]) begin
            frc_dest_cntr_0 <= frc_dest_cntr_0 + 1'b1;
        end
        if (k2n_frc_tdest == 1 && k2n_frc_tvalid && k2n_frc_tdata[96]) begin
            frc_dest_cntr_1 <= frc_dest_cntr_1 + 1'b1;
        end
        if (k2n_frc_tdest == 2 && k2n_frc_tvalid && k2n_frc_tdata[96]) begin
            frc_dest_cntr_2 <= frc_dest_cntr_2 + 1'b1;
        end
        if (k2n_frc_tdest == 3 && k2n_frc_tvalid && k2n_frc_tdata[96]) begin
            frc_dest_cntr_3 <= frc_dest_cntr_3 + 1'b1;
        end
        if (k2n_frc_tdest == 4 && k2n_frc_tvalid && k2n_frc_tdata[96]) begin
            frc_dest_cntr_4 <= frc_dest_cntr_4 + 1'b1;
        end
        if (k2n_frc_tdest == 5 && k2n_frc_tvalid && k2n_frc_tdata[96]) begin
            frc_dest_cntr_5 <= frc_dest_cntr_5 + 1'b1;
        end
        if (k2n_frc_tdest == 6 && k2n_frc_tvalid && k2n_frc_tdata[96]) begin
            frc_dest_cntr_6 <= frc_dest_cntr_6 + 1'b1;
        end
        if (k2n_frc_tdest == 7 && k2n_frc_tvalid && k2n_frc_tdata[96]) begin
            frc_dest_cntr_7 <= frc_dest_cntr_7 + 1'b1;
        end
        if (k2n_pos_tdest == 0 && k2n_pos_tvalid && k2n_pos_tdata[96]) begin
            pos_dest_cntr_0 <= pos_dest_cntr_0 + 1'b1;
        end
        if (k2n_pos_tdest == 1 && k2n_pos_tvalid && k2n_pos_tdata[96]) begin
            pos_dest_cntr_1 <= pos_dest_cntr_1 + 1'b1;
        end
        if (k2n_pos_tdest == 2 && k2n_pos_tvalid && k2n_pos_tdata[96]) begin
            pos_dest_cntr_2 <= pos_dest_cntr_2 + 1'b1;
        end
        if (k2n_pos_tdest == 3 && k2n_pos_tvalid && k2n_pos_tdata[96]) begin
            pos_dest_cntr_3 <= pos_dest_cntr_3 + 1'b1;
        end
        if (k2n_pos_tdest == 4 && k2n_pos_tvalid && k2n_pos_tdata[96]) begin
            pos_dest_cntr_4 <= pos_dest_cntr_4 + 1'b1;
        end
        if (k2n_pos_tdest == 5 && k2n_pos_tvalid && k2n_pos_tdata[96]) begin
            pos_dest_cntr_5 <= pos_dest_cntr_5 + 1'b1;
        end
        if (k2n_pos_tdest == 6 && k2n_pos_tvalid && k2n_pos_tdata[96]) begin
            pos_dest_cntr_6 <= pos_dest_cntr_6 + 1'b1;
        end
        if (k2n_pos_tdest == 7 && k2n_pos_tvalid && k2n_pos_tdata[96]) begin
            pos_dest_cntr_7 <= pos_dest_cntr_7 + 1'b1;
        end
//        if (lifetime_to_remote[4*NB_CELL_COUNT_WIDTH-1:3*NB_CELL_COUNT_WIDTH] > 0 && offset_pkt_to_remote_valid) begin
//            dest_x_cntr <= dest_x_cntr + 1'b1;
//        end
//        if (lifetime_to_remote[7*NB_CELL_COUNT_WIDTH-1:6*NB_CELL_COUNT_WIDTH] > 0 && offset_pkt_to_remote_valid) begin
//            dest_z_cntr <= dest_z_cntr + 1'b1;
//        end
//        if (lifetime_to_remote[3*NB_CELL_COUNT_WIDTH-1:2*NB_CELL_COUNT_WIDTH] > 0 && offset_pkt_to_remote_valid) begin
//            dest_xz_cntr <= dest_xz_cntr + 1'b1;
//        end
        if (d_remote_pos_buf_ack) begin
            remote_pos_buf_ack_cntr <= remote_pos_buf_ack_cntr + 1'b1;
        end
        if (d_remote_frc_buf_ack) begin
            remote_frc_buf_ack_cntr <= remote_frc_buf_ack_cntr + 1'b1;
        end
        if (all_PE_nb_buf_full) begin
            all_PE_nb_buf_once_full <= 1'b1;
        end
        if ((MD_state_w > 2) & ((PE_cntr != 0) |  (~all_pos_ring_nodes_empty) | (~all_frc_output_ring_done) | MU_working | (~d_all_home_buf_empty)
             | (~d_all_nb_buf_empty) | (~d_all_disp_buf_empty))) begin
            single_iter_cycle_cnt <= single_iter_cycle_cnt + 1'b1;
        end
        filter_cycle_cnt    <= filter_cntr[dump_filter_sel_w];
        if (last_pos_received > NUM_REMOTE_DEST_NODES) begin
            last_pos_over_received <= 1'b1;
        end
        if (pair_valid[0]) begin
            PE_cntr <= 1;
            PE_cycle_cnt <= PE_cycle_cnt + 1'b1;
        end
        else begin
            if (PE_cntr == 35) begin
                PE_cntr <= 0;
                PE_cycle_cnt <= PE_cycle_cnt;
            end
            else if (PE_cntr == 0) begin
                PE_cntr <= PE_cntr;
                PE_cycle_cnt <= PE_cycle_cnt;
            end
            else begin
                PE_cntr <= PE_cntr + 1'b1;
                PE_cycle_cnt <= PE_cycle_cnt + 1'b1;
            end
        end
    end
end

////////////////////////////////////////////////////////////////////////
// Dump Control
////////////////////////////////////////////////////////////////////////

//dump_pos inst_dump_pos (
//    .clk(ap_clk),
//    .rst(~ap_rst_n),
//    .dump_start(MD_state_w == 2),
//    .dump_step(init_step_w),
    
//    .dump_rd_en(dump_rd_en),
//    .dump_rd_addr(dump_rd_addr)
//);

endmodule
