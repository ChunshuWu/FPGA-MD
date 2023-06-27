//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2022 12:34:28 AM
// Design Name: 
// Module Name: compute_nb_cid
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

module compute_nb_cid_1d
#(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_ID[NUM_CELL_FOLDS] = '{3'h0}, 
    parameter GDIM = 0
)
(
	input [GLOBAL_CELL_ID_WIDTH-1:0] i_source_gcid_1d, 
//	input [CELL_FOLD_ID_WIDTH-1:0] i_fold_id, 
	
	output logic [CELL_ID_WIDTH-1:0] o_nb_cid
);

logic [GLOBAL_CELL_ID_WIDTH-1:0] home_gcid_1d;     
//assign home_gcid_1d = GCELL_ID[i_fold_id];      // strange things happen if use the parameter directly
assign home_gcid_1d = GCELL_ID[0];

always@(*) begin
	if (i_source_gcid_1d == home_gcid_1d) begin
		o_nb_cid = 2'b10;
	end
	else if (i_source_gcid_1d > home_gcid_1d) begin
		if (home_gcid_1d == 0 && i_source_gcid_1d == GDIM-1) begin
			o_nb_cid = 2'b01;
	   end
		else begin
			o_nb_cid = 2'b11;
		end
	end
	else begin
		if (home_gcid_1d == GDIM-1 && i_source_gcid_1d == 0) begin
			o_nb_cid = 2'b11;
		end
		else begin
			o_nb_cid = 2'b01;
		end
	end
end
	
endmodule