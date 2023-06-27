`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 12:35:44 PM
// Design Name: 
// Module Name: ring_frc_to_remote_controller
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

module ring_frc_to_remote_controller(
    input                                           clk,
    input                                           rst,
    input           [NODE_ID_WIDTH-1:0]             i_init_id, 
    input                                           i_remote_frc_eval_flag,
    input           [FLOAT_STRUCT_WIDTH-1:0]        i_frc_to_remote, 					// to remote
    input           [3*GLOBAL_CELL_ID_WIDTH-1:0]    i_frc_gcid_to_remote,
    input                                           i_frc_to_remote_valid,
    input           [PARTICLE_ID_WIDTH-1:0]         i_frc_parid_to_remote,
    input           [NUM_REMOTE_DEST_NODES-1:0]     i_frc_ticket,
    
    output logic    [AXIS_PKT_STRUCT_WIDTH-1:0]     o_axis_frc_pkt_to_remote,                  // to remote
    output logic                                    o_frc_burst_running,
    output logic    [NUM_REMOTE_DEST_NODES-1:0]     o_last_frc_sent
);

logic [NUM_REMOTE_DEST_NODES-1:0]                   burst_running;
logic [NUM_REMOTE_DEST_NODES-1:0]                   last_frc_sent_a;
logic [NUM_REMOTE_DEST_NODES-1:0]                   last_frc_sent_b;
logic [NUM_REMOTE_DEST_NODES-1:0]                   last_frc_sent_c;
logic [NUM_REMOTE_DEST_NODES-1:0]                   last_frc_sent_d;
logic [NUM_REMOTE_DEST_NODES-1:0]                   last_frc_sent;

logic [SUB_PACKET_WIDTH-1:0]                        packed_frc_pkt;
logic [NUM_REMOTE_DEST_NODES-1:0]                   last_transfer_to_remote;

logic [NUM_REMOTE_DEST_NODES-1:0]                           frc_tvalid;
logic                                                       frc_tlast;
logic [NUM_REMOTE_DEST_NODES-1:0][AXIS_TDATA_WIDTH-1:0]     frc_tdata;
logic [AXIS_TDATA_WIDTH/8-1:0]                              frc_tkeep;
logic [NUM_REMOTE_DEST_NODES-1:0][NODE_ID_WIDTH-1:0]        frc_tdest;

logic                                                       sel_frc_tvalid;
logic [AXIS_TDATA_WIDTH-1:0]                                sel_frc_tdata;
logic [TDEST_WIDTH-1:0]                                     sel_frc_tdest;

assign o_frc_burst_running  = | burst_running;

// Hard-coded for debugging
assign last_frc_sent_a = last_frc_sent[0]+last_frc_sent[1];
assign last_frc_sent_b = last_frc_sent[2]+last_frc_sent[3];
assign last_frc_sent_c = last_frc_sent[4]+last_frc_sent[5];
assign last_frc_sent_d = last_frc_sent[6];
assign o_last_frc_sent = last_frc_sent_a + last_frc_sent_b + last_frc_sent_c + last_frc_sent_d;

///////////////////////////////////////////////////////////////////////////////////////////////
// Packing to remote output
///////////////////////////////////////////////////////////////////////////////////////////////

assign last_transfer_to_remote[0]   = i_remote_frc_eval_flag;

// {parid,gcid,last,frc_z,frc_y,frc_x}
assign packed_frc_pkt[31:0]   = i_frc_to_remote[FLOAT_WIDTH-1:0];
assign packed_frc_pkt[63:32]  = i_frc_to_remote[2*FLOAT_WIDTH-1:FLOAT_WIDTH];
assign packed_frc_pkt[95:64]  = i_frc_to_remote[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH];
assign packed_frc_pkt[127:96] = {{(32-PARTICLE_ID_WIDTH-3*GLOBAL_CELL_ID_WIDTH){1'b0}},
                                    i_frc_parid_to_remote,
                                    i_frc_gcid_to_remote,
                                    1'b0};
                                    
assign frc_tlast = 1'b1;
assign frc_tkeep = {(AXIS_TDATA_WIDTH/8){1'b1}};

assign o_axis_frc_pkt_to_remote[AXIS_PKT_STRUCT_WIDTH-1]                                      = sel_frc_tvalid;
assign o_axis_frc_pkt_to_remote[AXIS_PKT_STRUCT_WIDTH-2]                                      = frc_tlast;
assign o_axis_frc_pkt_to_remote[0 +: AXIS_TDATA_WIDTH]                                        = sel_frc_tdata;
assign o_axis_frc_pkt_to_remote[AXIS_TDATA_WIDTH +: AXIS_TDATA_WIDTH/8]                       = frc_tkeep;
assign o_axis_frc_pkt_to_remote[AXIS_TDATA_WIDTH+AXIS_TDATA_WIDTH/8 +: STREAMING_TDEST_WIDTH] = sel_frc_tdest;

logic [NUM_REMOTE_DEST_NODES-1:0] [NODE_ID_WIDTH-1:0] dest_id;

// node id {x,y,z}
// {xyz, xy, xz, x, yz, y, z}, unlike pos. This is to match with frc_ticket

assign dest_id[0][0]    = i_init_id[0] + 1'b1;
assign dest_id[0][1]    = i_init_id[1];
assign dest_id[0][2]    = i_init_id[2];

assign dest_id[1][0]    = i_init_id[0];
assign dest_id[1][1]    = i_init_id[1] + 1'b1;
assign dest_id[1][2]    = i_init_id[2];

assign dest_id[2][0]    = i_init_id[0] + 1'b1;
assign dest_id[2][1]    = i_init_id[1] + 1'b1;
assign dest_id[2][2]    = i_init_id[2];

assign dest_id[3][0]    = i_init_id[0];
assign dest_id[3][1]    = i_init_id[1];
assign dest_id[3][2]    = i_init_id[2] + 1'b1;

assign dest_id[4][0]    = i_init_id[0] + 1'b1;
assign dest_id[4][1]    = i_init_id[1];
assign dest_id[4][2]    = i_init_id[2] + 1'b1;

assign dest_id[5][0]    = i_init_id[0];
assign dest_id[5][1]    = i_init_id[1] + 1'b1;
assign dest_id[5][2]    = i_init_id[2] + 1'b1;

assign dest_id[6][0]    = i_init_id[0] + 1'b1;
assign dest_id[6][1]    = i_init_id[1] + 1'b1;
assign dest_id[6][2]    = i_init_id[2] + 1'b1;

genvar i;

// Cascading last_transfer_to_remote, such that only up to 1 valid frc is coming out of the frc_burst_controllers
generate
    for (i = 1; i < NUM_REMOTE_DEST_NODES; i++) begin
        always@(posedge clk) begin
            if (rst) begin
                last_transfer_to_remote[i] <= 0;
            end
            else begin
                last_transfer_to_remote[i] <= last_transfer_to_remote[i-1];
            end
        end
    end
endgenerate

generate
    for (i = 0; i < NUM_REMOTE_DEST_NODES; i++) begin: frc_burst_ctrls
        frc_burst_controller frc_burst_ctrl(
            .clk                        ( clk                       ),
            .rst                        ( rst                       ),
            .i_frc_to_remote_valid      ( i_frc_to_remote_valid     ),
            .i_dest_id                  ( dest_id[i]                ),
            .i_packed_frc_pkt           ( packed_frc_pkt            ),
            .i_frc_ticket               ( i_frc_ticket[i]           ),
            .i_last_transfer_to_remote  ( last_transfer_to_remote[i]),
            
            .o_frc_tvalid               ( frc_tvalid[i]             ),
            .o_frc_tdata                ( frc_tdata[i]              ),
            .o_dest_id                  ( frc_tdest[i]              ),
            .o_debug_last_frc_sent      ( last_frc_sent[i]          ),
            .o_debug_burst_running      ( burst_running[i]          )
        );
    end
endgenerate

always@(posedge clk) begin
    if (rst) begin
        sel_frc_tvalid  <= 0;
        sel_frc_tdata   <= 0;
        sel_frc_tdest   <= 0;
    end
    else begin
        case (frc_tvalid)
            7'b0000001: begin
                sel_frc_tvalid  <= frc_tvalid[0];
                sel_frc_tdata   <= frc_tdata[0];
                sel_frc_tdest   <= {{(STREAMING_TDEST_WIDTH-NODE_ID_WIDTH){1'b0}},frc_tdest[0]};
            end
            7'b0000010: begin
                sel_frc_tvalid  <= frc_tvalid[1];
                sel_frc_tdata   <= frc_tdata[1];
                sel_frc_tdest   <= {{(STREAMING_TDEST_WIDTH-NODE_ID_WIDTH){1'b0}},frc_tdest[1]};
            end
            7'b0000100: begin
                sel_frc_tvalid  <= frc_tvalid[2];
                sel_frc_tdata   <= frc_tdata[2];
                sel_frc_tdest   <= {{(STREAMING_TDEST_WIDTH-NODE_ID_WIDTH){1'b0}},frc_tdest[2]};
            end
            7'b0001000: begin
                sel_frc_tvalid  <= frc_tvalid[3];
                sel_frc_tdata   <= frc_tdata[3];
                sel_frc_tdest   <= {{(STREAMING_TDEST_WIDTH-NODE_ID_WIDTH){1'b0}},frc_tdest[3]};
            end
            7'b0010000: begin
                sel_frc_tvalid  <= frc_tvalid[4];
                sel_frc_tdata   <= frc_tdata[4];
                sel_frc_tdest   <= {{(STREAMING_TDEST_WIDTH-NODE_ID_WIDTH){1'b0}},frc_tdest[4]};
            end
            7'b0100000: begin
                sel_frc_tvalid  <= frc_tvalid[5];
                sel_frc_tdata   <= frc_tdata[5];
                sel_frc_tdest   <= {{(STREAMING_TDEST_WIDTH-NODE_ID_WIDTH){1'b0}},frc_tdest[5]};
            end
            7'b1000000: begin
                sel_frc_tvalid  <= frc_tvalid[6];
                sel_frc_tdata   <= frc_tdata[6];
                sel_frc_tdest   <= {{(STREAMING_TDEST_WIDTH-NODE_ID_WIDTH){1'b0}},frc_tdest[6]};
            end
            default: begin
                sel_frc_tvalid  <= 1'b0;
                sel_frc_tdata   <= 0;
                sel_frc_tdest   <= 0;
            end
        endcase
    end
end

endmodule