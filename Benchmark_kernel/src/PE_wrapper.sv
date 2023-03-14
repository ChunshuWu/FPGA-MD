`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2022 04:09:30 AM
// Design Name: 
// Module Name: PE_wrapper
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

module PE_wrapper(
    input                                                   clk, 
    input                                                   rst, 
    input  [OFFSET_PKT_STRUCT_WIDTH-1:0]                    home_offset,
    input                                                   home_offset_valid,
    input  [POS_PKT_STRUCT_WIDTH-1:0]                       nb_pos,
    input                                                   nb_pos_valid,
    
    output [FLOAT_STRUCT_WIDTH*NUM_PES_PER_CELL-1:0]        home_frc,
    output [PARTICLE_ID_WIDTH*NUM_PES_PER_CELL-1:0]         home_frc_parid,
    output [NUM_PES_PER_CELL-1:0]                           home_frc_valid,
    output logic [FRC_PKT_STRUCT_WIDTH-1:0]                 nb_frc_acc,
    output                                                  nb_frc_acc_valid,
    output                                                  disp_back_pressure,
    output                                                  disp_buf_empty
);

logic [NUM_PES_PER_CELL-1:0]                            disp_back_pressure_bus;
logic [NUM_PES_PER_CELL-1:0]                            disp_buf_empty_bus;
logic [NUM_PES_PER_CELL-1:0]                            input_arb_result;
logic [NUM_PES_PER_CELL-1:0]                            output_arb_result;
logic [NUM_PES_PER_CELL-1:0][FRC_PKT_STRUCT_WIDTH-1:0]  nb_frc_acc_infifo_bus;
logic [NUM_PES_PER_CELL-1:0]                            nb_frc_acc_valid_infifo_bus;
logic [NUM_PES_PER_CELL-1:0][FRC_PKT_STRUCT_WIDTH-1:0]  nb_frc_acc_outfifo_bus;
logic [NUM_PES_PER_CELL-1:0]                            nb_buf_empty;
logic [NUM_PES_PER_CELL-1:0]                            nb_buf_full;
assign disp_buf_empty       = & disp_buf_empty_bus;
assign disp_back_pressure   = | disp_back_pressure_bus;

PE_round_robin_arbiter PE_input_arbiter (      // Select which PE should accept the incoming nb particle
	.clk           ( clk                       ), 
	.rst           ( rst                       ), 
	.i_arbiter_en  ( nb_pos_valid              ), 
	.i_request     ( ~disp_back_pressure_bus   ), 
	
	.o_grant       ( input_arb_result                ) 
);

genvar i;
generate
    for (i = 0; i < NUM_PES_PER_CELL; i++) begin: PEs
        PE inst_PE(
            .clk                ( clk                       ),
            .rst                ( rst                       ),
            .home_offset        ( home_offset               ),
            .home_offset_valid  ( home_offset_valid         ),
            .nb_pos             ( nb_pos                    ),
            .nb_pos_valid       ( input_arb_result[i]       ),
            
            .home_frc           ( home_frc[(i+1)*FLOAT_STRUCT_WIDTH-1:i*FLOAT_STRUCT_WIDTH]                 ),
            .home_frc_parid     ( home_frc_parid[(i+1)*PARTICLE_ID_WIDTH-1:i*PARTICLE_ID_WIDTH]             ),
            .home_frc_valid     ( home_frc_valid[i]                                                         ),
            .nb_frc_acc         ( nb_frc_acc_infifo_bus[i]                                                  ),
            .nb_frc_acc_valid   ( nb_frc_acc_valid_infifo_bus[i]                                            ),
            .disp_back_pressure ( disp_back_pressure_bus[i]                                                 ),
            .disp_buf_empty     ( disp_buf_empty_bus[i]                                                     )
        );
    end
    for (i = 0; i < NUM_PES_PER_CELL; i++) begin: BUFs
        NB_FRC_TO_RING_BUF NB_FRC_BUF(
            .clk           ( clk                                                                        ),
            .rst           ( rst                                                                        ),
            .wr_data       ( nb_frc_acc_infifo_bus[i] ),
            .wr_en         ( nb_frc_acc_valid_infifo_bus[i]                                             ),
            .rd_en         ( output_arb_result[i]                                                       ),
            
            .rd_data       ( nb_frc_acc_outfifo_bus[i]),
            .buf_empty     ( nb_buf_empty[i]                                                            ),
            .almost_full   ( nb_buf_full[i]                                                             )
        );
    end
endgenerate

PE_round_robin_arbiter PE_output_arbiter       // Select which PE should accept the incoming nb particle
(
	.clk           ( clk                                           ), 
	.rst           ( rst                                           ), 
	.i_arbiter_en  ( nb_buf_empty != {(NUM_PES_PER_CELL){1'b1}}    ), 
	.i_request     ( ~nb_buf_empty                                 ), 
	
	.o_grant       ( output_arb_result                             ) 
);

always_comb
    begin
    nb_frc_acc = 0;
    for (int j = 0; j < NUM_PES_PER_CELL; j++)
        begin
        if (output_arb_result == (1 << j))
            begin
            nb_frc_acc = nb_frc_acc_outfifo_bus[j];
            end
        end
    end

assign nb_frc_acc_valid = (output_arb_result != 0);

endmodule

