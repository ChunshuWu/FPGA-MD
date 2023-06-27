`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 12:35:44 PM
// Design Name: 
// Module Name: remote_frc_to_ring_controller
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

module remote_frc_to_ring_controller(
    input                                           clk,
    input                                           rst,
    input           [AXIS_TDATA_WIDTH-1:0]          i_remote_tdata,
    input                                           i_remote_tvalid,
    input                                           i_remote_ack_from_ring,
   
    output logic    [FLOAT_STRUCT_WIDTH-1:0]        o_remote_frc,
    output logic    [3*GLOBAL_CELL_ID_WIDTH-1:0]    o_remote_gcid,
    output logic    [PARTICLE_ID_WIDTH-1:0]         o_remote_frc_parid,
    output logic                                    o_remote_valid,
    output logic                                    o_last_transfer_from_remote,
    output logic                                    o_remote_input_buf_ack
);

///////////////////////////////////////////////////////////////////////////////////////////////
// Unpacking from remote input
///////////////////////////////////////////////////////////////////////////////////////////////

logic [NUM_SUB_PACKETS-1:0] [SUB_PACKET_WIDTH-1:0]  serial_reg;
logic                       [1:0]                   serial_cntr;
logic                                               batch_valid;

// {parid,gcid,last,frc_z,frc_y,frc_x}
assign o_remote_frc[FLOAT_WIDTH-1:0]                = serial_reg[3][FLOAT_WIDTH-1:0];
assign o_remote_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]    = serial_reg[3][32+FLOAT_WIDTH-1:32];
assign o_remote_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]  = serial_reg[3][64+FLOAT_WIDTH-1:64];
assign o_last_transfer_from_remote                  = serial_reg[3][96];
assign o_remote_gcid                                = serial_reg[3][96+1+3*GLOBAL_CELL_ID_WIDTH-1:96+1];
assign o_remote_frc_parid                           = serial_reg[3][96+1+3*GLOBAL_CELL_ID_WIDTH+PARTICLE_ID_WIDTH-1:
                                                                    96+1+3*GLOBAL_CELL_ID_WIDTH];

assign o_remote_input_buf_ack = (i_remote_tvalid & ~batch_valid) | (i_remote_ack_from_ring & serial_cntr == 2'b11 & i_remote_tvalid);

assign o_remote_valid = batch_valid;

always@(posedge clk) begin
    if (rst) begin
        serial_reg                  <= 0;
        serial_cntr                 <= 0;
        batch_valid                 <= 1'b0;
    end
    else begin
        if (i_remote_tvalid & ~batch_valid) begin
            serial_reg              <= i_remote_tdata;
            serial_cntr             <= 0;
            batch_valid             <= 1'b1;
        end
        else begin
            if (i_remote_ack_from_ring) begin
                serial_cntr      <= serial_cntr + 1'b1;
                if (serial_cntr == 2'b11) begin
                    if (i_remote_tvalid) begin       // avoid bubble, reload
                        serial_reg              <= i_remote_tdata;
                        batch_valid             <= 1'b1;
                    end
                    else begin                      // waiting for new remote data
                        serial_reg              <= 0;
                        batch_valid             <= 1'b0;
                    end
                end
                else begin
                    serial_reg[3]           <= serial_reg[2];
                    serial_reg[2]           <= serial_reg[1];
                    serial_reg[1]           <= serial_reg[0];
                    serial_reg[0]           <= 0;
                end
            end
        end
    end
end

endmodule