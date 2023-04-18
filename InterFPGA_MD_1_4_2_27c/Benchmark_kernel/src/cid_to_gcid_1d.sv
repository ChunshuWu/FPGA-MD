//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2022 03:18:38 AM
// Design Name: 
// Module Name: cid_to_gcid_1d
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

module cid_to_gcid_1d
#(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_ID[NUM_CELL_FOLDS] = '{3'h0},
    parameter DIM = 0
)
(
    input [CELL_ID_WIDTH-1:0] i_cid, 
//    input [CELL_FOLD_ID_WIDTH-1:0] i_fold_id, 
    
    output logic [GLOBAL_CELL_ID_WIDTH-1:0] o_gcid
);

always@(*)
	begin
	case(i_cid)
		2'b01:
			begin
			if (GCELL_ID[0] == 0)
				begin
				o_gcid = DIM-1;
				end
			else
				begin
				o_gcid = GCELL_ID[0]-1;
				end
			end
		2'b10:
			begin
			o_gcid = GCELL_ID[0];
			end
		2'b11:
			begin
			if (GCELL_ID[0] == DIM-1)
				begin
				o_gcid = 0;
				end
			else
				begin
				o_gcid = GCELL_ID[0]+1;
				end
			end
		default:
			begin
			o_gcid = 0;
			end
	endcase
	end

endmodule
