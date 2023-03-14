//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2022 09:30:02 PM
// Design Name: 
// Module Name: check_pos_input_ring_target_hit
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

module check_pos_input_ring_target_hit
#(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_X[NUM_CELL_FOLDS] = '{3'h0}, // Must have the same order as fold id
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Y[NUM_CELL_FOLDS] = '{3'h0}, 
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Z[NUM_CELL_FOLDS] = '{3'h0}
)
(
    input [3*GLOBAL_CELL_ID_WIDTH-1:0] i_gcid, 
    
    output logic o_hit
    //output logic [CELL_FOLD_ID_WIDTH-1:0] o_fold_id
);

typedef logic [GLOBAL_CELL_ID_WIDTH-1:0] target_gcid_t [NUM_CELL_FOLDS][NUM_NB_CELLS-1];
function target_gcid_t target_gcid_val_x();
  for (int i = 0; i < NUM_CELL_FOLDS; i++)
    begin
    target_gcid_val_x[i][0] = GCELL_X[i]; 
    target_gcid_val_x[i][1] = GCELL_X[i]; 
    target_gcid_val_x[i][2] = GCELL_X[i]; 
    target_gcid_val_x[i][3] = GCELL_X[i]; 
    target_gcid_val_x[i][4] = (GCELL_X[i]+X_DIM-1) % X_DIM; 
    target_gcid_val_x[i][5] = (GCELL_X[i]+X_DIM-1) % X_DIM; 
    target_gcid_val_x[i][6] = (GCELL_X[i]+X_DIM-1) % X_DIM; 
    target_gcid_val_x[i][7] = (GCELL_X[i]+X_DIM-1) % X_DIM; 
    target_gcid_val_x[i][8] = (GCELL_X[i]+X_DIM-1) % X_DIM; 
    target_gcid_val_x[i][9] = (GCELL_X[i]+X_DIM-1) % X_DIM; 
    target_gcid_val_x[i][10] = (GCELL_X[i]+X_DIM-1) % X_DIM; 
    target_gcid_val_x[i][11] = (GCELL_X[i]+X_DIM-1) % X_DIM; 
    target_gcid_val_x[i][12] = (GCELL_X[i]+X_DIM-1) % X_DIM; 
    end
endfunction : target_gcid_val_x

function target_gcid_t target_gcid_val_y();
  for (int i = 0; i < NUM_CELL_FOLDS; i++)
    begin
    target_gcid_val_y[i][0] = GCELL_Y[i];
    target_gcid_val_y[i][1] = (GCELL_Y[i]+Y_DIM-1) % Y_DIM; 
    target_gcid_val_y[i][2] = (GCELL_Y[i]+Y_DIM-1) % Y_DIM; 
    target_gcid_val_y[i][3] = (GCELL_Y[i]+Y_DIM-1) % Y_DIM;
    target_gcid_val_y[i][4] = (GCELL_Y[i]+1) % Y_DIM;
    target_gcid_val_y[i][5] = (GCELL_Y[i]+1) % Y_DIM; 
    target_gcid_val_y[i][6] = (GCELL_Y[i]+1) % Y_DIM;
    target_gcid_val_y[i][7] = GCELL_Y[i];
    target_gcid_val_y[i][8] = GCELL_Y[i];
    target_gcid_val_y[i][9] = GCELL_Y[i];
    target_gcid_val_y[i][10] = (GCELL_Y[i]+Y_DIM-1) % Y_DIM; 
    target_gcid_val_y[i][11] = (GCELL_Y[i]+Y_DIM-1) % Y_DIM; 
    target_gcid_val_y[i][12] = (GCELL_Y[i]+Y_DIM-1) % Y_DIM;
    end
endfunction : target_gcid_val_y

function target_gcid_t target_gcid_val_z();
  //target_gcid_t target_value;
  for (int i = 0; i < NUM_CELL_FOLDS; i++)
    begin
    target_gcid_val_z[i][0] = (GCELL_Z[i]+Z_DIM-1) % Z_DIM;                     // 223
    target_gcid_val_z[i][1] = (GCELL_Z[i]+1) % Z_DIM;                           // 231
    target_gcid_val_z[i][2] = GCELL_Z[i];                                       // 232
    target_gcid_val_z[i][3] = (GCELL_Z[i]+Z_DIM-1) % Z_DIM;                     // 233 
    target_gcid_val_z[i][4] = (GCELL_Z[i]+1) % Z_DIM;                           // 311
    target_gcid_val_z[i][5] = GCELL_Z[i];                                       // 312
    target_gcid_val_z[i][6] = (GCELL_Z[i]+Z_DIM-1) % Z_DIM;                     // 313
    target_gcid_val_z[i][7] = (GCELL_Z[i]+1) % Z_DIM;                           // 321
    target_gcid_val_z[i][8] = GCELL_Z[i];                                       // 322
    target_gcid_val_z[i][9] = (GCELL_Z[i]+Z_DIM-1) % Z_DIM;                     // 323 
    target_gcid_val_z[i][10] = (GCELL_Z[i]+1) % Z_DIM;                          // 331
    target_gcid_val_z[i][11] = GCELL_Z[i];                                      // 332
    target_gcid_val_z[i][12] = (GCELL_Z[i]+Z_DIM-1) % Z_DIM;                    // 333
    end
endfunction : target_gcid_val_z
localparam logic [GLOBAL_CELL_ID_WIDTH-1:0] TARGET_GCID_X [NUM_CELL_FOLDS][NUM_NB_CELLS-1] = target_gcid_val_x();
localparam logic [GLOBAL_CELL_ID_WIDTH-1:0] TARGET_GCID_Y [NUM_CELL_FOLDS][NUM_NB_CELLS-1] = target_gcid_val_y();
localparam logic [GLOBAL_CELL_ID_WIDTH-1:0] TARGET_GCID_Z [NUM_CELL_FOLDS][NUM_NB_CELLS-1] = target_gcid_val_z();
    
logic [GLOBAL_CELL_ID_WIDTH-1:0] gcid_x;
logic [GLOBAL_CELL_ID_WIDTH-1:0] gcid_y;
logic [GLOBAL_CELL_ID_WIDTH-1:0] gcid_z;

assign gcid_x = i_gcid[GLOBAL_CELL_ID_WIDTH-1:0];
assign gcid_y = i_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH];
assign gcid_z = i_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH];

always@(*)
    begin
    o_hit = 0;
    //o_fold_id = 0;
    for (int i = 0; i < NUM_CELL_FOLDS; i++)
        begin
        for (int j = 0; j < NUM_NB_CELLS-1; j++)
            begin
            if (gcid_x == TARGET_GCID_X[i][j]
             && gcid_y == TARGET_GCID_Y[i][j]
             && gcid_z == TARGET_GCID_Z[i][j])
                begin
                o_hit = 1;
                //o_fold_id = i;
                end
            end
        end
    end


endmodule
