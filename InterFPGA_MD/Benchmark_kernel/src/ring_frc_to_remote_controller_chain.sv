`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2023 06:07:40 PM
// Design Name: 
// Module Name: ring_frc_to_remote_controller_chain
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


module ring_frc_to_remote_controller_chain(
    input                                           clk,
    input                                           rst,
    input           [NODE_ID_WIDTH-1:0]             i_init_id,                                  // Assume up to 8 nodes, 3 bits
    input                                           i_remote_frc_eval_flag,
    input           [FLOAT_STRUCT_WIDTH-1:0]        i_frc_to_remote, 					// to remote
    input           [3*GLOBAL_CELL_ID_WIDTH-1:0]    i_frc_gcid_to_remote,
    input                                           i_frc_to_remote_valid,
    input           [PARTICLE_ID_WIDTH-1:0]         i_frc_parid_to_remote,
    input           [NUM_REMOTE_DEST_NODES-1:0]     i_frc_ticket_onehot,
    
    output logic    [AXIS_PKT_STRUCT_WIDTH-1:0]     o_axis_frc_pkt_to_remote,                  // to remote
    output logic                                    o_ring_pos_to_remote_bufs_empty,
    output logic                                    o_debug_frc_burst_running,
    output logic                                    o_debug_last_frc_sent
);

logic [NODE_ID_WIDTH-1:0] dest_id;

// hard-coded for x-z
always@(*) begin
    case (i_frc_ticket_onehot)
        3'b001: begin       // Z diff
            dest_id = {i_init_id[2], i_init_id[1], i_init_id[0]+1'b1};
        end
        3'b010: begin       // X diff
            dest_id = {i_init_id[2]+1'b1, i_init_id[1], i_init_id[0]};
        end
        3'b100: begin       // XZ diff
            dest_id = {i_init_id[2]+1'b1, i_init_id[1], i_init_id[0]+1'b1};
        end
        default: begin
            dest_id = i_init_id;
        end
    endcase
end

ring_frc_to_remote_controller ring_pos_to_remote_controller_xz (
    .clk                            ( clk                           ), 
    .rst                            ( rst                           ),
    .i_dest_id                      ( dest_id                       ),      // tbc
    .i_frc_ticket                   ( i_frc_ticket_onehot[2]        ),
    .i_remote_frc_eval_flag         ( i_remote_frc_eval_flag        ),
    .i_frc_to_remote                ( i_frc_to_remote               ),
    .i_frc_gcid_to_remote           ( i_frc_gcid_to_remote          ),
    .i_frc_to_remote_valid          ( i_frc_to_remote_valid         ),
    .i_frc_parid_to_remote          ( i_frc_parid_to_remote         ),
    
    .o_axis_frc_pkt_to_remote       ( axis_frc_pkt_to_remote_xz     ),
    .o_debug_frc_burst_running      ( frc_burst_running_xz          ),
    .o_debug_last_frc_sent          ( last_frc_sent_xz              )
);

ring_frc_to_remote_controller ring_pos_to_remote_controller_x (
    .clk                            ( clk                           ), 
    .rst                            ( rst                           ),
    .i_dest_id                      ( d1_dest_id                    ),      // tbc
    .i_frc_ticket                   ( d1_frc_ticket_onehot[1]       ),
    .i_remote_frc_eval_flag         ( d1_remote_frc_eval_flag       ),
    .i_frc_to_remote                ( d1_frc_to_remote              ),
    .i_frc_gcid_to_remote           ( d1_frc_gcid_to_remote         ),
    .i_frc_to_remote_valid          ( d1_frc_to_remote_valid        ),
    .i_frc_parid_to_remote          ( d1_frc_parid_to_remote        ),
    
    .o_axis_frc_pkt_to_remote       ( axis_frc_pkt_to_remote_x      ),
    .o_debug_frc_burst_running      ( frc_burst_running_x           ),
    .o_debug_last_frc_sent          ( last_frc_sent_x               )
);

ring_frc_to_remote_controller ring_pos_to_remote_controller_z (
    .clk                            ( clk                           ), 
    .rst                            ( rst                           ),
    .i_dest_id                      ( d2_dest_id                    ),      // tbc
    .i_frc_ticket                   ( d2_frc_ticket_onehot[0]       ),
    .i_remote_frc_eval_flag         ( d2_remote_frc_eval_flag       ),
    .i_frc_to_remote                ( d2_frc_to_remote              ),
    .i_frc_gcid_to_remote           ( d2_frc_gcid_to_remote         ),
    .i_frc_to_remote_valid          ( d2_frc_to_remote_valid        ),
    .i_frc_parid_to_remote          ( d2_frc_parid_to_remote        ),
    
    .o_axis_frc_pkt_to_remote       ( axis_frc_pkt_to_remote_z      ),
    .o_debug_frc_burst_running      ( frc_burst_running_z           ),
    .o_debug_last_frc_sent          ( last_frc_sent_z               )
);

NETWORK_OUT_FIFO ring_frc_to_remote_fifo_xz (
    .clk_0          ( clk                                                           ),
    .srst_0         ( rst                                                           ),
    .din_0          ( axis_frc_pkt_to_remote_xz[AXIS_PKT_STRUCT_WIDTH-2:0]          ),
    .wr_en_0        ( axis_frc_pkt_to_remote_xz[AXIS_PKT_STRUCT_WIDTH-1]            ),        // tbc
    .rd_en_0        ( ring_frc_to_remote_arb_xz & ~fifo_xz_empty                    ),
    
    .prog_full_0    ( fifo_xz_full                                                  ),
    .empty_0        ( fifo_xz_empty                                                 ),
    .valid_0        ( axis_frc_pkt_to_remote_xz_bufout[AXIS_PKT_STRUCT_WIDTH-1]     ),
    .dout_0         ( axis_frc_pkt_to_remote_xz_bufout[AXIS_PKT_STRUCT_WIDTH-2:0]   )
);

NETWORK_OUT_FIFO ring_frc_to_remote_fifo_x (
    .clk_0          ( clk                                                           ),
    .srst_0         ( rst                                                           ),
    .din_0          ( axis_frc_pkt_to_remote_x[AXIS_PKT_STRUCT_WIDTH-2:0]           ),
    .wr_en_0        ( axis_frc_pkt_to_remote_x[AXIS_PKT_STRUCT_WIDTH-1]             ),        // tbc
    .rd_en_0        ( ring_frc_to_remote_arb_x & ~fifo_x_empty                      ),
    
    .prog_full_0    ( fifo_x_full                                                   ),
    .empty_0        ( fifo_x_empty                                                  ),
    .valid_0        ( axis_frc_pkt_to_remote_x_bufout[AXIS_PKT_STRUCT_WIDTH-1]      ),
    .dout_0         ( axis_frc_pkt_to_remote_x_bufout[AXIS_PKT_STRUCT_WIDTH-2:0]    )
);

NETWORK_OUT_FIFO ring_frc_to_remote_fifo_z (
    .clk_0          ( clk                                                           ),
    .srst_0         ( rst                                                           ),
    .din_0          ( axis_frc_pkt_to_remote_z[AXIS_PKT_STRUCT_WIDTH-2:0]           ),
    .wr_en_0        ( axis_frc_pkt_to_remote_z[AXIS_PKT_STRUCT_WIDTH-1]             ),        // tbc
    .rd_en_0        ( ring_frc_to_remote_arb_z & ~fifo_z_empty                      ),
    
    .prog_full_0    ( fifo_z_full                                                   ),
    .empty_0        ( fifo_z_empty                                                  ),
    .valid_0        ( axis_frc_pkt_to_remote_z_bufout[AXIS_PKT_STRUCT_WIDTH-1]      ),
    .dout_0         ( axis_frc_pkt_to_remote_z_bufout[AXIS_PKT_STRUCT_WIDTH-2:0]    )
);

ring_pos_to_remote_arbiter ring_pos_to_remote_arbiter       // Select which filter should the nb paricle enter
(
	.clk(clk), 
	.rst(rst), 
	.i_request({~fifo_z_empty, ~fifo_x_empty, ~fifo_xz_empty}), 
	.i_arbiter_en(1'b1), 
	
	.o_grant(ring_pos_to_remote_arb_result) 
);

endmodule
