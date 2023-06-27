//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2022 04:51:00 PM
// Design Name: 
// Module Name: planar_filter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 1 cycle delay
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////
// Input valid: If broadcast is not done, and home cell pairs haven't been evaluted twice
///////////////////////////////////////////////////////////////////////////////////////////

module planar_filter
//#(
//	// 1|3|7
//	parameter CELL_ID_WIDTH = 2, 
//	parameter BODY_BITS = 8,			// Including 1 bit integer part
//	parameter SQRT_2 = 9'b101101011,	// 101101010, round up to 101101011, 16B
//	parameter SQRT_3 = 9'b110111100	// 110111011, round up to 110111100, 1BC
//)
(
	input clk, 
	input rst, 
	input i_input_valid, 
	input [CELL_ID_WIDTH+BODY_BITS-1:0] i_home_x, i_home_y, i_home_z, i_nb_x, i_nb_y, i_nb_z, 
	output o_pass
);

localparam SQRT_2 = 9'b101101011;	// 101101010, round up to 101101011, 16B
localparam SQRT_3 = 9'b110111100;	// 110111011, round up to 110111100, 1BC

wire [CELL_ID_WIDTH+BODY_BITS-1:0] dx_full, dy_full, dz_full;
wire [CELL_ID_WIDTH+BODY_BITS-1:0] dx, dy, dz;      // Positive signals

assign dx_full = i_home_x - i_nb_x;
assign dy_full = i_home_y - i_nb_y;
assign dz_full = i_home_z - i_nb_z;

assign dx = dx_full[CELL_ID_WIDTH+BODY_BITS-1] ? -dx_full : dx_full;
assign dy = dy_full[CELL_ID_WIDTH+BODY_BITS-1] ? -dy_full : dy_full;
assign dz = dz_full[CELL_ID_WIDTH+BODY_BITS-1] ? -dz_full : dz_full;

wire [BODY_BITS:0] dx_plus_dy;
wire [BODY_BITS:0] dy_plus_dz;
wire [BODY_BITS:0] dz_plus_dx;
wire [BODY_BITS+1:0] dx_plus_dy_plus_dz;

assign dx_plus_dy = dx[BODY_BITS-1:0] + dy[BODY_BITS-1:0];
assign dy_plus_dz = dy[BODY_BITS-1:0] + dz[BODY_BITS-1:0];
assign dz_plus_dx = dz[BODY_BITS-1:0] + dx[BODY_BITS-1:0];
assign dx_plus_dy_plus_dz = dx[BODY_BITS-1:0] + dy[BODY_BITS-1:0] + dz[BODY_BITS-1:0];

logic pass_1d;
logic pass_2d;
logic pass_3d;
logic output_valid;

always@(posedge clk)
    begin
    if (rst)
        begin
        pass_1d <= 1'b0;
        pass_2d <= 1'b0;
        pass_3d <= 1'b0;
        output_valid <= 1'b0;
        end
    else
        begin
        pass_1d <=  dx[CELL_ID_WIDTH+BODY_BITS-1:BODY_BITS] == 0 &&
                    dy[CELL_ID_WIDTH+BODY_BITS-1:BODY_BITS] == 0 &&
                    dz[CELL_ID_WIDTH+BODY_BITS-1:BODY_BITS] == 0;
        pass_2d <=  dx_plus_dy < SQRT_2 &&
                    dy_plus_dz < SQRT_2 &&
                    dz_plus_dx < SQRT_2;
        pass_3d <=  dx_plus_dy_plus_dz < SQRT_3;
        output_valid <= i_input_valid;
        end
    end
    
assign o_pass = output_valid && pass_1d && pass_2d && pass_3d; 

endmodule