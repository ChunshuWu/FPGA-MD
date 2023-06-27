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

module partial_force_acc_tb;

logic                   clk;
logic                   rst;
logic                   nb_frc_valid;
force_packet_t          nb_frc;
logic [NUM_FILTERS-1:0] nb_reg_sel;
logic [NUM_FILTERS-1:0] nb_reg_release_sel;

force_packet_t          nb_frc_release;
logic                   nb_frc_release_valid;


always #1 clk <= ~clk;
initial
	begin
	clk                    <= 1'b0;
	rst                    <= 1'b1;
	nb_frc_valid           <= 0;
	nb_frc                 <= 0;
	nb_reg_sel             <= 0;
	nb_reg_release_sel     <= 0;

/////////////////////////////////////////////////////
// Init test
/////////////////////////////////////////////////////
	#12
	rst <= 1'b0;
	
	#10
	nb_frc_valid                <= 0;
	nb_frc.f.x                  <= 32'h3f800000;
	nb_frc.f.y                  <= 32'h3f800000;
	nb_frc.f.z                  <= 32'h3f800000;
	nb_reg_sel                  <= 6'b000001;
	
	#2
	nb_frc_valid                <= 1;
	
	#2
	nb_reg_sel                  <= 6'b000010;
	
	#2
	nb_reg_sel                  <= 6'b000100;
	
	#2
	nb_reg_sel                  <= 6'b001000;
	
	#2
	nb_reg_sel                  <= 6'b000001;
	nb_frc_valid                <= 0;
	
	#2
	nb_reg_sel                  <= 6'b000010;
	nb_frc_valid                <= 1;
	
	#2
	nb_reg_sel                  <= 6'b000100;
	
	#2
	nb_reg_sel                  <= 6'b001000;
	
	#2
	nb_reg_sel                  <= 6'b000001;
	nb_reg_release_sel          <= 6'b000001;
	
	#2
	nb_reg_sel                  <= 6'b000000;
	nb_reg_release_sel          <= 6'b000000;
	
	#6
	nb_reg_sel                  <= 6'b000001;
	
	#2
	nb_reg_sel                  <= 6'b000000;
	nb_reg_release_sel          <= 6'b000000;
	end

partial_force_acc inst_partial_force_acc (
    .clk(clk),
    .rst(rst),
    .nb_frc_valid(nb_frc_valid),
    .nb_frc(nb_frc),
    .nb_reg_sel(nb_reg_sel),
    .nb_reg_release_sel(nb_reg_release_sel),
    
    .nb_frc_release(nb_frc_release),
    .nb_frc_release_valid(nb_frc_release_valid)
);

endmodule