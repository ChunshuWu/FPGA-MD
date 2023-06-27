//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 09:59:06 PM
// Design Name: 
// Module Name: pos_input_ring_node_tb
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

module pos_input_ring_tb;


logic                           clk;
logic                           rst;

pos_packet_t [NUM_CELLS-1:0]    nb_pos_pkt;
logic        [NUM_CELLS-1:0]    nb_pos_pkt_valid;
logic        [NUM_CELLS-1:0]    disp_back_pressure;

logic           [NUM_CELLS-1:0]                                         dirty_feedback;
offset_packet_t [NUM_CELLS-1:0]                                         raw_offset_pkt;
logic           [NUM_CELLS-1:0]         [3*GLOBAL_CELL_ID_WIDTH-1:0]    cur_gcid;
logic           [NUM_CELLS-1:0]                                         raw_offset_valid;
logic           [NUM_CELLS-1:0]                                         raw_offset_dirty;

always@(posedge clk) begin
    if (rst) begin
        for (int i = 0; i < NUM_CELLS; i++) begin
           raw_offset_pkt[i].offset.offset_x <= 0;
           raw_offset_pkt[i].offset.offset_y <= 0;
           raw_offset_pkt[i].offset.offset_z <= 0;
           raw_offset_pkt[i].element <= 0;
           raw_offset_pkt[i].parid <= 0;
           raw_offset_valid[i] <= 0;
           cur_gcid[i] <= 0;
           raw_offset_dirty[i] <= 0;
           disp_back_pressure <= 0;
        end
    end
    else begin
        cur_gcid[0] <= 9'b000000000;        // ZYX
        cur_gcid[1] <= 9'b001000000;
        cur_gcid[2] <= 9'b000001000;
        cur_gcid[3] <= 9'b001001000;
        cur_gcid[4] <= 9'b000000001;
        cur_gcid[5] <= 9'b001000001;
        cur_gcid[6] <= 9'b000001001;
        cur_gcid[7] <= 9'b001001001;
        for (int i = 0; i < NUM_CELLS; i++) begin
            raw_offset_pkt[i].element <= 1;
            raw_offset_valid[i] <= 1;
            if (raw_offset_pkt[i].offset.offset_x == 23'h780000) begin
                raw_offset_pkt[i].offset.offset_x <= 23'h080000;
                raw_offset_pkt[i].offset.offset_y <= 23'h080000;
                raw_offset_pkt[i].offset.offset_z <= 23'h080000;
                raw_offset_pkt[i].parid <= 1;
            end
            else begin
                raw_offset_pkt[i].offset.offset_x <= raw_offset_pkt[i].offset.offset_x + 23'h080000;
                raw_offset_pkt[i].offset.offset_y <= raw_offset_pkt[i].offset.offset_y + 23'h080000;
                raw_offset_pkt[i].offset.offset_z <= raw_offset_pkt[i].offset.offset_z + 23'h080000;
                raw_offset_pkt[i].parid <= raw_offset_pkt[i].parid + 1;
            end
        end
    end
end

always #1 clk <= ~clk;
initial begin
	clk <= 1'b0;
	rst <= 1'b1;
	
	#10
	rst <= 1'b0;
	
	#100
	raw_offset_dirty <= 8'hff;
end


pos_input_ring inst_pos_input_ring (
    .clk                        ( clk                   ), 
    .rst                        ( rst                   ),
    .local_offset_pkt           ( raw_offset_pkt        ),
    .local_gcid                 ( cur_gcid              ),
    .local_valid                ( raw_offset_valid      ),
    .local_dirty                ( raw_offset_dirty      ),
    .dispatcher_back_pressure   ( disp_back_pressure    ),
    
    .pos_pkt_to_pe              ( nb_pos_pkt            ),
    .pos_pkt_to_pe_valid        ( nb_pos_pkt_valid      ),
    .dirty_feedback             ( dirty_feedback        )
);

endmodule
