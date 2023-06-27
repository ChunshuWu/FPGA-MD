`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2022 06:52:45 PM
// Design Name: 
// Module Name: force_pipeline
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

module force_pipeline(
    input                           clk,
    input  [AXIS_TDATA_WIDTH-1:0]   s_axis_a_tdata, 
    input                           s_axis_a_tvalid,
    input  [31:0]                   s_axis_b_tdata,
    input                           s_axis_b_tvalid,
    
    output [AXIS_TDATA_WIDTH-1:0]   m_axis_result_tdata,
    output                          m_axis_result_tvalid
);

FORCE_PIPELINE inst_FP_BD (
    .aclk(clk), 
    .s_axis_a_tdata         ( s_axis_a_tdata[31:0]      ),
    .s_axis_a_tvalid        ( s_axis_a_tvalid           ),
    .s_axis_b_tdata         ( s_axis_b_tdata            ),
    .s_axis_b_tvalid        ( s_axis_b_tvalid           ),
    
    .m_axis_result_tdata    ( m_axis_result_tdata[31:0] ),
    .m_axis_result_tvalid   ( m_axis_result_tvalid      )
);

logic [479:0] d1_s_axis_a_tdata;
logic [479:0] d2_s_axis_a_tdata;
logic [479:0] d3_s_axis_a_tdata;

always@(posedge clk) begin
    d1_s_axis_a_tdata <= s_axis_a_tdata[511:32];
    d2_s_axis_a_tdata <= d1_s_axis_a_tdata;
    d3_s_axis_a_tdata <= d2_s_axis_a_tdata;
end

assign m_axis_result_tdata[511:32] = d3_s_axis_a_tdata;

endmodule
