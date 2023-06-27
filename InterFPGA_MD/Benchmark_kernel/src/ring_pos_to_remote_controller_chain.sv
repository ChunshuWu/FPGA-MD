`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2023 01:01:30 AM
// Design Name: 
// Module Name: ring_pos_to_remote_controller_chain
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


module ring_pos_to_remote_controller_chain(
    input                                           clk,
    input                                           rst,
    input           [NODE_ID_WIDTH-1:0]             i_init_id,                                  // Assume up to 8 nodes, 3 bits
    input                                           i_all_pos_ring_nodes_empty,
    input                                           i_all_dirty,
    input           [OFFSET_PKT_STRUCT_WIDTH-1:0]   i_offset_pkt_to_remote, 					// to remote
    input           [3*GLOBAL_CELL_ID_WIDTH-1:0]    i_gcid_to_remote,
    input                                           i_offset_pkt_to_remote_valid,
    input           [NUM_REMOTE_DEST_NODES*NB_CELL_COUNT_WIDTH-1:0] i_lifetime_to_remote,
    
    output logic    [AXIS_PKT_STRUCT_WIDTH-1:0]     o_axis_pos_pkt_to_remote,                  // to remote
    output logic                                    o_ring_pos_to_remote_bufs_empty,
    output logic                                    o_pos_burst_running, 
    output logic    [NUM_REMOTE_DEST_NODES-1:0]     o_last_pos_sent
);

logic [NUM_REMOTE_DEST_NODES-1:0] [NODE_ID_WIDTH-1:0] dest_id;

// node id {x,y,z}
// {z, y, yz, x, xz, xy, xyz}
assign dest_id[0][0]    = i_init_id[0] + 1'b1;
assign dest_id[0][1]    = i_init_id[1] + 1'b1;
assign dest_id[0][2]    = i_init_id[2] + 1'b1;

assign dest_id[1][0]    = i_init_id[0];
assign dest_id[1][1]    = i_init_id[1] + 1'b1;
assign dest_id[1][2]    = i_init_id[2] + 1'b1;

assign dest_id[2][0]    = i_init_id[0] + 1'b1;
assign dest_id[2][1]    = i_init_id[1];
assign dest_id[2][2]    = i_init_id[2] + 1'b1;

assign dest_id[3][0]    = i_init_id[0];
assign dest_id[3][1]    = i_init_id[1];
assign dest_id[3][2]    = i_init_id[2] + 1'b1;

assign dest_id[4][0]    = i_init_id[0] + 1'b1;
assign dest_id[4][1]    = i_init_id[1] + 1'b1;
assign dest_id[4][2]    = i_init_id[2];

assign dest_id[5][0]    = i_init_id[0];
assign dest_id[5][1]    = i_init_id[1] + 1'b1;
assign dest_id[5][2]    = i_init_id[2];

assign dest_id[6][0]    = i_init_id[0] + 1'b1;
assign dest_id[6][1]    = i_init_id[1];
assign dest_id[6][2]    = i_init_id[2];

logic [NUM_REMOTE_DEST_NODES-1:0] [NUM_REMOTE_DEST_NODES*NB_CELL_COUNT_WIDTH-1:0] lifetime_to_remote;

logic [NUM_REMOTE_DEST_NODES-1:0]                                   all_pos_ring_nodes_empty;
logic [NUM_REMOTE_DEST_NODES-1:0]                                   all_dirty;
logic [NUM_REMOTE_DEST_NODES-1:0] [OFFSET_PKT_STRUCT_WIDTH-1:0]     offset_pkt_to_remote;
logic [NUM_REMOTE_DEST_NODES-1:0] [3*GLOBAL_CELL_ID_WIDTH-1:0]      gcid_to_remote;
logic [NUM_REMOTE_DEST_NODES-1:0]                                   offset_pkt_to_remote_valid;

assign lifetime_to_remote[0]            = i_lifetime_to_remote;
assign all_pos_ring_nodes_empty[0]      = i_all_pos_ring_nodes_empty;
assign all_dirty[0]                     = i_all_dirty;
assign offset_pkt_to_remote[0]          = i_offset_pkt_to_remote;
assign gcid_to_remote[0]                = i_gcid_to_remote;
assign offset_pkt_to_remote_valid[0]    = i_offset_pkt_to_remote_valid;

genvar i;
generate
    for (i = 0; i < NUM_REMOTE_DEST_NODES-1; i++) begin: delays
        always@(posedge clk) begin
            if (rst) begin
                lifetime_to_remote[i+1]         <= 0;
                all_pos_ring_nodes_empty[i+1]   <= 0;
                all_dirty[i+1]                  <= 0;
                offset_pkt_to_remote[i+1]       <= 0;
                gcid_to_remote[i+1]             <= 0;
                offset_pkt_to_remote_valid[i+1] <= 0;
            end
            else begin
                lifetime_to_remote[i+1]         <=  lifetime_to_remote[i];
                all_pos_ring_nodes_empty[i+1]   <=  all_pos_ring_nodes_empty[i];
                all_dirty[i+1]                  <=  all_dirty[i];
                offset_pkt_to_remote[i+1]       <=  offset_pkt_to_remote[i];
                gcid_to_remote[i+1]             <=  gcid_to_remote[i];
                offset_pkt_to_remote_valid[i+1] <=  offset_pkt_to_remote_valid[i];
            end
        end
    end
endgenerate

logic [NUM_REMOTE_DEST_NODES-1:0]       ring_pos_to_remote_arb_result;
logic [NUM_REMOTE_DEST_NODES-1:0]       d1_ring_pos_to_remote_arb_result;

logic [AXIS_PKT_STRUCT_WIDTH-1:0]       axis_pos_pkt_to_remote;
logic                                   ring_pos_to_remote_bufs_empty;

always@(posedge clk) begin
    if (rst) begin
        d1_ring_pos_to_remote_arb_result    <= 0;
        o_axis_pos_pkt_to_remote            <= 0;
        o_ring_pos_to_remote_bufs_empty     <= 1'b0;
    end
    else begin
        d1_ring_pos_to_remote_arb_result    <= ring_pos_to_remote_arb_result;
        o_axis_pos_pkt_to_remote            <= axis_pos_pkt_to_remote;
        o_ring_pos_to_remote_bufs_empty     <= ring_pos_to_remote_bufs_empty;
    end
end

logic [NUM_REMOTE_DEST_NODES-1:0] pos_burst_running;
logic [NUM_REMOTE_DEST_NODES-1:0] last_frc_sent_a;
logic [NUM_REMOTE_DEST_NODES-1:0] last_frc_sent_b;
logic [NUM_REMOTE_DEST_NODES-1:0] last_frc_sent_c;
logic [NUM_REMOTE_DEST_NODES-1:0] last_frc_sent_d;
logic [NUM_REMOTE_DEST_NODES-1:0] last_pos_sent;

assign o_pos_burst_running  = | pos_burst_running;
// Hard-coded for debugging
assign last_pos_sent_a = last_pos_sent[0]+last_pos_sent[1];
assign last_pos_sent_b = last_pos_sent[2]+last_pos_sent[3];
assign last_pos_sent_c = last_pos_sent[4]+last_pos_sent[5];
assign last_pos_sent_d = last_pos_sent[6];
assign o_last_pos_sent = last_pos_sent_a + last_pos_sent_b + last_pos_sent_c + last_pos_sent_d;

logic [NUM_REMOTE_DEST_NODES-1:0] [AXIS_PKT_STRUCT_WIDTH-1:0] axis_pos_pkt_to_remote_bus;
logic [NUM_REMOTE_DEST_NODES-1:0] [AXIS_PKT_STRUCT_WIDTH-1:0] axis_pos_pkt_to_remote_bufout;
logic [NUM_REMOTE_DEST_NODES-1:0] fifo_full;
logic [NUM_REMOTE_DEST_NODES-1:0] fifo_empty;

generate
    for (i = 0; i < NUM_REMOTE_DEST_NODES; i++) begin: ring_pos_to_remote_controllers
        ring_pos_to_remote_controller ring_pos_to_remote_controller (
            .clk                            ( clk                           ), 
            .rst                            ( rst                           ),
            .i_dest_id                      ( dest_id[i]                    ),
            .i_all_pos_ring_nodes_empty     ( all_pos_ring_nodes_empty[i]   ),
            .i_all_pos_caches_dirty         ( all_dirty[i]                  ),
            .i_offset_pkt_to_remote         ( offset_pkt_to_remote[i]       ),
            .i_gcid_to_remote               ( gcid_to_remote[i]             ),
            .i_offset_pkt_to_remote_valid   ( offset_pkt_to_remote_valid[i] ),
            .i_lifetime_to_remote           ( lifetime_to_remote[i][(i+1)*NB_CELL_COUNT_WIDTH-1:i*NB_CELL_COUNT_WIDTH]   ),
            
            .o_axis_pos_pkt_to_remote       ( axis_pos_pkt_to_remote_bus[i] ),
            .o_debug_pos_burst_running      ( pos_burst_running[i]          ),
            .o_debug_last_pos_sent          ( last_pos_sent[i]              )
        );
    end
endgenerate

generate
    for (i = 0; i < NUM_REMOTE_DEST_NODES; i++) begin: ring_pos_to_remote_fifos
        POS_TO_REMOTE_BUF ring_pos_to_remote_fifo (
            .clk_0          ( clk                                                           ),
            .srst_0         ( rst                                                           ),
            .din_0          ( axis_pos_pkt_to_remote_bus[i][AXIS_PKT_STRUCT_WIDTH-2:0]      ),
            .wr_en_0        ( axis_pos_pkt_to_remote_bus[i][AXIS_PKT_STRUCT_WIDTH-1]        ),        // tbc
            .rd_en_0        ( ring_pos_to_remote_arb_result[i] & ~fifo_empty[i]             ),
            
            .prog_full_0    ( fifo_full[i]                                                  ),
            .empty_0        ( fifo_empty[i]                                                 ),
            .valid_0        ( axis_pos_pkt_to_remote_bufout[i][AXIS_PKT_STRUCT_WIDTH-1]     ),
            .dout_0         ( axis_pos_pkt_to_remote_bufout[i][AXIS_PKT_STRUCT_WIDTH-2:0]   )
        );
    end
endgenerate

ring_pos_to_remote_arbiter ring_pos_to_remote_arbiter       // Select which filter should the nb paricle enter
(
	.clk(clk), 
	.rst(rst), 
	.i_request(~fifo_empty), 
	.i_arbiter_en(1'b1), 
	
	.o_grant(ring_pos_to_remote_arb_result) 
);

assign ring_pos_to_remote_bufs_empty = & fifo_empty;

always_comb
    begin
    axis_pos_pkt_to_remote = 0;
    for (int i = 0; i < NUM_REMOTE_DEST_NODES; i++)
        begin
        if (d1_ring_pos_to_remote_arb_result == (1 << i))
            begin
            axis_pos_pkt_to_remote = axis_pos_pkt_to_remote_bufout[i];
            end
        end
    end
endmodule
