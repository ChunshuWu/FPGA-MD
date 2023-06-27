//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2022 03:14:47 AM
// Design Name: 
// Module Name: cid_to_gcid
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

module cid_to_gcid
#(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_X[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Y[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Z[NUM_CELL_FOLDS] = '{3'h0}
)
(
	input [3*CELL_ID_WIDTH-1:0] i_cid, 
//	input [CELL_FOLD_ID_WIDTH-1:0] i_fold_id, 
	
	output [3*GLOBAL_CELL_ID_WIDTH-1:0] o_gcid
);

logic [CELL_ID_WIDTH-1:0] cid_x;
logic [CELL_ID_WIDTH-1:0] cid_y;
logic [CELL_ID_WIDTH-1:0] cid_z;

assign cid_x = i_cid[CELL_ID_WIDTH-1:0];
assign cid_y = i_cid[2*CELL_ID_WIDTH-1:CELL_ID_WIDTH];
assign cid_z = i_cid[3*CELL_ID_WIDTH-1:2*CELL_ID_WIDTH];

logic [GLOBAL_CELL_ID_WIDTH-1:0] gcid_x;
logic [GLOBAL_CELL_ID_WIDTH-1:0] gcid_y;
logic [GLOBAL_CELL_ID_WIDTH-1:0] gcid_z;

assign o_gcid = {gcid_z, gcid_y, gcid_x};

cid_to_gcid_1d
#(
    .GCELL_ID(GCELL_X), 
    .GDIM(X_GDIM)
)
cid_to_gcid_x
(
    .i_cid(cid_x), 
//    .i_fold_id(i_fold_id), 
    
    .o_gcid(gcid_x)
);

cid_to_gcid_1d
#(
    .GCELL_ID(GCELL_Y), 
    .GDIM(Y_GDIM)
)
cid_to_gcid_y
(
    .i_cid(cid_y), 
//    .i_fold_id(i_fold_id), 
    
    .o_gcid(gcid_y)
);

cid_to_gcid_1d
#(
    .GCELL_ID(GCELL_Z), 
    .GDIM(Z_GDIM)
)
cid_to_gcid_z
(
    .i_cid(cid_z), 
//    .i_fold_id(i_fold_id), 
    
    .o_gcid(gcid_z)
);

endmodule