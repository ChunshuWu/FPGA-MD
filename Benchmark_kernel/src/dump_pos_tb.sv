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

module dump_pos_tb;

logic                                clk;
logic                                rst;
logic                       [1:0]    MD_state_w;
logic        [NUM_INIT_STEPS-1:0]    init_step_w;

logic        [NUM_INIT_STEPS-1:0]    dump_rd_en;
logic        [PARTICLE_ID_WIDTH-1:0] dump_rd_addr;

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	
    MD_state_w  <= 0;
    init_step_w  <= 0;

/////////////////////////////////////////////////////
// Init test
/////////////////////////////////////////////////////
	#12
	rst <= 1'b0;
	
	#10
	MD_state_w <= 1;
	
	#2
	MD_state_w  <= 2;
	
	#300
	init_step_w <= 1;
	
	end
	
dump_pos inst_dump_pos (
    .clk(clk),
    .rst(rst),
    .dump_start(MD_state_w == 2),
    .dump_step(init_step_w),
    
    .dump_rd_en(dump_rd_en),
    .dump_rd_addr(dump_rd_addr)
);

endmodule