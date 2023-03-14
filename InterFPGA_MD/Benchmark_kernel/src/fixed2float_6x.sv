//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2022 11:43:59 PM
// Design Name: 
// Module Name: fixed2float_6x
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

module fixed2float_6x(
	input clk, 
	input rst, 
	input [POS_STRUCT_WIDTH-1:0] i_home_pos, 
	input [POS_STRUCT_WIDTH-1:0] i_nb_pos, 
	input i_pair_valid, 
	
	output [FLOAT_STRUCT_WIDTH-1:0] o_home_pos_float, 
	output [FLOAT_STRUCT_WIDTH-1:0] o_nb_pos_float, 
	output logic o_pair_valid
);

always@(posedge clk)
    begin
    if (rst)
        begin
        o_pair_valid <= 0;
        end
    else
        begin
        o_pair_valid <= i_pair_valid;
        end
    end

fixed2float fixed2float_home_x
(
	.clk(clk), 
	.rst(rst), 
	.a(i_home_pos[DATA_WIDTH-1:0]), 
	
	.q(o_home_pos_float[FLOAT_WIDTH-1:0])
);

fixed2float fixed2float_home_y
(
	.clk(clk), 
	.rst(rst), 
	.a(i_home_pos[2*DATA_WIDTH-1:DATA_WIDTH]), 
	
	.q(o_home_pos_float[2*FLOAT_WIDTH-1:FLOAT_WIDTH])
);

fixed2float fixed2float_home_z
(
	.clk(clk), 
	.rst(rst), 
	.a(i_home_pos[3*DATA_WIDTH-1:2*DATA_WIDTH]), 
	
	.q(o_home_pos_float[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH])
);

fixed2float fixed2float_nb_x
(
	.clk(clk), 
	.rst(rst), 
	.a(i_nb_pos[DATA_WIDTH-1:0]), 
	
	.q(o_nb_pos_float[FLOAT_WIDTH-1:0])
);

fixed2float fixed2float_nb_y
(
	.clk(clk), 
	.rst(rst), 
	.a(i_nb_pos[2*DATA_WIDTH-1:DATA_WIDTH]), 
	
	.q(o_nb_pos_float[2*FLOAT_WIDTH-1:FLOAT_WIDTH])
);

fixed2float fixed2float_nb_z
(
	.clk(clk), 
	.rst(rst), 
	.a(i_nb_pos[3*DATA_WIDTH-1:2*DATA_WIDTH]), 
	
	.q(o_nb_pos_float[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH])
);

endmodule
