`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2023 03:52:00 PM
// Design Name: 
// Module Name: remote_pos_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: this module packs offset packets as AXIS tdata, and unpacks incoming AXIS tdata as offset packets
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module remote_pos_controller(
    input                                           clk,
    input                                           rst,
    input           [STREAMING_TDEST_WIDTH-1:0]     i_dest_id, 
    input                                           i_all_pos_ring_nodes_empty,
    input                                           i_all_pos_caches_dirty,
    input           [OFFSET_PKT_STRUCT_WIDTH-1:0]   i_offset_pkt_to_remote, 					// to remote
    input           [3*GLOBAL_CELL_ID_WIDTH-1:0]    i_gcid_to_remote,
    input                                           i_offset_pkt_to_remote_valid,
    input           [NB_CELL_COUNT_WIDTH-1:0]       i_lifetime_to_remote,
    input                                           i_remote_ack_from_ring,
    
    input           [AXIS_TDATA_WIDTH-1:0]          i_remote_tdata,					        // from remote
    input                                           i_remote_tvalid,
   
    output logic    [OFFSET_PKT_STRUCT_WIDTH-1:0]   o_remote_offset_pkt, 						// from remote
    output logic    [3*GLOBAL_CELL_ID_WIDTH-1:0]    o_remote_gcid,
    output logic                                    o_remote_valid,
    output logic    [NB_CELL_COUNT_WIDTH-1:0]       o_remote_lifetime,
    output logic                                    o_last_transfer_from_remote,
    output logic                                    o_remote_input_buf_ack,
    
    output logic    [AXIS_PKT_STRUCT_WIDTH-1:0]     o_axis_pos_pkt_to_remote                  // to remote
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
                                    last_transfer_to_remote};
                                    
assign pos_tlast = 1'b1;
assign pos_tkeep = {(AXIS_TDATA_WIDTH/8){1'b1}};
assign pos_tdest = i_dest_id;

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
    end
    else begin
        if (i_offset_pkt_to_remote_valid) begin
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
            if (burst_reg[0][96]) begin         // last transfer to remote
                burst_running   <= 1'b0;
                burst_cntr      <= 2'b00;
                burst_reg       <= 0;
                pos_tdata       <= burst_reg;
                pos_tvalid      <= 1'b1;
            end
            else begin
                pos_tdata       <= 0;
                pos_tvalid      <= 1'b0;
            end
        end
    end
end

///////////////////////////////////////////////////////////////////////////////////////////////
// Unpacking from remote input
///////////////////////////////////////////////////////////////////////////////////////////////

logic [NUM_SUB_PACKETS-1:0] [SUB_PACKET_WIDTH-1:0]  serial_reg;
logic                       [1:0]                   serial_cntr;

assign o_remote_offset_pkt[OFFSET_WIDTH-1:0]                 = serial_reg[3][OFFSET_WIDTH-1:0];
assign o_remote_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH]    = serial_reg[3][32+OFFSET_WIDTH-1:32];
assign o_remote_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH]  = serial_reg[3][64+OFFSET_WIDTH-1:64];
assign o_last_transfer_from_remote                           = serial_reg[3][96+1-1:96];
assign o_remote_lifetime                       = serial_reg[3][96+1+NB_CELL_COUNT_WIDTH-1:96+1];
assign o_remote_gcid                           = serial_reg[3][96+1+NB_CELL_COUNT_WIDTH-1:96+1];
assign o_remote_offset_pkt[OFFSET_STRUCT_WIDTH +: ELEMENT_WIDTH] 
                                      = serial_reg[3][96+1+NB_CELL_COUNT_WIDTH+ELEMENT_WIDTH-1:96+1+NB_CELL_COUNT_WIDTH];
assign o_remote_offset_pkt[OFFSET_STRUCT_WIDTH +ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] 
                                      = serial_reg[3][96+1+NB_CELL_COUNT_WIDTH+ELEMENT_WIDTH+PARTICLE_ID_WIDTH-1
                                                      :96+1+NB_CELL_COUNT_WIDTH+ELEMENT_WIDTH];

assign o_remote_input_buf_ack = (i_remote_tvalid & ~o_remote_valid) | (i_remote_ack_from_ring & serial_cntr == 2'b11 & i_remote_tvalid);

always@(posedge clk) begin
    if (rst) begin
        serial_reg                  <= 0;
        serial_cntr                 <= 0;
        o_remote_valid              <= 1'b0;
        //o_remote_input_buf_ack      <= 1'b0;
    end
    else begin
        if (i_remote_tvalid & ~o_remote_valid) begin
            serial_reg              <= i_remote_tdata;
            serial_cntr             <= 0;
            o_remote_valid          <= 1'b1;
            //o_remote_input_buf_ack  <= 1'b1;
        end
        else begin
            if (i_remote_ack_from_ring) begin
                serial_cntr      <= serial_cntr + 1'b1;
                if (serial_cntr == 2'b11) begin
                    if (i_remote_tvalid) begin       // avoid bubble, reload
                        serial_reg              <= i_remote_tdata;
                        o_remote_valid          <= 1'b1;
                        //o_remote_input_buf_ack  <= 1'b1;
                    end
                    else begin                      // waiting for new remote data
                        serial_reg              <= 0;
                        o_remote_valid          <= 1'b0;
                        //o_remote_input_buf_ack  <= 1'b0;
                    end
                end
                else begin
                    serial_reg[3]           <= serial_reg[2];
                    serial_reg[2]           <= serial_reg[1];
                    serial_reg[1]           <= serial_reg[0];
                    serial_reg[0]           <= 0;
                    //o_remote_input_buf_ack  <= 1'b0;
                end
            end
        end
    end
end

endmodule
