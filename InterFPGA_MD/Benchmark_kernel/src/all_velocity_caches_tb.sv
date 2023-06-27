`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2022 04:17:18 AM
// Design Name: 
// Module Name: all_velocity_caches_tb
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


module all_velocity_caches_tb;


logic                                                          clk;
logic                                                          rst;
logic                                                          i_MU_working;
logic  [NUM_CELLS-1:0]          [PARTICLE_ID_WIDTH-1:0]        i_MU_rd_addr;
logic  [NUM_CELLS-1:0]                                         i_MU_rd_en;
logic  [NUM_CELLS-1:0]                                         i_MU_wr_en;
float_data_t                    [NUM_CELLS-1:0]                i_MU_wr_vel;

float_data_t                    [NUM_CELLS-1:0]                o_MU_vel;
logic [NUM_CELLS-1:0]                                          o_MU_vel_valid;


always #1 clk <= ~clk;

initial begin
	clk             <= 1'b0;
    rst             <= 1'b1;
    i_MU_working    <= 1'b0;
    i_MU_rd_addr    <= 0;
    i_MU_rd_en      <= 0;
    i_MU_wr_en      <= 0;
    i_MU_wr_vel     <= 0;
    
    #10
    rst             <= 1'b0;
    
    #10
    i_MU_working    <= 1'b1;
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 0;
        i_MU_rd_en[i]      <= 1'b1;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 1;
        i_MU_wr_en[i]      <= 1'b1;
        i_MU_wr_vel[i].x   <= 32'h3f800000;
        i_MU_wr_vel[i].y   <= 32'h3f800000;
        i_MU_wr_vel[i].z   <= 32'h3f800000;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 2;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 3;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 4;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 5;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 1;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 2;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 3;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 4;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 5;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_en[i]      <= 1'b0;
    end
    
    #2
    i_MU_working           <= 1'b0;
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_wr_en[i]      <= 1'b0;
    end
    
    #2
    i_MU_working    <= 1'b1;
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 0;
        i_MU_rd_en[i]      <= 1'b1;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 1;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 2;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 3;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 4;
    end
    
    #2
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_addr[i]    <= 5;
    end
    
    #2
    i_MU_working           <= 1'b0;
    for (int i = 0; i < NUM_CELLS; i++) begin
        i_MU_rd_en[i]      <= 1'b0;
    end
end


all_velocity_caches all_vel_caches
(
    .clk                    ( clk                       ), 
    .rst                    ( rst                       ), 
	.i_MU_working           ( i_MU_working              ),
    .i_MU_rd_addr           ( i_MU_rd_addr              ), 
    .i_MU_rd_en             ( i_MU_rd_en                ), 
    .i_MU_wr_en             ( i_MU_wr_en                ),
    .i_MU_wr_vel            ( i_MU_wr_vel               ), 
    
    .o_MU_vel               ( o_MU_vel                  ),
    .o_MU_vel_valid         ( o_MU_vel_valid            )
);

endmodule
