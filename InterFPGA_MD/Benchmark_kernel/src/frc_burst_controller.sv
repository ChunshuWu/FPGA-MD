`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2023 07:08:59 PM
// Design Name: 
// Module Name: frc_burst_controller
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

module frc_burst_controller(
    input                               clk,
    input                               rst,
    input                               i_frc_to_remote_valid,
    input        [SUB_PACKET_WIDTH-1:0] i_packed_frc_pkt,
    input                               i_frc_ticket,
    input        [NODE_ID_WIDTH-1:0]    i_dest_id,
    input                               i_last_transfer_to_remote,
    
    output logic                        o_frc_tvalid,
    output logic [AXIS_TDATA_WIDTH-1:0] o_frc_tdata,
    output logic [NODE_ID_WIDTH-1:0]    o_dest_id,
    output logic                        o_debug_last_frc_sent,
    output logic                        o_debug_burst_running
);

logic [NUM_SUB_PACKETS-1:0] [SUB_PACKET_WIDTH-1:0]  burst_reg;
logic [1:0]                                         burst_cntr;
logic                                               burst_running;

assign o_debug_burst_running = burst_running;
assign o_dest_id = i_dest_id;

always@(posedge clk) begin
    if (rst) begin
        burst_reg       <= 0;
        burst_cntr      <= 0;
        burst_running   <= 1'b0;
        o_frc_tdata       <= 0;
        o_frc_tvalid      <= 1'b0;
        o_debug_last_frc_sent <= 1'b0;
    end
    else begin
        if (i_frc_to_remote_valid & i_frc_ticket) begin
            o_debug_last_frc_sent <= 1'b0;
            burst_running   <= 1'b1;
            burst_cntr      <= burst_cntr + 1'b1;
            if (burst_cntr == 2'b00 & burst_running) begin
                burst_reg[3]    <= 0;
                burst_reg[2]    <= 0;
                burst_reg[1]    <= 0;
                burst_reg[0]    <= i_packed_frc_pkt;
                o_frc_tdata     <= burst_reg;
                o_frc_tvalid    <= 1'b1;
            end
            else begin
                burst_reg[3]    <= burst_reg[2];
                burst_reg[2]    <= burst_reg[1];
                burst_reg[1]    <= burst_reg[0];
                burst_reg[0]    <= i_packed_frc_pkt;
                o_frc_tdata     <= 0;
                o_frc_tvalid    <= 1'b0;
            end
        end
        else begin
            if (i_last_transfer_to_remote & burst_running) begin         // last transfer to remote
                burst_running   <= 1'b0;
                burst_cntr      <= 2'b00;
                burst_reg       <= 0;
                o_frc_tdata     <= {burst_reg[3],burst_reg[2],burst_reg[1],burst_reg[0][127:97],1'b1,burst_reg[0][95:0]};
                o_frc_tvalid    <= 1'b1;
                o_debug_last_frc_sent <= 1'b1;  // lasts only for 1 cycle
            end
            else begin
                o_frc_tdata     <= 0;
                o_frc_tvalid    <= 1'b0;
                o_debug_last_frc_sent <= 1'b0;
            end
        end
    end
end
endmodule
