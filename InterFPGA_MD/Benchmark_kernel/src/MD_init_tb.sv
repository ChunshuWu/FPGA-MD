`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2023 03:57:25 PM
// Design Name: 
// Module Name: MD_init_tb
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

module MD_init_tb;

logic clk;
logic rst;
logic [AXIS_TDATA_WIDTH-1:0] i_init_tdata;
logic i_init_tvalid;
//    input [INIT_STEP_WIDTH-1:0] i_init_step, 

logic [PARTICLE_ID_WIDTH-1:0]                    o_init_wr_addr;
logic [NUM_CELLS-1:0][OFFSET_STRUCT_WIDTH-1:0]   o_init_data;
logic [NUM_CELLS-1:0][ELEMENT_WIDTH-1:0]         o_init_element;
logic [NUM_INIT_STEPS-1:0]                       o_init_wr_en;
logic [INIT_STEP_WIDTH-1:0]                      o_init_step;

always@(posedge clk) begin
    if (rst) begin
        i_init_tdata <= 0;
    end
    else begin
        i_init_tdata <= i_init_tdata + {16{32'h00000001}};
    end
end

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
//	i_init_tdata <= 1'b0;
	i_init_tvalid <= 1'b0;
	
	#10
	rst <= 1'b0;
	
	#2
//	i_init_tdata <= {16{32'hAAAAAAAA}};
	i_init_tvalid <= 1;
	
//	#2
//	i_init_tdata <= {16{32'hBBBBBBBB}};
	
//	#2
//	i_init_tdata <= {16{32'hCCCCCCCC}};
	
//	#2
//	i_init_tdata <= {16{32'hDDDDDDDD}};
	
//	#2
//	i_init_tdata <= {16{32'hEEEEEEEE}};
	
//	#2
//	i_init_tdata <= {16{32'hFFFFFFFF}};
	
//	#2
//	i_init_tdata <= {16{32'hAAAABBBB}};
	
//	#2
//	i_init_tdata <= {16{32'hAAAACCCC}};
	
//	#2
//	i_init_tdata <= {16{32'hAAAADDDD}};
	
//	#2
//	i_init_tdata <= {16{32'hAAAAEEEE}};
	
//	#2
//	i_init_tdata <= {16{32'hAAAAFFFF}};
	
//	#2
//	i_init_tdata <= {16{32'hBBBBAAAA}};
	
//	#2
//	i_init_tdata <= {16{32'hBBBBCCCC}};
	
//	#2
//	i_init_tdata <= {16{32'hBBBBDDDD}};
	
//	#2
//	i_init_tdata <= {16{32'hBBBBEEEE}};
	
//	#2
//	i_init_tdata <= {16{32'hBBBBFFFF}};
	#224
	i_init_tvalid <= 0;
	end
	
MD_init inst_MD_init
(
    .clk(clk), 
    .rst(rst), 
    .i_init_tvalid   ( i_init_tvalid        ), 
    .i_init_tdata    ( i_init_tdata         ), 
 //   .i_init_step     ( init_step_w        ),
    
    .o_init_wr_addr  ( o_init_wr_addr       ),
    .o_init_data     ( o_init_data          ),
    .o_init_element  ( o_init_element       ),
    .o_init_wr_en    ( o_init_wr_en         ),
    .o_init_step     ( o_init_step          )
//    .o_init_bank_sel ( init_bank_sel      )
);
endmodule
