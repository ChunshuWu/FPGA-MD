
import MD_pkg::*;

module fixed2float

/* The input cell_id is increased by 1 so the first cell has the id of 1 instead of 0 (easy to find the leading bit)*/
/* CAUTION: cell_id represents the relative cell location: 01 10 11 - left, center, right*/
(
	input clk, 
	input rst, 
	input [DATA_WIDTH-1:0] a, 
	
	output logic [FLOAT_WIDTH-1:0] q
);

// Disregard the first bit since it's always 0
logic [CELL_ID_WIDTH-1:0] cell_id;
logic cell_id_critical_bit;
assign cell_id = a[DATA_WIDTH-1:DATA_WIDTH-CELL_ID_WIDTH];
logic [FLOAT_WIDTH-1:0] q_wire;
assign q_wire[FLOAT_WIDTH-1] = 1'b0;    // Always positive

always@(*)
	begin
	if (cell_id[1])  // 1x, the first bit in cell_id is the leading 1
	   begin
	   q_wire[FLOAT_WIDTH-2:MANTISSA_WIDTH] = EXP_1;
	   q_wire[MANTISSA_WIDTH-1:0] = a[DATA_WIDTH-CELL_ID_WIDTH : DATA_WIDTH-MANTISSA_WIDTH-CELL_ID_WIDTH+1];
	   end
	else// if (cell_id[0])   // 01, the 2nd bit in cell_id is the leading 1
	   begin
	   q_wire[FLOAT_WIDTH-2:MANTISSA_WIDTH] = EXP_0;
	   q_wire[MANTISSA_WIDTH-1:0] = a[DATA_WIDTH-1-CELL_ID_WIDTH : DATA_WIDTH-MANTISSA_WIDTH-CELL_ID_WIDTH];
	   end
//	else       // 00, 0 output. Not necessary, for there's a valid signal in all_fixed2float
//	   begin
//	   q_wire[FLOAT_WIDTH-2:MANTISSA_WIDTH] = 0;
//	   q_wire[MANTISSA_WIDTH-1:0] = 0;
//	   end
	end

always@(posedge clk)		// Output register
	begin
	if (rst)
		begin
		q <= 0;
		end
	else
		begin
		q <= q_wire;
		end
	end

endmodule