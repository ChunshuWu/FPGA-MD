// Add float displacement back to fixed position

import MD_pkg::*;

module float2fixed (
	input clk, 
	input rst, 
	
	input [FLOAT_WIDTH-1:0] a, 
	input [OFFSET_WIDTH-1:0] b, 
	
	output reg [1:0] cell_offset, 
	output [OFFSET_WIDTH-1:0] q
);



wire [7:0] exp;
wire [7:0] shift;
wire [OFFSET_WIDTH-1:0] mantissa_ext;
wire [OFFSET_WIDTH-1:0] fixed;
reg [OFFSET_WIDTH:0] sum;

assign exp = a[30:23];
assign mantissa_ext = (OFFSET_WIDTH < 24) ? {1'b1, a[22:MANTISSA_WIDTH+1-OFFSET_WIDTH]} : {1'b1, a[22:0], {(OFFSET_WIDTH-24){1'b0}}};
assign shift = EXP_0-exp;
assign fixed = mantissa_ext >> shift;
assign q = sum[OFFSET_WIDTH-1:0];

always@(*) begin
    if (a[31]) begin
		// Underflow, meaning particle migrates to the cell at x-. 2's complement is taken advantage of
        if (sum[OFFSET_WIDTH]) begin
            cell_offset = 2'b11;
        end
        else begin
            cell_offset = 2'b00;
        end
    end
    else begin
		// Overflow, meaning the particle migrates to the cell at x+.
        if (sum[OFFSET_WIDTH]) begin
            cell_offset = 2'b01;
        end
        else begin
            cell_offset = 2'b00;
        end
    end
end

always@(posedge clk) begin
	if (rst) begin
		sum <= 0;
	end
	else begin
		// Negative displacement
		if (a[31]) begin
			sum <= b-fixed;
		end
		else begin
			sum <= b+fixed;
		end
	end
end
endmodule