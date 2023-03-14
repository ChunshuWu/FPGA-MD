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

module PE_tb;

logic                           clk;
logic                           rst;
offset_packet_t                 home_offset;
logic                           home_offset_valid;
pos_packet_t                    nb_pos;
logic                           nb_pos_valid;

float_data_t                    home_frc;
logic [PARTICLE_ID_WIDTH-1:0]   home_frc_parid;
logic                           home_frc_valid;
force_packet_t                  nb_frc;
logic                           nb_frc_valid;
logic                           back_pressure;

always #1 clk <= ~clk;
always@(posedge clk) begin
    if (rst) begin
	    home_offset.parid <= 0;
	    nb_pos.parid <= 0;
        home_offset.offset.offset_x <= 23'h000000;
        home_offset.offset.offset_y <= 23'h000000;
        home_offset.offset.offset_z <= 23'h000000;
    end
    else begin
	    home_offset.element         <= 2'b01;
        if (home_offset.parid == 15) begin
            home_offset.parid <= 1;
            home_offset.offset.offset_x <= 23'h080000;
            home_offset.offset.offset_y <= 23'h080000;
            home_offset.offset.offset_z <= 23'h080000;
        end
        else begin
            home_offset.offset.offset_x <= home_offset.offset.offset_x + 23'h080000;
            home_offset.offset.offset_y <= home_offset.offset.offset_y + 23'h080000;
            home_offset.offset.offset_z <= home_offset.offset.offset_z + 23'h080000;
            home_offset.parid <= home_offset.parid + 1'b1;
        end
    end
end	
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	home_offset.parid        <= 1;
	home_offset_valid        <= 0;
	nb_pos.parid             <= 1;
	nb_pos_valid             <= 0;

/////////////////////////////////////////////////////
// Init test
/////////////////////////////////////////////////////
	#12
	rst <= 1'b0;
	
	#2
	home_offset_valid           <= 1;
	nb_pos.pos.pos_x            <= 25'h1080000;
	nb_pos.pos.pos_y            <= 25'h1080000;
	nb_pos.pos.pos_z            <= 25'h1080000;
	nb_pos.element              <= 2'b01;
	nb_pos_valid                <= 1;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1100000;
	nb_pos.pos.pos_y            <= 25'h1100000;
	nb_pos.pos.pos_z            <= 25'h1100000;
	nb_pos.parid                <= 2;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1180000;
	nb_pos.pos.pos_y            <= 25'h1180000;
	nb_pos.pos.pos_z            <= 25'h1180000;
	nb_pos.parid                <= 3;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1200000;
	nb_pos.pos.pos_y            <= 25'h1200000;
	nb_pos.pos.pos_z            <= 25'h1200000;
	nb_pos.parid                <= 4;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1280000;
	nb_pos.pos.pos_y            <= 25'h1280000;
	nb_pos.pos.pos_z            <= 25'h1280000;
	nb_pos.parid                <= 5;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1300000;
	nb_pos.pos.pos_y            <= 25'h1300000;
	nb_pos.pos.pos_z            <= 25'h1300000;
	nb_pos.parid                <= 6;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1380000;
	nb_pos.pos.pos_y            <= 25'h1380000;
	nb_pos.pos.pos_z            <= 25'h1380000;
	nb_pos.parid                <= 7;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1400000;
	nb_pos.pos.pos_y            <= 25'h1400000;
	nb_pos.pos.pos_z            <= 25'h1400000;
	nb_pos.parid                <= 8;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1480000;
	nb_pos.pos.pos_y            <= 25'h1480000;
	nb_pos.pos.pos_z            <= 25'h1480000;
	nb_pos.parid                <= 9;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1500000;
	nb_pos.pos.pos_y            <= 25'h1500000;
	nb_pos.pos.pos_z            <= 25'h1500000;
	nb_pos.parid                <= 10;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1580000;
	nb_pos.pos.pos_y            <= 25'h1580000;
	nb_pos.pos.pos_z            <= 25'h1580000;
	nb_pos.parid                <= 11;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1600000;
	nb_pos.pos.pos_y            <= 25'h1600000;
	nb_pos.pos.pos_z            <= 25'h1600000;
	nb_pos.parid                <= 12;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1680000;
	nb_pos.pos.pos_y            <= 25'h1680000;
	nb_pos.pos.pos_z            <= 25'h1680000;
	nb_pos.parid                <= 13;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1700000;
	nb_pos.pos.pos_y            <= 25'h1700000;
	nb_pos.pos.pos_z            <= 25'h1700000;
	nb_pos.parid                <= 14;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1780000;
	nb_pos.pos.pos_y            <= 25'h1780000;
	nb_pos.pos.pos_z            <= 25'h1780000;
	nb_pos.parid                <= 15;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1880000;
	nb_pos.pos.pos_y            <= 25'h1880000;
	nb_pos.pos.pos_z            <= 25'h1880000;
	nb_pos.element              <= 2'b10;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1900000;
	nb_pos.pos.pos_y            <= 25'h1900000;
	nb_pos.pos.pos_z            <= 25'h1900000;
	nb_pos.parid                <= 2;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1980000;
	nb_pos.pos.pos_y            <= 25'h1980000;
	nb_pos.pos.pos_z            <= 25'h1980000;
	nb_pos.parid                <= 3;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1a00000;
	nb_pos.pos.pos_y            <= 25'h1a00000;
	nb_pos.pos.pos_z            <= 25'h1a00000;
	nb_pos.parid                <= 4;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1a80000;
	nb_pos.pos.pos_y            <= 25'h1a80000;
	nb_pos.pos.pos_z            <= 25'h1a80000;
	nb_pos.parid                <= 5;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1b00000;
	nb_pos.pos.pos_y            <= 25'h1b00000;
	nb_pos.pos.pos_z            <= 25'h1b00000;
	nb_pos.parid                <= 6;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1b80000;
	nb_pos.pos.pos_y            <= 25'h1b80000;
	nb_pos.pos.pos_z            <= 25'h1b80000;
	nb_pos.parid                <= 7;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1c00000;
	nb_pos.pos.pos_y            <= 25'h1c00000;
	nb_pos.pos.pos_z            <= 25'h1c00000;
	nb_pos.parid                <= 8;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1c80000;
	nb_pos.pos.pos_y            <= 25'h1c80000;
	nb_pos.pos.pos_z            <= 25'h1c80000;
	nb_pos.parid                <= 9;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1d00000;
	nb_pos.pos.pos_y            <= 25'h1d00000;
	nb_pos.pos.pos_z            <= 25'h1d00000;
	nb_pos.parid                <= 10;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1d80000;
	nb_pos.pos.pos_y            <= 25'h1d80000;
	nb_pos.pos.pos_z            <= 25'h1d80000;
	nb_pos.parid                <= 11;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1e00000;
	nb_pos.pos.pos_y            <= 25'h1e00000;
	nb_pos.pos.pos_z            <= 25'h1e00000;
	nb_pos.parid                <= 12;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1e80000;
	nb_pos.pos.pos_y            <= 25'h1e80000;
	nb_pos.pos.pos_z            <= 25'h1e80000;
	nb_pos.parid                <= 13;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1f00000;
	nb_pos.pos.pos_y            <= 25'h1f00000;
	nb_pos.pos.pos_z            <= 25'h1f00000;
	nb_pos.parid                <= 14;
	
	#2
	nb_pos.pos.pos_x            <= 25'h1f80000;
	nb_pos.pos.pos_y            <= 25'h1f80000;
	nb_pos.pos.pos_z            <= 25'h1f80000;
	nb_pos.parid                <= 15;
	
	#2
	nb_pos_valid <= 0;
	
	end

PE inst_PE (
    .clk(clk),
    .rst(rst),
    .home_offset(home_offset),
    .home_offset_valid(home_offset_valid),
    .nb_pos(nb_pos),
    .nb_pos_valid(nb_pos_valid),
    
    .home_frc(home_frc),
    .home_frc_parid(home_frc_parid),
    .home_frc_valid(home_frc_valid),
    .nb_frc_acc(nb_frc),
    .nb_frc_acc_valid(nb_frc_valid),
    .disp_back_pressure(back_pressure)
);

endmodule