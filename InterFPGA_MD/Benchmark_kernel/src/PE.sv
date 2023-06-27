
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2022 01:24:11 AM
// Design Name: 
// Module Name: PE
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

module PE(
    input                                   clk, 
    input                                   rst, 
    
    input                                   pos_spinning,
    input  [OFFSET_PKT_STRUCT_WIDTH-1:0]    home_offset,
    input                                   home_offset_valid,
    input  [POS_PKT_STRUCT_WIDTH-1:0]       nb_pos,
    input  [NODE_ID_WIDTH-1:0]              pos_node_id,
    input                                   nb_pos_valid,
    
    output [FLOAT_STRUCT_WIDTH-1:0]         home_frc,
    output [PARTICLE_ID_WIDTH-1:0]          home_frc_parid,
    output                                  home_frc_valid,
    output [FRC_PKT_STRUCT_WIDTH-1:0]       nb_frc_acc,
    output [NODE_ID_WIDTH-1:0]              frc_node_id,
    output                                  nb_frc_acc_valid,
    output                                  disp_back_pressure,
    output                                  disp_buf_empty,
    output                                  filter_back_pressure,
    output [NUM_FILTERS-1:0]                filtering_flag,
    output                                  pair_valid,
    output logic                            filter_buf_empty
);

logic [POS_PKT_STRUCT_WIDTH-1:0]    home_pos;
logic [POS_PKT_STRUCT_WIDTH-1:0]    nb_reg;
logic [NODE_ID_WIDTH-1:0]           node_id_reg;
logic [3*CELL_ID_WIDTH-1:0]         nb_cid;
logic                               float_pair_valid;
logic                               r2_valid;
logic                               frc_valid;
logic [FRC_PKT_STRUCT_WIDTH-1:0]    nb_frc;
logic                               nb_frc_valid;

logic [NUM_FILTERS-1:0]             nb_reg_sel;
logic                               nb_reg_release_flag;
logic [NUM_FILTERS-1:0]             d36_nb_reg_sel;
logic                               d36_nb_reg_release_flag;

logic [2*ELEMENT_WIDTH-1:0] elements;
logic [2*ELEMENT_WIDTH-1:0] d25_elements;

logic [NODE_ID_WIDTH-1:0]   d36_node_id;

logic [FLOAT_STRUCT_WIDTH-1:0]  home_pos_float;
logic [FLOAT_STRUCT_WIDTH-1:0]  nb_pos_float;

logic [FLOAT_WIDTH-1:0]     r2;
logic [FLOAT_WIDTH-1:0]     d1_r2;
logic [FLOAT_WIDTH-1:0]     d2_r2;
logic [FLOAT_WIDTH-1:0]     dx;
logic [FLOAT_WIDTH-1:0]     dy;
logic [FLOAT_WIDTH-1:0]     dz;

assign elements = {home_pos[POS_STRUCT_WIDTH +: ELEMENT_WIDTH], nb_reg[POS_STRUCT_WIDTH +: ELEMENT_WIDTH]};

filter_dispatcher inst_filter_dispatcher
(
    .clk                            ( clk                   ), 
    .rst                            ( rst                   ), 
    
    .i_pos_spinning                 ( pos_spinning          ),
    .i_home_data                    ( home_offset           ),
    .i_home_data_valid              ( home_offset_valid     ),
    .i_nb_data                      ( nb_pos                ),
    .i_node_id                      ( pos_node_id           ),
    .i_nb_data_valid                ( nb_pos_valid          ),
    
    .o_home_pos                     ( home_pos[POS_STRUCT_WIDTH-1:0]                                ),
    .o_home_element                 ( home_pos[POS_STRUCT_WIDTH +: ELEMENT_WIDTH]                   ), 
    .o_home_parid                   ( home_pos[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] ),
    .o_pair_valid                   ( pair_valid            ),
    .o_nb_reg                       ( nb_reg                ),
    .o_node_id_reg                  ( node_id_reg           ),
    .o_acc_reg_select               ( nb_reg_sel            ),
    .o_nb_release_flag              ( nb_reg_release_flag   ),
    .o_dispatcher_back_pressure     ( disp_back_pressure    ),
    .o_dispatcher_buffer_empty      ( disp_buf_empty        ),
    .o_filter_back_pressure         ( filter_back_pressure  ),
    .o_filtering_flag               ( filtering_flag        ),
    .o_filter_buffer_empty          ( filter_buf_empty      )
);

assign nb_cid = {nb_reg[3*DATA_WIDTH-1:3*DATA_WIDTH-CELL_ID_WIDTH], 
                 nb_reg[2*DATA_WIDTH-1:2*DATA_WIDTH-CELL_ID_WIDTH], 
                 nb_reg[DATA_WIDTH-1:DATA_WIDTH-CELL_ID_WIDTH]};

assign home_frc_valid = frc_valid;
assign nb_frc_valid   = frc_valid;

fixed2float_6x inst_fixed_float_converter (
    .clk                ( clk                               ), 
    .rst                ( rst                               ), 
    .i_home_pos         ( home_pos[POS_STRUCT_WIDTH-1:0]    ), 
    .i_nb_pos           ( nb_reg[POS_STRUCT_WIDTH-1:0]      ), 
    .i_pair_valid       ( pair_valid                        ), 
    
    .o_home_pos_float   ( home_pos_float                    ), 
    .o_nb_pos_float     ( nb_pos_float                      ), 
    .o_pair_valid       ( float_pair_valid                  )
);

FP_RSQUARE inst_FP_RSQUARE (
    .aclk                       ( clk                       ),
    .elements                   ( elements                  ),
    .home_x                     ( home_pos_float[FLOAT_WIDTH-1:0]               ),
    .home_y                     ( home_pos_float[2*FLOAT_WIDTH-1:FLOAT_WIDTH]   ),
    .home_z                     ( home_pos_float[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH] ),
    .home_parid                 ( home_pos[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH]            ),
    .nb_x                       ( nb_pos_float[FLOAT_WIDTH-1:0]                 ),
    .nb_y                       ( nb_pos_float[2*FLOAT_WIDTH-1:FLOAT_WIDTH]     ),
    .nb_z                       ( nb_pos_float[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]   ),
    .nb_parid                   ( nb_reg[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH]              ),
    .nb_cid                     ( nb_cid                    ),
    .node_id                    ( node_id_reg               ),
    .nb_reg_sel                 ( nb_reg_sel                ),
    .nb_reg_release_flag        ( nb_reg_release_flag       ),
    .home_valid                 ( float_pair_valid          ),
    .nb_valid                   ( float_pair_valid          ),
    
    .d25_elements               ( d25_elements              ),
    .d36_home_parid             ( home_frc_parid            ),
    .d36_nb_parid               ( nb_frc[FLOAT_STRUCT_WIDTH +: PARTICLE_ID_WIDTH]                   ),
    .d36_nb_cid                 ( nb_frc[FLOAT_STRUCT_WIDTH+PARTICLE_ID_WIDTH +: 3*CELL_ID_WIDTH]   ),
    .d36_node_id                ( d36_node_id               ),
    .d36_nb_reg_sel             ( d36_nb_reg_sel            ),
    .d36_nb_reg_release_flag    ( d36_nb_reg_release_flag   ),
    .dx                         ( dx                        ),
    .dy                         ( dy                        ),
    .dz                         ( dz                        ),
    .r2                         ( r2                        ),
    .r2_valid                   ( r2_valid                  )
);

logic [LOOKUP_ADDR_WIDTH-1:0]   lut_addr;
logic                           lut_rd_en;
logic                           d1_lut_rd_en;
logic                           term_valid;
logic [BIN_ID_WIDTH-1:0]        bin_id;
logic [SEGMENT_ID_WIDTH-1:0]    segment_id;
logic [EXP_WIDTH-1:0]           r2_exp;               

logic [FLOAT_WIDTH-1:0] term_0_8;
logic [FLOAT_WIDTH-1:0] term_1_8;
logic [FLOAT_WIDTH-1:0] term_0_14;
logic [FLOAT_WIDTH-1:0] term_1_14;

logic [FLOAT_WIDTH-1:0] coeff_8;
logic [FLOAT_WIDTH-1:0] coeff_14;

assign r2_exp     = r2[MANTISSA_WIDTH+7:MANTISSA_WIDTH];
assign bin_id     = r2[MANTISSA_WIDTH-1:MANTISSA_WIDTH-BIN_ID_WIDTH];
assign segment_id = r2_exp[3:0] - 4'b0101;  // 01111111-01110101 = 10. If < 0, meaning force explodes
assign lut_rd_en  = (r2_exp[3:0] == 4'hf | r2_exp[3:0] == 4'h0) ? 1'b0 : r2_valid;    // if 01111111, meaning r2 > 1, invalidate; 
// if all 0, probably r2 = 0, invalidate
assign lut_addr   = {segment_id, bin_id};

always@(posedge clk) begin
    d1_lut_rd_en <= lut_rd_en;
    term_valid   <= d1_lut_rd_en;
    d1_r2        <= r2;
    d2_r2        <= d1_r2;
end

FORCE_LUT inst_FORCE_LUT (
    .clk            ( clk                       ),
    .addr           ( lut_addr                  ),
    .rd_en          ( lut_rd_en | d1_lut_rd_en  ),
    .data_in        ( 0                         ),
    .wr_en          ( 1'b0                      ),
    
    .term_0_8       ( term_0_8                  ),
    .term_1_8       ( term_1_8                  ),
    .term_0_14      ( term_0_14                 ),
    .term_1_14      ( term_1_14                 )
);

LJ_element_coeff inst_element_coeff (
    .i_elements     ( d25_elements  ),
    
    .o_coeff_8      ( coeff_8       ),
    .o_coeff_14     ( coeff_14      )
);

FORCE_COMPUTE inst_FORCE_COMPUTE (
    .clk            ( clk           ),
    .coeff_8        ( coeff_8       ),
    .coeff_14       ( coeff_14      ),
    .term_1_8       ( term_1_8      ),
    .term_0_8       ( term_0_8      ),
    .term_1_14      ( term_1_14     ),
    .term_0_14      ( term_0_14     ),
    .r2             ( d2_r2         ),
    .dx             ( dx            ),
    .dy             ( dy            ),
    .dz             ( dz            ),
    .term_valid     ( term_valid    ),
    
    .fx             ( home_frc[FLOAT_WIDTH-1:0]                 ),
    .fy             ( home_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]     ),
    .fz             ( home_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]   ),
    .frc_valid      ( frc_valid     )
);

assign nb_frc[FLOAT_WIDTH-1:0] = {~home_frc[FLOAT_WIDTH-1], home_frc[FLOAT_WIDTH-2:0]};
assign nb_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH] = {~home_frc[2*FLOAT_WIDTH-1], home_frc[2*FLOAT_WIDTH-2:FLOAT_WIDTH]};
assign nb_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH] = {~home_frc[3*FLOAT_WIDTH-1], home_frc[3*FLOAT_WIDTH-2:2*FLOAT_WIDTH]};

// Fake sel signal gen


partial_force_acc inst_partial_force_acc (
    .clk                    ( clk                       ),
    .rst                    ( rst                       ),
    .nb_frc_valid           ( nb_frc_valid              ),
    .nb_frc                 ( nb_frc                    ),
    .node_id                ( d36_node_id               ),  // accompanies nb_frc
    .nb_reg_sel             ( d36_nb_reg_sel            ),
    .nb_reg_release_flag    ( d36_nb_reg_release_flag   ),
    
    .nb_frc_release         ( nb_frc_acc                ),
    .node_id_release        ( frc_node_id               ),
    .nb_frc_release_valid   ( nb_frc_acc_valid          )
);

endmodule

