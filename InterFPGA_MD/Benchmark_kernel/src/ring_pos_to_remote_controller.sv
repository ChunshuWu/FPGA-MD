`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2023 04:38:52 PM
// Design Name: 
// Module Name: ring_pos_to_remote_controller
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

module ring_pos_to_remote_controller(
    input                                           clk,
    input                                           rst,
    input           [NODE_ID_WIDTH-1:0]             i_dest_id, 
    input                                           i_all_pos_ring_nodes_empty,
    input                                           i_all_pos_caches_dirty,
    input           [OFFSET_PKT_STRUCT_WIDTH-1:0]   i_offset_pkt_to_remote, 					// to remote
    input           [3*GLOBAL_CELL_ID_WIDTH-1:0]    i_gcid_to_remote,
    input                                           i_offset_pkt_to_remote_valid,
    input           [NB_CELL_COUNT_WIDTH-1:0]       i_lifetime_to_remote,
    
    output logic    [AXIS_PKT_STRUCT_WIDTH-1:0]     o_axis_pos_pkt_to_remote,                  // to remote
    output logic                                    o_debug_pos_burst_running, 
    output logic                                    o_debug_last_pos_sent
);

logic [NUM_SUB_PACKETS-1:0] [SUB_PACKET_WIDTH-1:0]  burst_reg;
logic [1:0]                                         burst_cntr;
logic                                               burst_running;
logic [SUB_PACKET_WIDTH-1:0]                        packed_offset_pkt;
logic                                               last_transfer_to_remote;

logic                                               pos_tvalid;
logic                                               pos_tlast;
logic [AXIS_TDATA_WIDTH-1:0]                        pos_tdata;
logic [AXIS_TDATA_WIDTH/8-1:0]                      pos_tkeep;
logic [TDEST_WIDTH-1:0]                             pos_tdest;

assign o_debug_pos_burst_running = burst_running;

///////////////////////////////////////////////////////////////////////////////////////////////
// Packing to remote output
///////////////////////////////////////////////////////////////////////////////////////////////

assign last_transfer_to_remote   = i_all_pos_ring_nodes_empty & i_all_pos_caches_dirty;

assign packed_offset_pkt[31:0]   = {{(32-OFFSET_WIDTH){1'b0}}, i_offset_pkt_to_remote[OFFSET_WIDTH-1:0]};
assign packed_offset_pkt[63:32]  = {{(32-OFFSET_WIDTH){1'b0}}, i_offset_pkt_to_remote[2*OFFSET_WIDTH-1:OFFSET_WIDTH]};
assign packed_offset_pkt[95:64]  = {{(32-OFFSET_WIDTH){1'b0}}, i_offset_pkt_to_remote[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH]};
assign packed_offset_pkt[127:96] = {{(32-ELEMENT_WIDTH-PARTICLE_ID_WIDTH-3*GLOBAL_CELL_ID_WIDTH-NB_CELL_COUNT_WIDTH){1'b0}},
                                    i_offset_pkt_to_remote[OFFSET_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH],
                                    i_offset_pkt_to_remote[OFFSET_STRUCT_WIDTH +: ELEMENT_WIDTH],
                                    i_gcid_to_remote,
                                    i_lifetime_to_remote,
                                    1'b0};
                                    
assign pos_tlast = 1'b1;
assign pos_tkeep = {(AXIS_TDATA_WIDTH/8){1'b1}};
assign pos_tdest = {{(STREAMING_TDEST_WIDTH-NODE_ID_WIDTH){1'b0}},i_dest_id};

assign o_axis_pos_pkt_to_remote[AXIS_PKT_STRUCT_WIDTH-1]                                      = pos_tvalid;
assign o_axis_pos_pkt_to_remote[AXIS_PKT_STRUCT_WIDTH-2]                                      = pos_tlast;
assign o_axis_pos_pkt_to_remote[0 +: AXIS_TDATA_WIDTH]                                        = pos_tdata;
assign o_axis_pos_pkt_to_remote[AXIS_TDATA_WIDTH +: AXIS_TDATA_WIDTH/8]                       = pos_tkeep;
assign o_axis_pos_pkt_to_remote[AXIS_TDATA_WIDTH+AXIS_TDATA_WIDTH/8 +: STREAMING_TDEST_WIDTH] = pos_tdest;

always@(posedge clk) begin
    if (rst) begin
        burst_reg       <= 0;
        burst_cntr      <= 0;
        burst_running   <= 1'b0;
        pos_tdata       <= 0;
        pos_tvalid      <= 1'b0;
        o_debug_last_pos_sent <= 1'b0;
    end
    else begin
        if (i_offset_pkt_to_remote_valid & i_lifetime_to_remote > 0) begin      // If a cell is empty, this if never happens, burst never runs
            o_debug_last_pos_sent <= 1'b0;
            burst_running   <= 1'b1;
            burst_cntr      <= burst_cntr + 1'b1;
            if (burst_cntr == 2'b00 & burst_running) begin
                burst_reg[3]    <= 0;
                burst_reg[2]    <= 0;
                burst_reg[1]    <= 0;
                burst_reg[0]    <= packed_offset_pkt;
                pos_tdata       <= burst_reg;
                pos_tvalid      <= 1'b1;
            end
            else begin
                burst_reg[3]    <= burst_reg[2];
                burst_reg[2]    <= burst_reg[1];
                burst_reg[1]    <= burst_reg[0];
                burst_reg[0]    <= packed_offset_pkt;
                pos_tdata       <= 0;
                pos_tvalid      <= 1'b0;
            end
        end
        else begin
            if (last_transfer_to_remote & burst_running) begin         // last transfer to remote
                burst_running   <= 1'b0;
                burst_cntr      <= 2'b00;
                burst_reg       <= 0;
                pos_tdata       <= {burst_reg[3],burst_reg[2],burst_reg[1],burst_reg[0][127:97],1'b1,burst_reg[0][95:0]};
                pos_tvalid      <= 1'b1;
                o_debug_last_pos_sent <= 1'b1;  // lasts only for 1 cycle
            end
            else begin
                pos_tdata       <= 0;
                pos_tvalid      <= 1'b0;
                o_debug_last_pos_sent <= 1'b0;
            end
        end
    end
end

endmodule
