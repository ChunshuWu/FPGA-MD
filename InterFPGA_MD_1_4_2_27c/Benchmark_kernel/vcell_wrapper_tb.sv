`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2022 03:51:49 PM
// Design Name: 
// Module Name: vcell_wrapper_tb
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


module vcell_wrapper_tb;
    logic clk;
    logic [FLOAT_STRUCT_WIDTH-1:0] vel_in;
    logic [PARTICLE_ID_WIDTH-1:0] wr_addr;
    logic wr_en;
    logic [PARTICLE_ID_WIDTH-1:0] rd_addr;
    
    logic [FLOAT_STRUCT_WIDTH-1:0] vel_out;


always #1 clk <= ~clk;
initial begin
	clk <= 1'b0;
	vel_in <= 0;
	wr_addr <= 0;
	wr_en <= 0;
	rd_addr <= 0;
	
	#10
	vel_in <= 1;
	wr_addr <= 1;
	wr_en <= 1;
	
	#2
	wr_en <= 0;
	
	#10
	rd_addr <= 1;
end
    
vcell_wrapper vcell_wrapper(
    .clk(clk), 
    .vel_in_0(vel_in),
    .wr_addr_0(wr_addr),
    .wr_en_0(wr_en),
    .rd_addr_0(rd_addr),
    .vel_out_0(vel_out)
);
endmodule
