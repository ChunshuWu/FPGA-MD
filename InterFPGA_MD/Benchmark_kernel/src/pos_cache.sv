/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module: Pos_Cache_x_y_z.v
//
//	Function:
//				Position cache with double buffering for motion update
//
//	Purpose:
//				Providing particle position data for force evaluation and motion update
//				Have a secondary buffer to hold the new data after motion update process
//				During motion update process, the motion update module will broadcast the valid data and destination cell to all cells
//				Upon receiving valid particle data, first determine if this is the target destination cell
//
// Data Organization:
//				Address 0 for each cell module: # of particles in the cell
//				Position data: MSB-LSB: {posz, posy, posx}
//				Cell address: MSB-LSB: {cell_x, cell_y, cell_z}
//
// Used by:
//
// Dependency:
//
// Testbench:
//
// Timing:
//				1 cycle reading delay from input address and output data.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module pos_cache
#(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_X[NUM_CELL_FOLDS] = '{GLOBAL_CELL_ID_WIDTH{1'h0}},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Y[NUM_CELL_FOLDS] = '{GLOBAL_CELL_ID_WIDTH{1'h0}},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Z[NUM_CELL_FOLDS] = '{GLOBAL_CELL_ID_WIDTH{1'h0}},
    parameter logic [(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:0]  REMOTE_LIFETIME
)
(
	input                                                      clk,
	input                                                      rst,
	
	input                                                      i_PE_start, 
	input                                                      i_MU_start,
	input                                                      i_MU_working,
	input                                                      i_iter_target_reached,
    input  [PARTICLE_ID_WIDTH-1:0]                             i_init_wr_addr, 
    input  [OFFSET_STRUCT_WIDTH-1:0]                           i_init_data, 
    input  [ELEMENT_WIDTH-1:0]                                 i_init_element,
    input                                                      i_init_wr_en, 
    input                                                      i_dirty,
	input  [PARTICLE_ID_WIDTH-1:0]                             i_MU_rd_addr,
	input                                                      i_MU_rd_en,
	input                                                      i_MU_wr_en,
    input  [OFFSET_STRUCT_WIDTH-1:0]                           i_MU_wr_pos, 
    input  [ELEMENT_WIDTH-1:0]                                 i_MU_wr_element,
    
    output [OFFSET_PKT_STRUCT_WIDTH-1:0]                       o_pos_pkt, 
	output [3*GLOBAL_CELL_ID_WIDTH-1:0]                        o_cur_gcid,
	output [(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:0] o_split_lifetime,
    output                                                     o_valid,
    output logic                                               o_MU_offset_valid,
    output                                                     o_dirty,
    output [PARTICLE_ID_WIDTH-1:0]                             o_debug_num_particles,
    output                                                     o_debug_all_dirty,
    output [3:0]                                               o_debug_state
);
    
    logic                               cell_phase;
    logic                               invalidate_num_output;
    logic [NUM_PARTICLES_PER_CELL-1:0]  dirty_list;
    logic [PARTICLE_ID_WIDTH-1:0]       dirty_cnt;
    logic [1:0]                         delay_cnt;
    
    logic [PARTICLE_ID_WIDTH-1:0]       num_particles;
    logic [PARTICLE_ID_WIDTH-1:0]       rd_addr;
    logic                               rd_en;
    logic                               rd_valid;
    logic [PARTICLE_ID_WIDTH-1:0]       new_particle_counter;
    
    logic [ELEMENT_WIDTH-1:0]           element;
    logic [ELEMENT_WIDTH-1:0]           element_0;
    logic [ELEMENT_WIDTH-1:0]           element_1;
    logic [OFFSET_STRUCT_WIDTH-1:0]     pos_data;
    logic [OFFSET_STRUCT_WIDTH-1:0]     pos_data_0;
    logic [OFFSET_STRUCT_WIDTH-1:0]     pos_data_1;
    logic [PARTICLE_ID_WIDTH-1:0]       pos_parid;
    logic [PARTICLE_ID_WIDTH-1:0]       dirty_parid;
    
    enum {IDLE, WAIT_FOR_PARTICLE_NUM, RD_PARTICLE_NUM, BROADCAST, MU_PROCESS, WR_PARTICLE_NUM, WAIT_FOR_WR, MU_DONE, STOP} state;
    
    assign o_pos_pkt[0 +: OFFSET_STRUCT_WIDTH]                                  = pos_data;
    assign o_pos_pkt[OFFSET_STRUCT_WIDTH +: ELEMENT_WIDTH]                      = element;
    assign o_pos_pkt[OFFSET_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH]    = pos_parid;
    assign o_valid                                                              = ~invalidate_num_output & rd_valid;
    assign o_cur_gcid                                                           = {GCELL_Z[0], GCELL_Y[0], GCELL_X[0]};
    assign o_split_lifetime                                                     = REMOTE_LIFETIME[(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:0];
    assign o_dirty                                                              = dirty_list[pos_parid];
    assign o_debug_num_particles                                                = num_particles;
    assign o_debug_all_dirty                                                    = (dirty_cnt == num_particles) & (dirty_cnt != 0); 
    assign o_debug_state                                                        = state;
    
	//////////////////////////////////////////////////////////////////////////////////////////////
	// State Machine
	//////////////////////////////////////////////////////////////////////////////////////////////
    always@(posedge clk) begin
        if (rst) begin
            cell_phase                  <= 1'b0;
            rd_addr                     <= 0;
            rd_en                       <= 1'b0;
            dirty_list                  <= 0;
            dirty_cnt                   <= 0;
            delay_cnt                   <= 0;
            num_particles               <= 0;
            invalidate_num_output       <= 1'b0;
            new_particle_counter        <= 0;
            state <= IDLE;
        end
        else begin
            case(state)
                IDLE: begin
                    new_particle_counter <= 1;
                    if (i_PE_start) begin
                        rd_en <= 1'b1;
                        state <= WAIT_FOR_PARTICLE_NUM;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                // 1 cycle delay after read request, so delay 1 cycles here. Meanwhile, keep read requesting
                WAIT_FOR_PARTICLE_NUM:	begin
                    rd_addr <= rd_addr + 1'b1;
                    invalidate_num_output <= 1'b1;		// PEs don't need to know the num of particles, prevent from being read by PEs
                    state <= RD_PARTICLE_NUM;
                end
                RD_PARTICLE_NUM: begin
                    num_particles <= pos_data[PARTICLE_ID_WIDTH-1:0];	// For addr 0, the particle num is stored in offset_x
                    invalidate_num_output <= 1'b0;
                    rd_addr <= rd_addr + 1'b1;
                    state <= BROADCAST;
                end
                // Data iteratively read from cell, from 1 to num_particles 
                BROADCAST: begin
                    if (i_dirty) begin
					    dirty_list[dirty_parid] <= 1'b1;
					    dirty_cnt <= dirty_cnt + 1'b1;
					end
					if (i_MU_start) begin
                        rd_addr <= 0;
                        rd_en <= 1'b0;
					    state <= MU_PROCESS;
					end
                    else if (i_PE_start) begin
                        if (rd_addr == num_particles) begin
                            rd_addr <= 1'b1;
                        end
                        else begin
                            rd_addr <= rd_addr + 1'b1;
                        end
                    end
                    else begin
                        rd_addr <= 0;
                        rd_en <= 1'b0;
                        state <= IDLE;
                    end
				end
                MU_PROCESS: begin
                    if (i_MU_wr_en) begin
                        new_particle_counter <= new_particle_counter + 1'b1;
                    end
                    if (i_MU_working) begin
                        state <= MU_PROCESS;
                    end
                    else begin
                        state <= WR_PARTICLE_NUM;
                        new_particle_counter <= new_particle_counter - 1'b1;
                    end
                end
                WR_PARTICLE_NUM: begin
                    new_particle_counter <= 0;
                    state <= WAIT_FOR_WR;
                end
                WAIT_FOR_WR: begin
                    delay_cnt <= delay_cnt + 1'b1;
                    if (delay_cnt == 2) begin       // Wait for a few cycles before the particle number is written
                        delay_cnt <= 0;
                        state <= MU_DONE;
                    end
                end
                MU_DONE: begin
                    new_particle_counter <= 1;
                    cell_phase <= ~cell_phase;
                    dirty_list <= 0;
                    dirty_cnt <= 0;
                    if (i_iter_target_reached) begin
                        state <= STOP;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                STOP: begin             // Debug, only check for 1 iter, tbc
                    state <= STOP;
                end
            endcase
        end
    end
    
    //////////////////////////////////////////////////////////////////////////////////////////////
    // Delay Signals
    //////////////////////////////////////////////////////////////////////////////////////////////
	
    always@(posedge clk)
        begin
        if (rst)	
            begin
            pos_parid   <= 0;
            dirty_parid <= 0;
            rd_valid    <= 1'b0;
            o_MU_offset_valid <= 1'b0;
            end
        else
            begin
            pos_parid   <= rd_addr;
            dirty_parid <= pos_parid;   // Delay 1 cycle to match pos_input_node_router
            rd_valid    <= rd_en;
            o_MU_offset_valid <= i_MU_rd_en;
            end
        end
		
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Memory Modules
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Original Cell with initial value
	
	logic [PARTICLE_ID_WIDTH-1:0]      rd_addr_0;
	logic                              rd_en_0;
	logic [PARTICLE_ID_WIDTH-1:0]      wr_addr_0;
	logic                              wr_en_0;
	logic [OFFSET_STRUCT_WIDTH-1:0]    wr_pos_0;
	logic [ELEMENT_WIDTH-1:0]          wr_element_0;
	
	logic [PARTICLE_ID_WIDTH-1:0]      rd_addr_1;
	logic                              rd_en_1;
	logic [PARTICLE_ID_WIDTH-1:0]      wr_addr_1;
	logic                              wr_en_1;
	logic [OFFSET_STRUCT_WIDTH-1:0]    wr_pos_1;
	logic [ELEMENT_WIDTH-1:0]          wr_element_1;
	
always@(*) begin		// Read and write control
	if (cell_phase == 0) begin
	    if (i_MU_wr_en) begin
            wr_en_0        = 1'b0;
            wr_addr_0      = 0;
            wr_pos_0       = 0;
            wr_element_0   = 0;
	        wr_en_1        = 1'b1;
	        wr_addr_1      = new_particle_counter;
	        wr_pos_1       = i_MU_wr_pos;
	        wr_element_1   = i_MU_wr_element;
	    end
	    else if (state == WR_PARTICLE_NUM) begin      // Write num_particles
            wr_en_0        = 1'b0;
            wr_addr_0      = 0;
            wr_pos_0       = 0;
            wr_element_0   = 0;
            wr_en_1        = 1'b1;
            wr_addr_1      = 0;
            wr_pos_1       = new_particle_counter;
            wr_element_1   = 0;
        end
        else begin
            wr_en_0        = i_init_wr_en;
            wr_addr_0      = i_init_wr_addr;
            wr_pos_0       = i_init_data;
            wr_element_0   = i_init_element;
            wr_en_1        = 1'b0;
            wr_addr_1      = 0;
            wr_pos_1       = 0;
            wr_element_1   = 0;
        end
		if (state == BROADCAST || state == WAIT_FOR_PARTICLE_NUM || state == RD_PARTICLE_NUM) begin		// 0 active + broadcast = dirty write, write to 0
			rd_en_0 = rd_en;				// Broadcast reading
			rd_addr_0 = rd_addr;
			rd_en_1 = 1'b0;
			rd_addr_1 = 0;
		end
		else begin								// 0 active + otherwise = MU write, write to 1
			rd_en_0 = i_MU_rd_en;
			rd_addr_0 = i_MU_rd_addr;
			rd_en_1 = 1'b0;
			rd_addr_1 = 0;
		end
	end
	else begin
	    if (i_MU_wr_en) begin
            wr_en_1        = 1'b0;
            wr_addr_1      = 0;
            wr_pos_1       = 0;
            wr_element_1   = 0;
	        wr_en_0        = 1'b1;
	        wr_addr_0      = new_particle_counter;
	        wr_pos_0       = i_MU_wr_pos;
	        wr_element_0   = i_MU_wr_element;
	    end
	    else if (state == WR_PARTICLE_NUM) begin      // Write num_particles
            wr_en_1        = 1'b0;
            wr_addr_1      = 0;
            wr_pos_1       = 0;
            wr_element_1   = 0;
            wr_en_0        = 1'b1;
            wr_addr_0      = 0;
            wr_pos_0       = new_particle_counter;
            wr_element_0   = 0;
        end
        else begin
            wr_en_1        = i_init_wr_en;
            wr_addr_1      = i_init_wr_addr;
            wr_pos_1       = i_init_data;
            wr_element_1   = i_init_element;
            wr_en_0        = 1'b0;
            wr_addr_0      = 0;
            wr_pos_0       = 0;
            wr_element_0   = 0;
        end
		if (state == BROADCAST || state == WAIT_FOR_PARTICLE_NUM || state == RD_PARTICLE_NUM) begin		// 1 active + broadcast = dirty write, write to 1
			rd_en_1        = rd_en;
			rd_addr_1      = rd_addr;
			rd_en_0        = 1'b0;
			rd_addr_0      = 0;
		end
		else begin								// 1 active + otherwise = MU write, write to 0
			rd_en_1        = i_MU_rd_en;
			rd_addr_1      = i_MU_rd_addr;
			rd_en_0        = 1'b0;
			rd_addr_0      = 0;
		end
	end
end

assign element  = (cell_phase) ? element_1 : element_0;
assign pos_data = (cell_phase) ? pos_data_1 : pos_data_0;
	
	POS_CACHE cell_0 (
		.clk(clk), 
		.i_data       ( {1'b0, wr_element_0, wr_pos_0}       ), 
		.i_rd_en      ( rd_en_0                   ), 
		.i_rd_addr    ( rd_addr_0                 ), 
		.i_wr_en      ( wr_en_0                   ), 
		.i_wr_addr    ( wr_addr_0                 ), 
		
		.o_data       ( {element_0, pos_data_0}   )
	);
	
	POS_CACHE cell_1 (
		.clk(clk), 
		.i_data       ( {1'b0, wr_element_1, wr_pos_1}       ), 
		.i_rd_en      ( rd_en_1                   ), 
		.i_rd_addr    ( rd_addr_1                 ), 
		.i_wr_en      ( wr_en_1                   ), 
		.i_wr_addr    ( wr_addr_1                 ), 
		
		.o_data       ( {element_1, pos_data_1}   )
	);

endmodule	
