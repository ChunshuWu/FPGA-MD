`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2022 12:57:49 PM
// Design Name: 
// Module Name: dump_pos
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

module dump_pos(
    input                                clk, 
    input                                rst, 
    input                                dump_start, 
    input        [INIT_STEP_WIDTH-1:0]   dump_step,
    
    output logic [NUM_INIT_STEPS-1:0]    dump_rd_en, 
    output logic [PARTICLE_ID_WIDTH-1:0] dump_rd_addr
);

logic                         d1_dump_start;
logic [NUM_INIT_STEPS-1:0]    d1_dump_step;
logic dump_start_pulse;
logic dump_step_pulse;
assign dump_start_pulse = dump_start != d1_dump_start;
assign dump_step_pulse = dump_step != d1_dump_step;
enum {DUMP, IDLE} dump_state;

always@(posedge clk) begin
    if (rst) begin
        dump_rd_addr     <= 0;
        dump_rd_en       <= 0;
        dump_state       <= IDLE;
    end
    else begin
        if (dump_start) begin
            case (dump_state)
                DUMP: begin
                    if (dump_rd_addr == NUM_PARTICLES_PER_CELL-1) begin
                        dump_rd_addr <= 0;
                        dump_rd_en <= 0;
                        dump_state <= IDLE;
                    end
                    else begin
                        dump_rd_addr <= dump_rd_addr+1;
                        dump_rd_en <= 1 << dump_step;
                        dump_state <= DUMP;
                    end
                end
                IDLE: begin
                    if (dump_step_pulse | dump_start_pulse) begin
                        dump_rd_addr <= 0;
                        dump_rd_en <= 1 << dump_step;
                        dump_state <= DUMP;
                    end
                    else begin
                        dump_rd_addr <= 0;
                        dump_rd_en <= 0;
                        dump_state <= IDLE;
                    end
                end
            endcase
        end
        else begin
            dump_rd_addr     <= 0;
            dump_rd_en       <= 0;
        end
    end
end

always@(posedge clk) begin
    d1_dump_step <= dump_step;
    d1_dump_start <= dump_start;
end

endmodule
