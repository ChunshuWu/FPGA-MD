
import MD_pkg::*;

module dst_cell_id_calculator #(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_X[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Y[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Z[NUM_CELL_FOLDS] = '{3'h0}
)
(
	input clk, 
	input rst, 
	
	input [MU_ID_WIDTH-1:0] src_cell_id, 
	input [1:0] cell_x_offset,
	input [1:0] cell_y_offset,
	input [1:0] cell_z_offset,
	
	output [MU_ID_WIDTH-1:0] dst_MU_id
);


logic [MU_ID_WIDTH-1:0] dst_cell_x_diff;
logic [MU_ID_WIDTH-1:0] dst_cell_y_diff;
logic [MU_ID_WIDTH-1:0] dst_cell_z_diff;

// Determine x target cell
always@(posedge clk)
	begin
	if (rst)
		begin
		dst_cell_x_diff <= 0;
		end
	else
		begin
		case(cell_x_offset)
			// x+
			2'b01:
				begin
				if (GCELL_X[0] == X_DIM-1)
					begin
					dst_cell_x_diff <= -(X_DIM-1)*Y_DIM*Z_DIM;
					end
				else
					begin
					dst_cell_x_diff <= Y_DIM*Z_DIM;
					end
				end
			// x-
			2'b11:
				begin
				if (GCELL_X[0] == 0)
					begin
					dst_cell_x_diff <= (X_DIM-1)*Y_DIM*Z_DIM;
					end
				else
					begin
					dst_cell_x_diff <= -Y_DIM*Z_DIM;
					end
				end
			2'b00:
				begin
				dst_cell_x_diff <= 0;
				end
			default:
				begin
				dst_cell_x_diff <= 0;
				end
		endcase
		end
	end

always@(posedge clk)
	begin
	if (rst)
		begin
		dst_cell_y_diff <= 0;
		end
	else
		begin
		case(cell_y_offset)
			// y+
			2'b01:
				begin
				if (GCELL_Y[0] == Y_DIM-1)
					begin
					dst_cell_y_diff <= -(Y_DIM-1)*Z_DIM;
					end
				else
					begin
					dst_cell_y_diff <= Z_DIM;
					end
				end
			// y-
			2'b11:
				begin
				if (GCELL_Y[0] == 0)
					begin
					dst_cell_y_diff <= (Y_DIM-1)*Z_DIM;
					end
				else
					begin
					dst_cell_y_diff <= -Z_DIM;
					end
				end
			2'b00:
				begin
				dst_cell_y_diff <= 0;
				end
			default:
				begin
				dst_cell_y_diff <= 0;
				end
		endcase
		end
	end
	
always@(posedge clk)
	begin
	if (rst)
		begin
		dst_cell_z_diff <= 0;
		end
	else
		begin
		case(cell_z_offset)
			// z+
			2'b01:
				begin
				if (GCELL_Z[0] == Z_DIM-1)
					begin
					dst_cell_z_diff <= -(Z_DIM-1);
					end
				else
					begin
					dst_cell_z_diff <= 1;
					end
				end
			// z-
			2'b11:
				begin
				if (GCELL_Z[0] == 0)
					begin
					dst_cell_z_diff <= Z_DIM-1;
					end
				else
					begin
					dst_cell_z_diff <= -1;
					end
				end
			2'b00:
				begin
				dst_cell_z_diff <= 0;
				end
			default:
				begin
				dst_cell_z_diff <= 0;
				end
		endcase
		end
	end

assign dst_MU_id = src_cell_id + dst_cell_x_diff + dst_cell_y_diff + dst_cell_z_diff;

endmodule