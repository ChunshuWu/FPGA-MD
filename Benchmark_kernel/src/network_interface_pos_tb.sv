`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: 
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

import MD_pkg::*;   // Change OFFSET_WIDTH to 30 before simulating, or change the test cases below. 

module network_interface_pos_tb;


parameter integer AXIS_TDATA_WIDTH      = 512;
parameter integer STREAMING_TDEST_WIDTH =  16;

reg                                   clk;
reg                                   rst;

// AXI4-Stream network layer to streaming kernel 
reg          [AXIS_TDATA_WIDTH-1:0]   S_AXIS_n2k_tdata;
reg        [AXIS_TDATA_WIDTH/8-1:0]   S_AXIS_n2k_tkeep;
reg                                   S_AXIS_n2k_tvalid;
reg                                   S_AXIS_n2k_tlast;
reg     [STREAMING_TDEST_WIDTH-1:0]   S_AXIS_n2k_tdest;
wire                                  S_AXIS_n2k_tready;
// AXI4-Stream streaming kernel to network layer
wire         [AXIS_TDATA_WIDTH-1:0]   M_AXIS_k2n_tdata;
wire       [AXIS_TDATA_WIDTH/8-1:0]   M_AXIS_k2n_tkeep;
wire                                  M_AXIS_k2n_tvalid;
wire                                  M_AXIS_k2n_tlast;
wire    [STREAMING_TDEST_WIDTH-1:0]   M_AXIS_k2n_tdest;
reg                                   M_AXIS_k2n_tready;

reg                                   reset_fsm_n;
reg                                   ap_start;
reg                          [31:0]   number_packets;
wire                                  ap_idle;
wire                                  ap_done;

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	
    S_AXIS_n2k_tdata  <= 0;
    S_AXIS_n2k_tkeep  <= 0;
    S_AXIS_n2k_tvalid <= 0;
    S_AXIS_n2k_tlast  <= 0;
    S_AXIS_n2k_tdest  <= 0;
    M_AXIS_k2n_tready <= 0;
    reset_fsm_n       <= 0;
    ap_start          <= 0;

/////////////////////////////////////////////////////
// Init test
/////////////////////////////////////////////////////
	#12
	rst <= 1'b0;
	
	#12
	reset_fsm_n <= 1'b1;
	
	#10
	ap_start <= 1;
	number_packets <= 10;
	
	#2
	ap_start <= 0;
	
	#10
    M_AXIS_k2n_tready <= 1;
	
	#10
	S_AXIS_n2k_tdata  <= {(16){32'haaaaaaaa}};
    S_AXIS_n2k_tkeep  <= 100;
	S_AXIS_n2k_tvalid <= 1;
	S_AXIS_n2k_tlast  <= 1;
    S_AXIS_n2k_tdest  <= 10;
	
	#2
	S_AXIS_n2k_tdata  <= {(16){32'hbbbbbbbb}};
	
	#2
    M_AXIS_k2n_tready <= 0;
	S_AXIS_n2k_tdata  <= {(16){32'hcccccccc}};
	
	#2
	S_AXIS_n2k_tdata  <= {(16){32'hdddddddd}};
	
	#2
	S_AXIS_n2k_tvalid <= 0;
	S_AXIS_n2k_tdata <= {(16){32'heeeeeeee}};
	
	#2
    M_AXIS_k2n_tready <= 1;
	S_AXIS_n2k_tdata <= {(16){32'heeeeeeee}};
	
	#2
	S_AXIS_n2k_tdata <= {(16){32'heeeeeeee}};
	
	#2
	S_AXIS_n2k_tvalid <= 1;
	S_AXIS_n2k_tdata <= {(16){32'heeeeeeee}};
	
	#2
	S_AXIS_n2k_tdata <= {(16){32'hffffffff}};
	
	
	end
	
network_interface_pos #(
        .AXIS_TDATA_WIDTH      ( 512                ),
        .STREAMING_TDEST_WIDTH ( 16                 )
    ) NI_pos (
        .ap_clk                ( clk                ),
        .ap_rst_n              ( ~rst               ),
        
        .S_AXIS_n2k_tdata      ( S_AXIS_n2k_tdata   ),
        .S_AXIS_n2k_tkeep      ( S_AXIS_n2k_tkeep   ),
        .S_AXIS_n2k_tvalid     ( S_AXIS_n2k_tvalid  ),
        .S_AXIS_n2k_tlast      ( S_AXIS_n2k_tlast   ),
        .S_AXIS_n2k_tdest      ( S_AXIS_n2k_tdest   ),
        .S_AXIS_n2k_tready     ( S_AXIS_n2k_tready  ),
        
        .M_AXIS_k2n_tdata      ( M_AXIS_k2n_tdata   ),
        .M_AXIS_k2n_tkeep      ( M_AXIS_k2n_tkeep   ),
        .M_AXIS_k2n_tvalid     ( M_AXIS_k2n_tvalid  ),
        .M_AXIS_k2n_tlast      ( M_AXIS_k2n_tlast   ),
        .M_AXIS_k2n_tdest      ( M_AXIS_k2n_tdest   ),
        .M_AXIS_k2n_tready     ( M_AXIS_k2n_tready  ),

        .number_packets        ( number_packets     ),
        .reset_fsm_n           ( reset_fsm_n        ),
        .ap_start              ( ap_start           ),
        .ap_idle               ( ap_idle            ),
        .ap_done               ( ap_done            )
    );

endmodule