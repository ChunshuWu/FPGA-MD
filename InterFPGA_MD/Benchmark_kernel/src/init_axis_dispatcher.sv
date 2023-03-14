`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2022 02:47:51 AM
// Design Name: 
// Module Name: init_axis_dispatcher
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

module init_axis_dispatcher(
    input                                             clk, 
    input                                             rst, 
    input                                             i_init_start,
    input                                             i_dump_start,
    input        [15:0]                               i_init_ID,
    
    input                                             i_s_axis_h2k_tvalid,
    input        [AXIS_TDATA_WIDTH-1:0]               i_s_axis_h2k_tdata,
    input        [AXIS_TDATA_WIDTH/8-1:0]             i_s_axis_h2k_tkeep,
    input                                             i_s_axis_h2k_tlast,
    input        [TDEST_WIDTH-1:0]                    i_s_axis_h2k_tdest,
    
    output logic                                      o_m_axis_k2pc_tvalid,
    output logic [AXIS_TDATA_WIDTH-1:0]               o_m_axis_k2pc_tdata,
    
    output logic                                      o_m_axis_k2h_tvalid,
    output logic [AXIS_TDATA_WIDTH-1:0]               o_m_axis_k2h_tdata,
    
    input                                             i_s_axis_n2k_pos_tvalid,
    input        [AXIS_TDATA_WIDTH-1:0]               i_s_axis_n2k_pos_tdata,
    input        [AXIS_TDATA_WIDTH/8-1:0]             i_s_axis_n2k_pos_tkeep,
    input                                             i_s_axis_n2k_pos_tlast,
    input        [TDEST_WIDTH-1:0]                    i_s_axis_n2k_pos_tdest,
    
    input                                             i_s_axis_n2k_frc_tvalid,
    input        [AXIS_TDATA_WIDTH-1:0]               i_s_axis_n2k_frc_tdata,
    input        [AXIS_TDATA_WIDTH/8-1:0]             i_s_axis_n2k_frc_tkeep,
    input                                             i_s_axis_n2k_frc_tlast,
    input        [TDEST_WIDTH-1:0]                    i_s_axis_n2k_frc_tdest,
    
    output logic                                      o_m_axis_k2n_pos_tvalid,
    output logic [AXIS_TDATA_WIDTH-1:0]               o_m_axis_k2n_pos_tdata,
    output logic [AXIS_TDATA_WIDTH/8-1:0]             o_m_axis_k2n_pos_tkeep,
    output logic                                      o_m_axis_k2n_pos_tlast,
    output logic [TDEST_WIDTH-1:0]                    o_m_axis_k2n_pos_tdest
);

always@(posedge clk) begin
    if (rst) begin
        o_m_axis_k2h_tvalid     <= 0;
        o_m_axis_k2h_tdata      <= 0;
        o_m_axis_k2pc_tvalid    <= 0;
        o_m_axis_k2pc_tdata     <= 0;
        o_m_axis_k2n_pos_tvalid <= 0;
        o_m_axis_k2n_pos_tdata  <= 0;
        o_m_axis_k2n_pos_tkeep  <= 0;
        o_m_axis_k2n_pos_tlast  <= 0;
        o_m_axis_k2n_pos_tdest  <= 0;
    end
    else begin
        if (i_init_start) begin
            o_m_axis_k2h_tvalid    <= 0;
            o_m_axis_k2h_tdata     <= 0;
            if (i_init_ID == i_s_axis_h2k_tdest) begin    // Match, write to pos caches
                o_m_axis_k2pc_tvalid    <= i_s_axis_h2k_tvalid;
                o_m_axis_k2pc_tdata     <= i_s_axis_h2k_tdata;
                o_m_axis_k2n_pos_tvalid <= 0;
                o_m_axis_k2n_pos_tdata  <= 0;
                o_m_axis_k2n_pos_tkeep  <= 0;
                o_m_axis_k2n_pos_tlast  <= 0;
                o_m_axis_k2n_pos_tdest  <= 0;
            end
            else begin                                  // Do not match, forward and accept from network
                o_m_axis_k2pc_tvalid    <= i_s_axis_n2k_pos_tvalid;
                o_m_axis_k2pc_tdata     <= i_s_axis_n2k_pos_tdata;
                o_m_axis_k2n_pos_tvalid <= i_s_axis_h2k_tvalid;
                o_m_axis_k2n_pos_tdata  <= i_s_axis_h2k_tdata;
                o_m_axis_k2n_pos_tkeep  <= i_s_axis_h2k_tkeep;
                o_m_axis_k2n_pos_tlast  <= i_s_axis_h2k_tlast;
                o_m_axis_k2n_pos_tdest  <= i_s_axis_h2k_tdest;
            end      
        end
        else begin                  // After pos init, computing phase. Send incoming data to host
            if (i_dump_start) begin
                o_m_axis_k2h_tvalid    <= i_s_axis_n2k_frc_tvalid;
                o_m_axis_k2h_tdata     <= i_s_axis_n2k_frc_tdata;
            end
            else begin
                o_m_axis_k2h_tvalid    <= 0;
                o_m_axis_k2h_tdata     <= 0;
            end
            o_m_axis_k2pc_tvalid    <= 0;
            o_m_axis_k2pc_tdata     <= 0;
            o_m_axis_k2n_pos_tvalid <= 0;
            o_m_axis_k2n_pos_tdata  <= 0;
            o_m_axis_k2n_pos_tkeep  <= 0;
            o_m_axis_k2n_pos_tlast  <= 0;
            o_m_axis_k2n_pos_tdest  <= 0;
        end
    end
end

endmodule

