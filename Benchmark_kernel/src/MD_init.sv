`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2022 04:38:28 AM
// Design Name: 
// Module Name: MD_init
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

module MD_init(
    input clk, 
    input rst, 
    input [AXIS_TDATA_WIDTH-1:0] i_init_tdata, 
    input i_init_tvalid, 
    input [INIT_STEP_WIDTH-1:0] i_init_step, 
    
    output logic [PARTICLE_ID_WIDTH-1:0]                    o_init_wr_addr,
    output logic [NUM_CELLS-1:0][OFFSET_STRUCT_WIDTH-1:0]   o_init_data,
    output logic [NUM_CELLS-1:0][ELEMENT_WIDTH-1:0]         o_init_element,
    output logic [NUM_INIT_STEPS-1:0]                       o_init_wr_en, 
    output logic [INIT_STEP_WIDTH+1:0]                      o_init_bank_sel
);
assign o_init_wr_en = i_init_tvalid << i_init_step;
logic [INIT_STEP_WIDTH-1:0] d1_init_step;
logic init_step_change_pulse;
assign init_step_change_pulse = i_init_step != d1_init_step;
assign o_init_bank_sel = d1_init_step << 2;

always@(posedge clk)
    begin
    if (rst)
        begin
        o_init_wr_addr <= 0;
        d1_init_step <= 0;
        end
    else
        begin
        if (i_init_tvalid)
            begin
            o_init_wr_addr <= o_init_wr_addr + 1'b1;
            end
        else if (init_step_change_pulse)        // Do not change init step during valid data upload
            begin
            o_init_wr_addr <= 0;
            end
        d1_init_step <= i_init_step;
        end
    end

integer i;
always@(*)
    begin
    o_init_data = 0;
    o_init_element = 0;
    for (i = 0; i < NUM_SUB_PACKETS; i = i + 1)
        begin
            o_init_data[i+o_init_bank_sel]      = {i_init_tdata[i*SUB_PACKET_WIDTH+64 +: OFFSET_WIDTH],
                                                   i_init_tdata[i*SUB_PACKET_WIDTH+32 +: OFFSET_WIDTH],
                                                   i_init_tdata[i*SUB_PACKET_WIDTH +: OFFSET_WIDTH]};
            o_init_element[i+o_init_bank_sel]   =  i_init_tdata[i*SUB_PACKET_WIDTH+96 +: ELEMENT_WIDTH];
            //o_debug_tdata[i*SUB_PACKET_WIDTH +: 3*OFFSET_WIDTH] = debug_data[i+init_bank_sel];
        end
    end

endmodule
