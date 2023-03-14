`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: 
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

import MD_pkg::*;   // Change OFFSET_WIDTH to 30 before simulating, or change the test cases below. 

module force_pipeline_tb;

logic                           clk;
logic  [AXIS_TDATA_WIDTH-1:0]   s_axis_a_tdata;
logic                           s_axis_a_tvalid;
logic  [31:0]                   s_axis_b_tdata;
logic                           s_axis_b_tvalid;

logic  [AXIS_TDATA_WIDTH-1:0]   m_axis_result_tdata;
logic                           m_axis_result_tvalid;

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	
    s_axis_a_tdata  <= 0;
    s_axis_a_tvalid  <= 0;

/////////////////////////////////////////////////////
// Init test
/////////////////////////////////////////////////////
	#12
	s_axis_a_tdata <= 0;
	s_axis_a_tvalid <= 1;
	
	#2
	s_axis_a_tdata <= {{480{1'b0}}, 32'h3f800000};
	
	#2
	s_axis_a_tvalid <= 0;
	
	end
	
force_pipeline inst_fp (
    .clk(clk), 
    .s_axis_a_tdata         ( s_axis_a_tdata        ),
    .s_axis_a_tvalid        ( s_axis_a_tvalid       ),
    .s_axis_b_tdata         ( 32'h3f800000          ),
    .s_axis_b_tvalid        ( 1'b1                  ),
    
    .m_axis_result_tdata    ( m_axis_result_tdata   ),
    .m_axis_result_tvalid   ( m_axis_result_tvalid  )
);

endmodule