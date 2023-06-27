//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2022 04:14:49 AM
// Design Name: 
// Module Name: LJ_element_coeff
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

module LJ_element_coeff
(
    input [2*ELEMENT_WIDTH-1:0] i_elements,
    
    output logic [FLOAT_WIDTH-1:0] o_coeff_8, 
    output logic [FLOAT_WIDTH-1:0] o_coeff_14
);

always@(*)
begin
case(i_elements)
    4'b0101:			// Na-Na
        begin
        o_coeff_14 = NA_NA_COEFF_14;
        o_coeff_8 = NA_NA_COEFF_8;
        end
    4'b0110:
        begin
        o_coeff_14 = NA_CL_COEFF_14;
        o_coeff_8 = NA_CL_COEFF_8;
        end
    4'b1001:
        begin
        o_coeff_14 = NA_CL_COEFF_14;
        o_coeff_8 = NA_CL_COEFF_8;
        end
    4'b1010:
        begin
        o_coeff_14 = CL_CL_COEFF_14;
        o_coeff_8 = CL_CL_COEFF_8;
        end
    default:
        begin
        o_coeff_14 = 0;
        o_coeff_8 = 0;
        end
endcase
end

endmodule
