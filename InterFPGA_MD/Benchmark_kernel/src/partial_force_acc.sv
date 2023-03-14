//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 04:32:52 AM
// Design Name: 
// Module Name: partial_force_acc
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

module partial_force_acc
(
    input                               clk, 
    input                               rst, 
    input                               nb_frc_valid, 
    input [FRC_PKT_STRUCT_WIDTH-1:0]    nb_frc, 
    input [NUM_FILTERS-1:0]             nb_reg_sel, 
    input                               nb_reg_release_flag, 
    
    output [FRC_PKT_STRUCT_WIDTH-1:0]   nb_frc_release, 
    output logic                        nb_frc_release_valid
);

logic [FLOAT_STRUCT_WIDTH-1:0]                  nb_frc_frag;
logic [NUM_FILTERS-1:0][FLOAT_STRUCT_WIDTH-1:0] nb_regs;
logic [FLOAT_STRUCT_WIDTH-1:0]                  selected_reg;
logic [NUM_FILTERS-1:0]                         nb_reg_update_sel;
logic [FLOAT_STRUCT_WIDTH-1:0]                  acc_frc;
logic                                           acc_frc_valid;

always_comb
    begin
    selected_reg = 0;
    for (int i = 0; i < NUM_FILTERS; i++)
        begin
        if (nb_reg_sel == (1 << i))
            begin
            selected_reg = nb_regs[i];
            end
        end
    end
    
assign nb_frc_frag  = nb_frc_valid ? nb_frc[FLOAT_STRUCT_WIDTH-1:0] : 0;

FP_ADD_XYZ_D3 inst_FP_ADD_XYZ (
    .clk                ( clk                       ),
    .delay_signals      ( { nb_reg_release_flag, 
                            nb_reg_sel,
                            nb_frc[FLOAT_STRUCT_WIDTH+PARTICLE_ID_WIDTH +: 3*CELL_ID_WIDTH], 
                            nb_frc[FLOAT_STRUCT_WIDTH +: PARTICLE_ID_WIDTH]}           ),
    .x_acc_in           ( selected_reg[FLOAT_WIDTH-1:0]            ),
    .y_acc_in           ( selected_reg[2*FLOAT_WIDTH-1:FLOAT_WIDTH]            ),
    .z_acc_in           ( selected_reg[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]            ),
    .x_frag             ( nb_frc_frag[FLOAT_WIDTH-1:0]             ),
    .y_frag             ( nb_frc_frag[2*FLOAT_WIDTH-1:FLOAT_WIDTH]             ),
    .z_frag             ( nb_frc_frag[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]             ),
    .frag_valid         ( nb_frc_valid              ),
    
    .x_acc_out          ( acc_frc[FLOAT_WIDTH-1:0]                 ),
    .y_acc_out          ( acc_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]                 ),
    .z_acc_out          ( acc_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]                 ),
    .delayed_signals    ( { nb_frc_release_valid, 
                            nb_reg_update_sel,
                            nb_frc_release[FLOAT_STRUCT_WIDTH+PARTICLE_ID_WIDTH +: 3*CELL_ID_WIDTH], 
                            nb_frc_release[FLOAT_STRUCT_WIDTH +: PARTICLE_ID_WIDTH]}   ),
    .acc_valid_out      ( acc_frc_valid             )
);

assign nb_frc_release[FLOAT_STRUCT_WIDTH-1:0] = nb_frc_release_valid ? acc_frc : 0;

always@(posedge clk) begin
    if (rst) begin
        nb_regs <= 0;
    end
    else begin
        for (int i = 0; i < NUM_FILTERS; i++) begin
            if (nb_reg_update_sel == (1 << i)) begin
                if (nb_frc_release_valid) begin
                    nb_regs[i] <= 0;
                end
                else begin
                    if (acc_frc_valid) begin
                        nb_regs[i] <= acc_frc;
                    end
                end
            end
        end
    end
end

endmodule
