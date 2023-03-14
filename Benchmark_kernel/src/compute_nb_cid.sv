`timescale 1ns / 1ps
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

module compute_nb_cid
#(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_X[NUM_CELL_FOLDS] = '{3'h0}, 
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Y[NUM_CELL_FOLDS] = '{3'h0}, 
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Z[NUM_CELL_FOLDS] = '{3'h0}
)
(
	input [GLOBAL_CELL_ID_WIDTH-1:0] i_source_gcid_x, 
	input [GLOBAL_CELL_ID_WIDTH-1:0] i_source_gcid_y, 
	input [GLOBAL_CELL_ID_WIDTH-1:0] i_source_gcid_z, 
	//input [CELL_FOLD_ID_WIDTH-1:0] i_fold_id, 
	
	output logic [CELL_ID_WIDTH-1:0] o_nb_cid_x, 
	output logic [CELL_ID_WIDTH-1:0] o_nb_cid_y, 
	output logic [CELL_ID_WIDTH-1:0] o_nb_cid_z
);

compute_nb_cid_1d #(
    .GCELL_ID   ( GCELL_X   ), 
    .DIM        ( X_DIM     )
)
compute_nb_cid_x (
    .i_source_gcid_1d   ( i_source_gcid_x   ), 
    //.i_fold_id(i_fold_id), 
    
    .o_nb_cid           ( o_nb_cid_x        )
);

compute_nb_cid_1d #(
    .GCELL_ID   ( GCELL_Y   ), 
    .DIM        ( Y_DIM     )
)
compute_nb_cid_y (
    .i_source_gcid_1d   ( i_source_gcid_y   ), 
    //.i_fold_id(i_fold_id), 
    
    .o_nb_cid           ( o_nb_cid_y        )
);

compute_nb_cid_1d #(
    .GCELL_ID   ( GCELL_Z   ), 
    .DIM        ( Z_DIM     )
)
compute_nb_cid_z (
    .i_source_gcid_1d   ( i_source_gcid_z   ), 
    //.i_fold_id(i_fold_id), 
    
    .o_nb_cid           ( o_nb_cid_z        )
);

endmodule