package MD_pkg;

localparam integer AXIS_TDATA_WIDTH = 512;
localparam integer STREAMING_TDEST_WIDTH = 16;
localparam integer UINT8_WIDTH = 8;
localparam integer SUB_PACKET_WIDTH = 128;
localparam integer NUM_SUB_PACKETS = AXIS_TDATA_WIDTH / SUB_PACKET_WIDTH;
localparam integer INIT_STEP_WIDTH = 4;
localparam integer TDEST_WIDTH     = 16;

localparam X_DIM = 3;
localparam Y_DIM = 3;
localparam Z_DIM = 3;
localparam NUM_CELLS = X_DIM * Y_DIM * Z_DIM;
localparam NUM_INIT_STEPS = (NUM_CELLS+NUM_SUB_PACKETS-1) / NUM_SUB_PACKETS; // Ceiling of NUM_CELLS / NUM_SUB_PACKETS
localparam int INIT_NUM_PARTICLES [(NUM_CELLS+NUM_SUB_PACKETS-1) / NUM_SUB_PACKETS * NUM_SUB_PACKETS] = 
                                                '{15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 
                                                  15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 
                                                  15, 15, 15, 15, 15, 15, 15, 0};

/*localparam int INIT_NUM_PARTICLES [(NUM_CELLS+NUM_SUB_PACKETS-1) / NUM_SUB_PACKETS * NUM_SUB_PACKETS] = 
                                                '{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
                                                  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
                                                  1, 1, 1, 1, 1, 1, 1, 0};*/

localparam NUM_PARTICLES_PER_CELL = 128;
localparam NUM_PARTICLES_PER_RAM = 512;
localparam FLOAT_WIDTH = 32;
localparam OFFSET_WIDTH = 23;
localparam CELL_ID_WIDTH = 2;
localparam GLOBAL_CELL_ID_WIDTH = 3;//$clog2(X_DIM);

localparam MU_ID_WIDTH = $clog2(NUM_CELLS);

localparam MANTISSA_WIDTH = 23;
localparam EXP_WIDTH = 8;
localparam EXP_0 = 8'b01111111;     // For fixed-float conversion
localparam EXP_1 = 8'b10000000;     // For fixed-float conversion
localparam BODY_BITS = 8;			// Including 1 bit integer part
localparam DATA_WIDTH = OFFSET_WIDTH + CELL_ID_WIDTH;
localparam PARTICLE_ID_WIDTH = 9;
localparam ELEMENT_WIDTH = 2;
localparam NUM_FILTERS = 6;
localparam FILTER_IDX_WIDTH = $clog2(NUM_FILTERS);
localparam NUM_FILTER_SOURCES = (NUM_FILTERS+1)/2;
localparam COOLDOWN_WIDTH = 3;
localparam NUM_COOLDOWN_CYCLES = 3;
localparam NUM_NB_CELLS = 14;

localparam NUM_DEST_CELLS = 14; // 8

localparam NB_CELL_COUNT_WIDTH = $clog2(NUM_NB_CELLS);

// Each PE processes multiple cells, not being used for now
localparam NUM_CELL_FOLDS = 1;       // Num of cells a PE processes
localparam CELL_FOLD_ID_WIDTH = $clog2(NUM_CELL_FOLDS);

// Each MU processes multiple cells, not being used for now
localparam NUM_CELLS_PER_MU = 4;
localparam NUM_MU = (NUM_CELLS+NUM_CELLS_PER_MU-1) / NUM_CELLS_PER_MU; // Ceiling of NUM_CELLS / NUM_CELLS_PER_MU
localparam MU_COUNT_WIDTH = $clog2(NUM_MU); 
localparam CELL_COUNT_WIDTH = $clog2(NUM_CELLS_PER_MU); 

localparam REDUCED_TIME_STEP = 32'h37A7C5AC;
localparam X_DIFF_WIDTH = $clog2(X_DIM*Y_DIM*Z_DIM)+1; 		// +1 for sign
localparam Y_DIFF_WIDTH = $clog2(Y_DIM*Z_DIM)+1;
localparam Z_DIFF_WIDTH = $clog2(Z_DIM)+1;

localparam SEGMENT_NUM = 10;
localparam SEGMENT_ID_WIDTH = 4;
localparam BIN_NUM = 256;
localparam BIN_ID_WIDTH = 8;
localparam LOOKUP_NUM = SEGMENT_NUM * BIN_NUM;						// SEGMENT_NUM * BIN_NUM
localparam LOOKUP_ADDR_WIDTH = SEGMENT_ID_WIDTH + BIN_ID_WIDTH;	// log LOOKUP_NUM / log 2

localparam NA_NA_COEFF_14 = 32'h2FC7FCA7;		// epsilon*sigma^12/cutoff^14
localparam NA_CL_COEFF_14 = 32'h32838DC6;
localparam CL_CL_COEFF_14 = 32'h3468B84F;
localparam NA_NA_COEFF_8 = 32'h35A405B7;		// epsilon*sigma^6/cutoff^8
localparam NA_CL_COEFF_8 = 32'h36D4842C;
localparam CL_CL_COEFF_8 = 32'h379FA4B0;

localparam NA_COEFF = 32'h3CBC550A;		       // mass * Avogadro, 0.023      for MU
localparam CL_COEFF = 32'h3D11372A;		       // 0.0355       for MU

localparam logic [1:0] CELL_2 = 2'b10; 

typedef struct packed{
	logic [DATA_WIDTH-1:0] pos_z;
	logic [DATA_WIDTH-1:0] pos_y;
	logic [DATA_WIDTH-1:0] pos_x;
} pos_data_t;
localparam POS_STRUCT_WIDTH = 3*DATA_WIDTH;

typedef struct packed{
	pos_data_t pos;
	logic [PARTICLE_ID_WIDTH-1:0] parid;
	logic [ELEMENT_WIDTH-1:0] element;
} pos_packet_t;
localparam POS_PKT_STRUCT_WIDTH = POS_STRUCT_WIDTH+PARTICLE_ID_WIDTH+ELEMENT_WIDTH;

typedef struct packed{
	logic [OFFSET_WIDTH-1:0] offset_z;
	logic [OFFSET_WIDTH-1:0] offset_y;
	logic [OFFSET_WIDTH-1:0] offset_x;
} offset_data_t;
localparam OFFSET_STRUCT_WIDTH = 3*OFFSET_WIDTH;

typedef struct packed{
	offset_data_t offset;
	logic [PARTICLE_ID_WIDTH-1:0] parid;
	logic [ELEMENT_WIDTH-1:0] element;
} offset_packet_t;
localparam OFFSET_PKT_STRUCT_WIDTH = OFFSET_STRUCT_WIDTH+PARTICLE_ID_WIDTH+ELEMENT_WIDTH;

typedef struct packed{
	logic [FLOAT_WIDTH-1:0] z;
	logic [FLOAT_WIDTH-1:0] y;
	logic [FLOAT_WIDTH-1:0] x;
} float_data_t;
localparam FLOAT_STRUCT_WIDTH = 3*FLOAT_WIDTH;

typedef struct packed{
	float_data_t f;
	logic [PARTICLE_ID_WIDTH-1:0] parid;
	logic [3*CELL_ID_WIDTH-1:0] cid;
	//logic [ELEMENT_WIDTH-1:0] element;	(DON'T NEED ELEMENT INFO IN FORCE CACHES)
} force_packet_t;
localparam FRC_PKT_STRUCT_WIDTH = FLOAT_STRUCT_WIDTH+PARTICLE_ID_WIDTH+3*CELL_ID_WIDTH;

typedef struct packed{
	offset_data_t offset;
	float_data_t vel;
	logic [ELEMENT_WIDTH-1:0] element;
	logic [MU_ID_WIDTH-1:0] dst_MU_id;
} MU_packet_t;
localparam MU_PKT_STRUCT_WIDTH = OFFSET_STRUCT_WIDTH+FLOAT_STRUCT_WIDTH+ELEMENT_WIDTH+MU_ID_WIDTH;

typedef struct packed{
    logic [AXIS_TDATA_WIDTH-1:0] data;
    logic valid;
    logic [15:0] dest;
} pos_ring_packet_t;

typedef struct packed{
    logic [AXIS_TDATA_WIDTH-1:0] tdata;
    logic tlast;
    logic tvalid;
    logic [STREAMING_TDEST_WIDTH-1:0] tdest;
    logic [AXIS_TDATA_WIDTH/8-1:0] tkeep;
} axi_packet_t;
localparam AXIS_PKT_STRUCT_WIDTH = AXIS_TDATA_WIDTH+STREAMING_TDEST_WIDTH+AXIS_TDATA_WIDTH/8+2;


`define FORCE_LUT_LINEAR_INSTANCE(ORDER, TERM) \
FORCE_LUT_LINEAR                                       	\
#(                                       	\
    .C_INIT_FILE_NAME(`"/ad/eng/research/eng_research_caad/Chunshu/OPT_MD_XILINX/OPT_MD_XILINX.srcs/sources_1/meminit/c``ORDER``_``TERM``.mif`") \
    //.C_INIT_FILE_NAME(`"/ad/eng/research/eng_research_caad/Chunshu/OPT_MD_XILINX/OPT_MD_XILINX.srcs/sources_1/ip/FORCE_LUT_LINEAR/FORCE_LUT_LINEAR.mif`") \
)                                       	\
force_lut_``ORDER``_``TERM``                                        	\
(      																									\
    .clka(clk),     \
    .addra(lut_addr),  \
    .dina(),    \
    .douta(term_``ORDER``_``TERM``),  \
    .ena(enable | enable_delay_1),  \
    .wea(1'b0)  \
);

`define VELOCITY_CACHE_INSTANCE(X, Y, Z)                       \
velocity_cache velocity_cache_``X``_``Y``_``Z``                               \
(                                                                          \
	.clk(clk),                                                               \
	.rst(rst),                                                               \
    .i_MU_start(i_MU_start),  \
	.i_MU_working(i_MU_working),                    							          \
	.i_MU_rd_addr(i_MU_rd_addr[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]),       			                                     \
	.i_MU_rd_en(i_MU_rd_en[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]),              \
																									 \
	.i_MU_wr_en(i_MU_wr_en[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]),                                                 \
	.i_MU_wr_vel(i_MU_wr_vel[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]),	                                        \
																									 \
	.o_MU_vel(o_MU_vel[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
	.o_MU_vel_valid(o_MU_vel_valid[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]) \
);

`define POS_CACHE_INSTANCE(X, Y, Z)                                                 \
pos_cache                                     	                                    \
#(                                       	                                        \
    .GCELL_X({X}),                                                                  \
    .GCELL_Y({Y}),                                                                  \
    .GCELL_Z({Z})                                                                   \
)                                       	                                        \
pos_cache_``X``_``Y``_``Z``                                        	                \
(                                                                                   \
    .clk(clk),                                                       				\
    .rst(rst),                                                       				\
                                                                                    \
    .i_PE_start(i_PE_start),  \
    .i_MU_start(i_MU_start),  \
    .i_MU_working(i_MU_working),  \
    .i_iter_target_reached(i_iter_target_reached),  \
    .i_init_wr_addr(i_init_wr_addr), \
    .i_init_data(i_init_data[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
    .i_init_element(i_init_element[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
    .i_init_wr_en(i_init_wr_en[(X*Y_DIM*Z_DIM + Y*Z_DIM + Z)/NUM_SUB_PACKETS]), \
    .i_dirty(i_dirty[(X*Y_DIM*Z_DIM + Y*Z_DIM + Z)]), \
    .i_MU_rd_addr(i_MU_rd_addr[(X*Y_DIM*Z_DIM + Y*Z_DIM + Z)]), \
    .i_MU_rd_en(i_MU_rd_en[(X*Y_DIM*Z_DIM + Y*Z_DIM + Z)]), \
    .i_MU_wr_en(i_MU_wr_en[(X*Y_DIM*Z_DIM + Y*Z_DIM + Z)]), \
    .i_MU_wr_pos(i_MU_wr_pos[(X*Y_DIM*Z_DIM + Y*Z_DIM + Z)]), \
    .i_MU_wr_element(i_MU_wr_element[(X*Y_DIM*Z_DIM + Y*Z_DIM + Z)]), \
                                                                    \
    .o_pos_pkt(o_pos_pkt[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
    .o_cur_gcid(o_cur_gcid[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
    .o_valid(o_valid[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
    .o_MU_offset_valid(o_MU_offset_valid[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
    .o_dirty(o_dirty[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
    .o_debug_num_particles(o_debug_num_particles[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
    .o_debug_all_dirty(o_debug_all_dirty[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]), \
    .o_debug_state(o_debug_state[X*Y_DIM*Z_DIM + Y*Z_DIM + Z]) \
);                                                                      
endpackage
