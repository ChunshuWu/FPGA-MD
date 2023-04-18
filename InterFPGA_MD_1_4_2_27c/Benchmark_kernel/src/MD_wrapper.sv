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
    input  wire  [STREAMING_TDEST_WIDTH-1:0]    init_id_w,
    input  wire        [INIT_STEP_WIDTH-1:0]    dump_bank_sel_w,
    input  wire                                 network_pos_free,
    input  wire                                 network_frc_free,
    
    output reg                                  fifo_pos_full = 0,
    output reg                                  fifo_frc_full = 0,
//    output wire      [PARTICLE_ID_WIDTH-1:0]    num_particles,
    output wire                                 all_dirty,
    output wire                                 all_disp_back_pressure,
    output wire                                 home_buf_almost_full,
    output wire                                 nb_buf_almost_full,
    output wire                                 all_frc_output_ring_buf_empty,
    output wire                                 all_frc_output_ring_done,
    output wire                                 all_home_buf_empty,
    output wire                                 all_nb_buf_empty,
    output wire                                 all_disp_buf_empty,
    output wire                                 MU_buf_almost_full,
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
    output wire  [31:0]                         num_particles_8, 
    output wire  [31:0]                         num_particles_9, 
    output wire  [31:0]                         num_particles_10, 
    output wire  [31:0]                         num_particles_11, 
    output wire  [31:0]                         num_particles_12, 
    output wire  [31:0]                         num_particles_13, 
    output wire  [31:0]                         num_particles_14, 
    output wire  [31:0]                         num_particles_15,
    output wire  [31:0]                         num_particles_16, 
    output wire  [31:0]                         num_particles_17, 
    output wire  [31:0]                         num_particles_18, 
    output wire  [31:0]                         num_particles_19, 
    output wire  [31:0]                         num_particles_20, 
    output wire  [31:0]                         num_particles_21, 
    output wire  [31:0]                         num_particles_22, 
    output wire  [31:0]                         num_particles_23,
    output wire  [31:0]                         num_particles_24, 
    output wire  [31:0]                         num_particles_25, 
    output wire  [31:0]                         num_particles_26,
    output logic [INIT_STEP_WIDTH-1:0]          init_step,
    output logic [PARTICLE_ID_WIDTH-1:0]        init_wr_addr,
    output logic [31:0]                         first_migration_iter,
    output logic [31:0]                         first_anomaly_nop_iter
);

logic                                 k2pc_tvalid;
logic       [AXIS_TDATA_WIDTH-1:0]    k2pc_tdata;

logic                                 k2h_tvalid;
logic       [AXIS_TDATA_WIDTH-1:0]    k2h_tdata;

// Ready to upstream, tbc
assign S_AXIS_n2k_pos_tready = 1'b1;
assign S_AXIS_n2k_frc_tready = M_AXIS_k2h_tready;
//assign S_AXIS_h2k_tready = k2n_pos_tready;        May lead to pkt duplication
assign S_AXIS_h2k_tready = 1'b1;        // Always ready, bp is handled by network output buffers. 

logic                                 fifo_pos_full_w;
logic                                 fifo_frc_full_w;

// Used to check if the buffer is once full
always@(posedge ap_clk) begin
    if (fifo_pos_full_w) begin
        fifo_pos_full <= 1;
    end
    if (fifo_frc_full_w) begin
        fifo_frc_full <= 1;
    end
end

// Set output data src based on MD state
    logic [AXIS_TDATA_WIDTH-1:0] tdata;
    logic tlast;
    logic tvalid;
    logic [STREAMING_TDEST_WIDTH-1:0] tdest;
    logic [AXIS_TDATA_WIDTH/8-1:0] tkeep;
    
logic [AXIS_PKT_STRUCT_WIDTH-1:0] axi_init_k2n_pos;
logic [AXIS_PKT_STRUCT_WIDTH-1:0] axi_run_k2n_frc;
logic [AXIS_PKT_STRUCT_WIDTH-1:0] axi_infifo_k2n_pos;
logic [AXIS_PKT_STRUCT_WIDTH-1:0] axi_infifo_k2n_frc;

always@(*) begin
    if (MD_state_w == 3) begin
        axi_infifo_k2n_pos = 0;
        axi_infifo_k2n_frc = axi_run_k2n_frc;
    end
    else begin
        axi_infifo_k2n_pos = axi_init_k2n_pos;
        axi_infifo_k2n_frc = 0;
    end
end

//////////////////////////////////////////////////////////////////
// Init data dispatching
//////////////////////////////////////////////////////////////////


init_axis_dispatcher inst_init_dispatcher
(
    .clk(ap_clk),
    .rst(~ap_rst_n),
    
    .i_init_start            ( MD_state_w == 1                      ),
    .i_dump_start            ( MD_state_w == 2 || MD_state_w == 3   ),
    .i_init_ID               ( init_id_w                            ),
    
    .o_m_axis_k2pc_tvalid    ( k2pc_tvalid                          ),     // To pos caches for init
    .o_m_axis_k2pc_tdata     ( k2pc_tdata                           ),
    
    .o_m_axis_k2h_tvalid     ( k2h_tvalid                           ),     // To host for dump
    .o_m_axis_k2h_tdata      ( k2h_tdata                            ),
    
    .i_s_axis_h2k_tvalid     ( S_AXIS_h2k_tvalid                    ),
    .i_s_axis_h2k_tdata      ( S_AXIS_h2k_tdata                     ),
    .i_s_axis_h2k_tkeep      ( S_AXIS_h2k_tkeep                     ),
    .i_s_axis_h2k_tlast      ( S_AXIS_h2k_tlast                     ),
    .i_s_axis_h2k_tdest      ( S_AXIS_h2k_tdest                     ),
    
    .o_m_axis_k2n_pos_tvalid ( axi_init_k2n_pos[AXIS_PKT_STRUCT_WIDTH-1]                                        ),
    .o_m_axis_k2n_pos_tdata  ( axi_init_k2n_pos[0 +: AXIS_TDATA_WIDTH]                                          ),
    .o_m_axis_k2n_pos_tkeep  ( axi_init_k2n_pos[AXIS_TDATA_WIDTH +: AXIS_TDATA_WIDTH/8]                         ),
    .o_m_axis_k2n_pos_tlast  ( axi_init_k2n_pos[AXIS_PKT_STRUCT_WIDTH-2]                                        ),
    .o_m_axis_k2n_pos_tdest  ( axi_init_k2n_pos[AXIS_TDATA_WIDTH+AXIS_TDATA_WIDTH/8 +: STREAMING_TDEST_WIDTH]   ),
    
    .i_s_axis_n2k_pos_tvalid ( S_AXIS_n2k_pos_tvalid                ),
    .i_s_axis_n2k_pos_tdata  ( S_AXIS_n2k_pos_tdata                 ),
    .i_s_axis_n2k_pos_tkeep  ( S_AXIS_n2k_pos_tkeep                 ),
    .i_s_axis_n2k_pos_tlast  ( S_AXIS_n2k_pos_tlast                 ),
    .i_s_axis_n2k_pos_tdest  ( S_AXIS_n2k_pos_tdest                 ),
    
    .i_s_axis_n2k_frc_tvalid ( S_AXIS_n2k_frc_tvalid                ),
    .i_s_axis_n2k_frc_tdata  ( S_AXIS_n2k_frc_tdata                 ),
    .i_s_axis_n2k_frc_tkeep  ( S_AXIS_n2k_frc_tkeep                 ),
    .i_s_axis_n2k_frc_tlast  ( S_AXIS_n2k_frc_tlast                 ),
    .i_s_axis_n2k_frc_tdest  ( S_AXIS_n2k_frc_tdest                 )
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

logic                                                                   iter_target_reached;
logic           [NUM_CELLS-1:0]                                         dirty_feedback;

logic           [NUM_CELLS-1:0]         [FLOAT_STRUCT_WIDTH-1:0]        dump_data;
logic           [NUM_CELLS-1:0]         [PARTICLE_ID_WIDTH-1:0]         dump_parid;
logic           [NUM_CELLS-1:0]                                         dump_valid;
logic           [AXIS_TDATA_WIDTH-1:0]                                  dump_data_512;
logic           [INIT_STEP_WIDTH+1:0]                                   bank_sel;

logic           [NUM_CELLS-1:0]         [OFFSET_PKT_STRUCT_WIDTH-1:0]   raw_offset_pkt;
logic           [NUM_CELLS-1:0]         [3*GLOBAL_CELL_ID_WIDTH-1:0]    cur_gcid;
logic           [NUM_CELLS-1:0]                                         raw_offset_valid;
logic           [NUM_CELLS-1:0]                                         raw_offset_dirty;
logic           [NUM_CELLS-1:0]         [PARTICLE_ID_WIDTH-1:0]         debug_num_particles;
logic           [NUM_CELLS-1:0]                                         debug_all_dirty;
logic           [NUM_CELLS-1:0]         [3:0]                           debug_state;
logic           [NUM_CELLS-1:0]                                         debug_anomaly_nop_flag;

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

assign num_particles_0  = debug_num_particles[0];
assign num_particles_1  = debug_num_particles[1];
assign num_particles_2  = debug_num_particles[2];
assign num_particles_3  = debug_num_particles[3];
assign num_particles_4  = debug_num_particles[4];
assign num_particles_5  = debug_num_particles[5];
assign num_particles_6  = debug_num_particles[6];
assign num_particles_7  = debug_num_particles[7];
assign num_particles_8  = debug_num_particles[8];
assign num_particles_9  = debug_num_particles[9];
assign num_particles_10 = debug_num_particles[10];
assign num_particles_11 = debug_num_particles[11];
assign num_particles_12 = debug_num_particles[12];
assign num_particles_13 = debug_num_particles[13];
assign num_particles_14 = debug_num_particles[14];
assign num_particles_15 = debug_num_particles[15];
assign num_particles_16 = debug_num_particles[16];
assign num_particles_17 = debug_num_particles[17];
assign num_particles_18 = debug_num_particles[18];
assign num_particles_19 = debug_num_particles[19];
assign num_particles_20 = debug_num_particles[20];
assign num_particles_21 = debug_num_particles[21];
assign num_particles_22 = debug_num_particles[22];
assign num_particles_23 = debug_num_particles[23];
assign num_particles_24 = debug_num_particles[24];
assign num_particles_25 = debug_num_particles[25];
assign num_particles_26 = debug_num_particles[26];

assign pos_state        = debug_state[0];
assign all_dirty        = &debug_all_dirty;


genvar j;
generate
    for (j = 0; j < NUM_CELLS; j++) begin
        assign debug_anomaly_nop_flag[j]    = (debug_num_particles[j] < 8 & debug_num_particles[j] > 0) ? 1 : 0;
    end
endgenerate

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
always@(*)
    begin
    dump_data_512 = 0;
    for (i = 0; i < NUM_SUB_PACKETS; i = i + 1)
        begin
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
logic        [NUM_CELLS-1:0]                            nb_pos_pkt_valid;
logic        [NUM_CELLS-1:0]                            disp_back_pressure;

pos_input_ring inst_pos_input_ring (
    .clk                        ( ap_clk                ), 
    .rst                        ( ~ap_rst_n             ),
    .local_offset_pkt           ( raw_offset_pkt        ),
    .local_gcid                 ( cur_gcid              ),
    .local_valid                ( raw_offset_valid      ),
    .local_dirty                ( raw_offset_dirty      ),
    .dispatcher_back_pressure   ( disp_back_pressure    ),
    
    .pos_pkt_to_pe              ( nb_pos_pkt            ),
    .pos_pkt_to_pe_valid        ( nb_pos_pkt_valid      ),
    .dirty_feedback             ( dirty_feedback        )
);

////////////////////////////////////////////////////////////////////////
// Output buffers
////////////////////////////////////////////////////////////////////////

logic fifo_pos_empty;
assign axi_run_k2n_frc[AXIS_TDATA_WIDTH+AXIS_TDATA_WIDTH/8 +: STREAMING_TDEST_WIDTH]    = dest_id_w;
assign axi_run_k2n_frc[AXIS_PKT_STRUCT_WIDTH-2]                                         = 1'b1;
assign axi_run_k2n_frc[AXIS_TDATA_WIDTH +: AXIS_TDATA_WIDTH/8]                          = {(AXIS_TDATA_WIDTH/8){1'b1}};
assign axi_run_k2n_frc[0 +: AXIS_TDATA_WIDTH]                                           = dump_data_512;
assign axi_run_k2n_frc[AXIS_PKT_STRUCT_WIDTH-1]                                         = dump_valid[0+bank_sel] & iter_target_reached;


NETWORK_OUT_FIFO net_fifo_pos (
    .clk_0          ( ap_clk                                ),
    .srst_0         ( ~ap_rst_n                             ),
    .din_0          ( axi_infifo_k2n_pos[AXIS_PKT_STRUCT_WIDTH-2:0]           ),
    .wr_en_0        ( axi_infifo_k2n_pos[AXIS_PKT_STRUCT_WIDTH-1]             ),        // tbc
    .rd_en_0        ( network_pos_free & ~fifo_pos_empty    ),
    
    .prog_full_0    ( fifo_pos_full_w                       ),
    .empty_0        ( fifo_pos_empty                        ),
    .valid_0        ( k2n_pos_tvalid                        ),
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
    .rd_en_0        ( network_frc_free & ~fifo_frc_empty    ),
    
    .prog_full_0    ( fifo_frc_full_w                       ),
    .empty_0        ( fifo_frc_empty                        ),
    .valid_0        ( k2n_frc_tvalid                        ),
    .dout_0         ( {k2n_frc_tlast, 
                       k2n_frc_tdest, 
                       k2n_frc_tkeep, 
                       k2n_frc_tdata}                       )
);

////////////////////////////////////////////////////////////////////////
// PE
////////////////////////////////////////////////////////////////////////

assign all_disp_back_pressure = | disp_back_pressure;

logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]   home_frc;
logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0]    home_frc_parid;
logic [NUM_CELLS-1:0]                           home_frc_valid;
logic [NUM_CELLS-1:0][FRC_PKT_STRUCT_WIDTH-1:0] nb_frc_to_ring;
logic [NUM_CELLS-1:0]                           nb_frc_to_ring_valid;
logic [NUM_CELLS-1:0]                           disp_buf_empty;

assign all_disp_buf_empty     = & disp_buf_empty;

generate
	for (j = 0; j < NUM_CELLS; j++) begin: PEs
		PE inst_PE (
			.clk                 ( ap_clk                    ), 
			.rst                 ( ~ap_rst_n                 ), 
			
			.home_offset         ( raw_offset_pkt[j]         ), 
			.home_offset_valid   ( raw_offset_valid[j]       ), 
			.nb_pos              ( nb_pos_pkt[j]             ), 
			.nb_pos_valid        ( nb_pos_pkt_valid[j]       ), 
			
			.home_frc            ( home_frc[j]               ), 
			.home_frc_parid      ( home_frc_parid[j]         ),
			.home_frc_valid      ( home_frc_valid[j]         ),
			.nb_frc_acc          ( nb_frc_to_ring[j]         ), 
			.nb_frc_acc_valid    ( nb_frc_to_ring_valid[j]   ),
			.disp_back_pressure  ( disp_back_pressure[j]     ),
			.disp_buf_empty      ( disp_buf_empty[j]         )
		);
	end
endgenerate

////////////////////////////////////////////////////////////////////////
// Force output ring
////////////////////////////////////////////////////////////////////////
	
logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]   nb_frc;
logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0]    nb_frc_parid;
logic [NUM_CELLS-1:0]                           nb_frc_valid;
logic [NUM_CELLS-1:0]                           frc_output_ring_buf_empty;
logic [NUM_CELLS-1:0]                           frc_output_ring_running;

assign all_frc_output_ring_buf_empty = & frc_output_ring_buf_empty;
assign all_frc_output_ring_done = & (~frc_output_ring_running);

force_output_ring inst_frc_output_ring (
    .clk                                ( ap_clk                    ),
    .rst                                ( ~ap_rst_n                 ),
    .i_nb_force                         ( nb_frc_to_ring            ),
    .i_nb_force_valid                   ( nb_frc_to_ring_valid      ),
    
    .o_nb_force_to_force_cache          ( nb_frc                    ),
    .o_nb_parid_to_force_cache          ( nb_frc_parid              ),
    .o_nb_force_to_force_cache_valid    ( nb_frc_valid              ),
    
    .o_force_output_ring_buf_empty      ( frc_output_ring_buf_empty ),
    .o_nb_valid_ring                    ( frc_output_ring_running   )
);

////////////////////////////////////////////////////////////////////////
// Force Caches
////////////////////////////////////////////////////////////////////////
                                        
logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]   MU_home_frc;
logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]   MU_nb_frc;
logic [NUM_CELLS-1:0]                           MU_frc_valid;

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

assign MU_num_particles = MU_debug_particle_num[0];
assign MU_debug_migration_flag = |MU_debug_migration;

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
            if (frc_eval_cnt < 35) begin
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

assign frc_eval_flag        =  all_dirty & all_frc_output_ring_buf_empty & all_frc_output_ring_done 
                                            & all_home_buf_empty & all_nb_buf_empty & all_disp_buf_empty;
assign MU_start             = frc_eval_complete & ~d1_frc_eval_complete;
assign all_MU_buf_empty     = & MU_buf_empty;
assign MU_spinning          = | fwd_link_valid;
assign MU_reading           = | MU_rd_en;
assign MU_writing           = | MU_return_valid;
assign MU_busy              = ~all_MU_buf_empty | MU_spinning | MU_reading | MU_writing;
assign iter_target_reached  = iter_cnt == iter_target_w;

always@(posedge ap_clk) begin
    if (~ap_rst_n) begin
        MU_busy_cnt <= 0;
        iter_cnt    <= 0;
    end
    else begin
        if (MU_start) begin
            MU_working <= 1'b1;
            iter_cnt   <= iter_cnt + 1'b1;
        end
        else begin
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

//  Both are "almost full", just use different names
assign MU_buf_almost_full = | MU_buf_full;
                                        
generate
	for (j = 0; j < NUM_CELLS; j++) begin: MUs
        motion_update_control #(
			.GCELL_X   ( {j / (Y_DIM * Z_DIM)}   ), 
			.GCELL_Y   ( {j / Z_DIM % Y_DIM}     ), 
			.GCELL_Z   ( {j % Z_DIM}             )
        )
        inst_motion_update_units (
            .clk            ( ap_clk                ),
            .rst            ( ~ap_rst_n             ), 
            .MU_start       ( MU_start              ), 
            .i_home_frc     ( MU_home_frc[j]        ), 
            .i_nb_frc       ( MU_nb_frc[j]          ), 
            .i_offset       ( MU_offset[j]          ), 
            .i_vel          ( MU_vel[j]             ), 
            .i_element      ( MU_element[j]         ), 
            .i_data_valid   ( MU_data_valid[j]      ), 
            .i_MU_id        ( MU_id_fwd_link[(j+NUM_CELLS-1)%NUM_CELLS]   ), 
            .i_offset_fwd   ( offset_fwd_link[(j+NUM_CELLS-1)%NUM_CELLS]  ), 
            .i_vel_fwd      ( vel_fwd_link[(j+NUM_CELLS-1)%NUM_CELLS]     ), 
            .i_element_fwd  ( element_fwd_link[(j+NUM_CELLS-1)%NUM_CELLS] ), 
            .i_fwd_valid    ( fwd_link_valid[(j+NUM_CELLS-1)%NUM_CELLS]   ), 
            
            .o_offset       ( MU_offset_return[j]   ),  
            .o_vel          ( MU_vel_return[j]      ),  
            .o_element      ( MU_element_return[j]  ),  
            .o_data_valid   ( MU_return_valid[j]    ),  
            .o_MU_id        ( MU_id_fwd_link[j]     ),  
            .o_offset_fwd   ( offset_fwd_link[j]    ),  
            .o_vel_fwd      ( vel_fwd_link[j]       ), 
            .o_element_fwd  ( element_fwd_link[j]   ), 
            .o_fwd_valid    ( fwd_link_valid[j]     ), 
            .o_rd_addr      ( MU_rd_addr[j]         ), 
            .o_rd_en        ( MU_rd_en[j]           ), 
            .o_MU_buf_full  ( MU_buf_full[j]        ), 
            .o_MU_buf_empty ( MU_buf_empty[j]       ),
            .o_debug_vel    ( MU_debug_vel[j]       ),
            .o_debug_vel_valid    ( MU_debug_vel_valid[j]       ),
            .o_debug_particle_num    ( MU_debug_particle_num[j]       ),
            .o_debug_migration      ( MU_debug_migration[j]     )
            
        );
	end
endgenerate

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
        first_anomaly_nop_iter <= 0;
        first_migration_iter <= 0;
    end
    else begin
        if (MU_start) begin
            MU_started <= 1'b1;
        end
        if ( | MU_frc_valid) begin
            MU_frc_once_valid <= 1'b1;
        end
        if ( | MU_offset_valid) begin
            MU_offset_once_valid <= 1'b1;
        end
        if ( | MU_vel_valid) begin
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
        if (|debug_anomaly_nop_flag & first_anomaly_nop_iter == 0) begin
            first_anomaly_nop_iter <= iter_cnt;
        end
        if (MU_debug_migration_flag & first_migration_iter == 0) begin
            first_migration_iter  <= iter_cnt;
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
