/************************************************
Copyright (c) 2020, Xilinx, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software 
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.// Copyright (c) 2020 Xilinx, Inc.
************************************************/

`timescale 1 ns / 1 ps
`default_nettype wire

module axi4lite # (
    // Width of S_AXIL data bus
    parameter integer AXIL_DATA_WIDTH    = 32,
    // Width of S_AXIL address bus
    parameter integer AXIL_ADDR_WIDTH    =  9,
    // Width of TDEST address bus
    parameter integer STREAMING_TDEST_WIDTH = 16,
    // User customized
    parameter integer INIT_STEP_WIDTH       =   4,
    parameter integer PARTICLE_ID_WIDTH     =   9
)
(
    // Global Clock Signal
    input wire                                  S_AXIL_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input wire                                  S_AXIL_ARESETN,
    // Write address (issued by master, accepted by Slave)
    input wire [AXIL_ADDR_WIDTH-1 : 0]          S_AXIL_AWADDR,
    // Write address valid. This signal indicates that the master signaling
        // valid write address and control information.
    input wire                                  S_AXIL_AWVALID,
    // Write address ready. This signal indicates that the slave is ready
        // to accept an address and associated control signals.
    output wire                                 S_AXIL_AWREADY,
    // Write data (issued by master, accepted by Slave) 
    input wire [AXIL_DATA_WIDTH-1 : 0]          S_AXIL_WDATA,
    // Write strobes. This signal indicates which byte lanes hold
        // valid data. There is one write strobe bit for each eight
        // bits of the write data bus.    
    input wire [(AXIL_DATA_WIDTH/8)-1 : 0]      S_AXIL_WSTRB,
    // Write valid. This signal indicates that valid write
        // data and strobes are available.
    input wire                                  S_AXIL_WVALID,
    // Write ready. This signal indicates that the slave
        // can accept the write data.
    output wire                                 S_AXIL_WREADY,
    // Write response. This signal indicates the status
        // of the write transaction.
    output wire [1 : 0]                         S_AXIL_BRESP,
    // Write response valid. This signal indicates that the channel
        // is signaling a valid write response.
    output wire                                 S_AXIL_BVALID,
    // Response ready. This signal indicates that the master
        // can accept a write response.
    input wire                                  S_AXIL_BREADY,
    // Read address (issued by master, accepted by Slave)
    input wire [AXIL_ADDR_WIDTH-1 : 0]          S_AXIL_ARADDR,
    // Read address valid. This signal indicates that the channel
        // is signaling valid read address and control information.
    input wire                                  S_AXIL_ARVALID,
    // Read address ready. This signal indicates that the slave is
        // ready to accept an address and associated control signals.
    output wire                                 S_AXIL_ARREADY,
    // Read data (issued by slave)
    output wire [AXIL_DATA_WIDTH-1 : 0]         S_AXIL_RDATA,
    // Read response. This signal indicates the status of the
        // read transfer.
    output wire [1 : 0]                         S_AXIL_RRESP,
    // Read valid. This signal indicates that the channel is
        // signaling the required read data.
    output wire                                 S_AXIL_RVALID,
    // Read ready. This signal indicates that the master can
        // accept the read data and response information.
    input wire                                  S_AXIL_RREADY,

    input wire                                  ap_done,
    input wire                                  ap_idle,
    output wire                                 ap_start,
    output wire   [STREAMING_TDEST_WIDTH-1:0]   dest_id,
    output wire   [STREAMING_TDEST_WIDTH-1:0]   init_id,
    output wire                        [31:0]   number_packets,
    output wire         [INIT_STEP_WIDTH-1:0]   dump_bank_sel,
    output wire                         [2:0]   MD_state,
    output wire                        [31:0]   iter_target,
    output wire                                 debug_reset_n,
    output wire                                 reset_fsm_n,
    input wire                        [191:0]   debug_slot_producer_pos,
    input wire                        [191:0]   debug_slot_producer_frc,
    input wire                        [191:0]   debug_slot_consumer_pos,
    input wire                        [191:0]   debug_slot_consumer_frc,
    input wire                                  debug_fifo_pos_full,
    input wire                                  debug_fifo_frc_full,
//    input wire        [PARTICLE_ID_WIDTH-1:0]   debug_num_particles,
    input wire                                  debug_all_dirty,
    input wire                                  debug_disp_back_pressure,
    input wire                                  debug_home_buf_almost_full,
    input wire                                  debug_nb_buf_almost_full,
    input wire                                  debug_all_frc_output_ring_buf_empty,
    input wire                                  debug_all_frc_output_ring_done,
    input wire                                  debug_all_home_buf_empty,
    input wire                                  debug_all_nb_buf_empty,
    input wire                                  debug_all_disp_buf_empty,
    input wire                                  debug_all_MU_buf_empty,
    input wire                                  debug_MU_spinning,
    input wire                                  debug_MU_reading,
    input wire                                  debug_MU_writing,
    input wire                                  debug_MU_busy,
    input wire [4:0]                            debug_MU_busy_cnt,
    input wire [3:0]                            debug_pos_state,
    input wire                                  debug_MU_started,
    input wire                                  debug_MU_frc_once_valid,
    input wire                                  debug_MU_offset_once_valid,
    input wire                                  debug_MU_vel_once_valid,
    input wire                                  debug_MU_once_writing,
    input wire                                  debug_MU_once_reading,
    input wire                                  debug_chk_nb_frc,
    input wire                                  debug_chk_home_frc,
    input wire                                  debug_chk_MU_vel_out,
    input wire                                  debug_chk_MU_vel_produced,
    input wire                                  debug_chk_MU_offset_in,
    input wire [PARTICLE_ID_WIDTH-1:0]          debug_MU_num_particles,
    input wire [PARTICLE_ID_WIDTH-1:0]          debug_MU_rd_cnt,
    input wire [31:0]                           debug_iter_cnt,
    input wire [31:0]                           debug_operation_cycle_cnt,
    input wire                                  debug_MU_migration,
    input wire [31:0]                           debug_num_particles_0,
    input wire [31:0]                           debug_num_particles_1,
    input wire [31:0]                           debug_num_particles_2,
    input wire [31:0]                           debug_num_particles_3,
    input wire [31:0]                           debug_num_particles_4,
    input wire [31:0]                           debug_num_particles_5,
    input wire [31:0]                           debug_num_particles_6,
    input wire [31:0]                           debug_num_particles_7,
    input wire [31:0]                           debug_num_particles_8,
    input wire [31:0]                           debug_num_particles_9,
    input wire [31:0]                           debug_num_particles_10,
    input wire [31:0]                           debug_num_particles_11,
    input wire [31:0]                           debug_num_particles_12,
    input wire [31:0]                           debug_num_particles_13,
    input wire [31:0]                           debug_num_particles_14,
    input wire [31:0]                           debug_num_particles_15,
    input wire [31:0]                           debug_num_particles_16,
    input wire [31:0]                           debug_num_particles_17,
    input wire [31:0]                           debug_num_particles_18,
    input wire [31:0]                           debug_num_particles_19,
    input wire [31:0]                           debug_num_particles_20,
    input wire [31:0]                           debug_num_particles_21,
    input wire [31:0]                           debug_num_particles_22,
    input wire [31:0]                           debug_num_particles_23,
    input wire [31:0]                           debug_num_particles_24,
    input wire [31:0]                           debug_num_particles_25,
    input wire [31:0]                           debug_num_particles_26,
    input wire [INIT_STEP_WIDTH-1:0]            debug_init_step,
    input wire [PARTICLE_ID_WIDTH-1:0]          debug_init_wr_addr,
    input wire [31:0]                           debug_first_migration_iter,
    input wire [31:0]                           debug_first_anomaly_nop_iter
);

    // AXI4LITE signals
    reg [AXIL_ADDR_WIDTH-1 : 0]  axi_awaddr;
    reg     axi_awready;
    reg     axi_wready;
    reg [1 : 0]     axi_bresp;
    reg     axi_bvalid;
    reg [AXIL_ADDR_WIDTH-1 : 0]  axi_araddr;
    reg     axi_arready;
    reg [AXIL_DATA_WIDTH-1 : 0]  axi_rdata;
    reg [1 : 0]     axi_rresp;
    reg     axi_rvalid;

    // Example-specific design signals
    // local parameter for addressing 32 bit / 64 bit AXIL_DATA_WIDTH
    // ADDR_LSB is used for addressing 32/64 bit registers/memories
    // ADDR_LSB = 2 for 32 bits (n downto 2)
    // ADDR_LSB = 3 for 64 bits (n downto 3)
    localparam integer ADDR_LSB = (AXIL_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 6;
    //----------------------------------------------
    //-- Signals for user logic register space example
    //------------------------------------------------
    //-- Number of Slave Registers 32
    reg [AXIL_DATA_WIDTH-1:0]    ctrl_signals = 32'h0;
    reg [AXIL_DATA_WIDTH-1:0]    outbound_dest_reg = 32'h0;
    reg [AXIL_DATA_WIDTH-1:0]    num_pkts_lsb_reg = 32'h0;
    reg [AXIL_DATA_WIDTH-1:0]    num_pkts_msb_reg = 32'h0;
    reg [AXIL_DATA_WIDTH-1:0]    MD_state_reg = 32'h0;
    reg [AXIL_DATA_WIDTH-1:0]    iter_target_reg = 32'h0;
    reg [AXIL_DATA_WIDTH-1:0]    init_id_reg = 32'h0;
    reg [AXIL_DATA_WIDTH-1:0]    dump_bank_sel_reg = 32'h0;
    reg [AXIL_DATA_WIDTH-1:0]    reset_fsm = 32'h0;
    reg [AXIL_DATA_WIDTH-1:0]    debug_reset_reg = 32'h0;
    wire     slv_reg_rden;
    wire     slv_reg_wren;
    reg [AXIL_DATA_WIDTH-1:0]     reg_data_out;
    integer  byte_index;
    reg  aw_en;

    // I/O Connections assignments

    assign S_AXIL_AWREADY    = axi_awready;
    assign S_AXIL_WREADY     = axi_wready;
    assign S_AXIL_BRESP      = axi_bresp;
    assign S_AXIL_BVALID     = axi_bvalid;
    assign S_AXIL_ARREADY    = axi_arready;
    assign S_AXIL_RDATA      = axi_rdata;
    assign S_AXIL_RRESP      = axi_rresp;
    assign S_AXIL_RVALID     = axi_rvalid;

    // Implement axi_awready generation
    // axi_awready is asserted for one S_AXIL_ACLK clock cycle when both
    // S_AXIL_AWVALID and S_AXIL_WVALID are asserted. axi_awready is
    // de-asserted when reset is low.
    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            axi_awready <= 1'b0;
            aw_en <= 1'b1;
        end 
        else begin    
            if (~axi_awready && S_AXIL_AWVALID && S_AXIL_WVALID && aw_en) begin
                // slave is ready to accept write address when 
                // there is a valid write address and write data
                // on the write address and data bus. This design 
                // expects no outstanding transactions. 
                axi_awready <= 1'b1;
                aw_en <= 1'b0;
            end
            else if (S_AXIL_BREADY && axi_bvalid) begin
                aw_en <= 1'b1;
                axi_awready <= 1'b0;
            end
            else begin
                axi_awready <= 1'b0;
            end
        end 
    end       

    // Implement axi_awaddr latching
    // This process is used to latch the address when both 
    // S_AXIL_AWVALID and S_AXIL_WVALID are valid. 
    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            axi_awaddr <= 0;
        end 
        else begin    
            if (~axi_awready && S_AXIL_AWVALID && S_AXIL_WVALID && aw_en) begin
                // Write Address latching 
                axi_awaddr <= S_AXIL_AWADDR;
            end
        end 
    end       

    // Implement axi_wready generation
    // axi_wready is asserted for one S_AXIL_ACLK clock cycle when both
    // S_AXIL_AWVALID and S_AXIL_WVALID are asserted. axi_wready is 
    // de-asserted when reset is low. 
    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            axi_wready <= 1'b0;
        end 
        else  begin    
            if (~axi_wready && S_AXIL_WVALID && S_AXIL_AWVALID && aw_en ) begin
                // slave is ready to accept write data when 
                // there is a valid write address and write data
                // on the write address and data bus. This design 
                // expects no outstanding transactions. 
                axi_wready <= 1'b1;
            end
            else begin
                axi_wready <= 1'b0;
            end
        end 
    end       

    // Implement memory mapped register select and write logic generation
    // The write data is accepted and written to memory mapped registers when
    // axi_awready, S_AXIL_WVALID, axi_wready and S_AXIL_WVALID are asserted. Write strobes are used to
    // select byte enables of slave registers while writing.
    // These registers are cleared when reset (active low) is applied.
    // Slave register write enable is asserted when valid address and data are available
    // and the slave is ready to accept the write address and write data.
    assign slv_reg_wren = axi_wready && S_AXIL_WVALID && axi_awready && S_AXIL_AWVALID;

    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            ctrl_signals      <= 32'h0;
            outbound_dest_reg <= 32'h0;
            num_pkts_lsb_reg  <= 32'h0;
            num_pkts_msb_reg  <= 32'h0;
            MD_state_reg      <= 32'h0;
            iter_target_reg   <= 32'h0;
            init_id_reg       <= 32'h0;
            dump_bank_sel_reg <= 32'h0;
            debug_reset_reg   <= 32'h0;
            reset_fsm         <= 32'h0;
        end 
        else begin
            // Self clear
            ctrl_signals    <= 32'h0;
            debug_reset_reg <= 32'h0;
            //reset_fsm       <= 32'h0;
            if (slv_reg_wren) begin
                case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
                    7'h00:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                // Respective byte enables are asserted as per write strobes 
                                // Slave register 0
                                ctrl_signals[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end  
                    7'h04:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                MD_state_reg[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end 
                    7'h05:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                outbound_dest_reg[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end  
                    7'h06:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                num_pkts_lsb_reg[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end  
                    7'h07:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                num_pkts_msb_reg[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end  
                    7'h08:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                init_id_reg[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end  
                    7'h09:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                dump_bank_sel_reg[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end 
                    7'h0A:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                reset_fsm[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end                              
                    7'h1F:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                debug_reset_reg[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end                          
                    7'h4D:
                        for ( byte_index = 0; byte_index <= (AXIL_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                            if ( S_AXIL_WSTRB[byte_index] == 1 ) begin
                                iter_target_reg[(byte_index*8) +: 8] <= S_AXIL_WDATA[(byte_index*8) +: 8];
                            end  
                     
                    default : begin
                        ctrl_signals      <= ctrl_signals;
                        outbound_dest_reg <= outbound_dest_reg;
                        num_pkts_lsb_reg  <= num_pkts_lsb_reg;
                        num_pkts_msb_reg  <= num_pkts_msb_reg;
                        MD_state_reg      <= MD_state_reg;
                        iter_target_reg   <= iter_target_reg;
                        dump_bank_sel_reg <= dump_bank_sel_reg;
                        reset_fsm         <= reset_fsm;
                        debug_reset_reg   <= debug_reset_reg;
                    end
                endcase
            end
        end
    end    

    // Implement write response logic generation
    // The write response and response valid signals are asserted by the slave 
    // when axi_wready, S_AXIL_WVALID, axi_wready and S_AXIL_WVALID are asserted.  
    // This marks the acceptance of address and indicates the status of 
    // write transaction.

    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            axi_bvalid  <= 0;
            axi_bresp   <= 2'b0;
        end 
        else begin    
            if (axi_awready && S_AXIL_AWVALID && ~axi_bvalid && axi_wready && S_AXIL_WVALID) begin
                // indicates a valid write response is available
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b0; // 'OKAY' response 
            end                   // work error responses in future
            else begin
                if (S_AXIL_BREADY && axi_bvalid) begin
                //check if bready is asserted while bvalid is high) 
                //(there is a possibility that bready is always asserted high)   
                  axi_bvalid <= 1'b0; 
                end
            end
        end
    end   

    // Implement axi_arready generation
    // axi_arready is asserted for one S_AXIL_ACLK clock cycle when
    // S_AXIL_ARVALID is asserted. axi_awready is 
    // de-asserted when reset (active low) is asserted. 
    // The read address is also latched when S_AXIL_ARVALID is 
    // asserted. axi_araddr is reset to zero on reset assertion.
    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            axi_arready <= 1'b0;
            axi_araddr  <= 32'b0;
        end 
        else begin    
            if (~axi_arready && S_AXIL_ARVALID) begin
                // indicates that the slave has acceped the valid read address
                axi_arready <= 1'b1;
                // Read address latching
                axi_araddr  <= S_AXIL_ARADDR;
            end
            else begin
                axi_arready <= 1'b0;
            end
        end 
    end       

    // Implement axi_arvalid generation
    // axi_rvalid is asserted for one S_AXIL_ACLK clock cycle when both 
    // S_AXIL_ARVALID and axi_arready are asserted. The slave registers 
    // data are available on the axi_rdata bus at this instance. The 
    // assertion of axi_rvalid marks the validity of read data on the 
    // bus and axi_rresp indicates the status of read transaction.axi_rvalid 
    // is de-asserted on reset (active low). axi_rresp and axi_rdata are 
    // cleared to zero on reset (active low).  
    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            axi_rvalid <= 0;
            axi_rresp  <= 0;
        end 
        else begin    
            if (axi_arready && S_AXIL_ARVALID && ~axi_rvalid) begin
                // Valid read data is available at the read data bus
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b0; // 'OKAY' response
            end 
            else if (axi_rvalid && S_AXIL_RREADY) begin
                // Read data is accepted by the master
                axi_rvalid <= 1'b0;
            end                
        end
    end    

    reg ap_done_1d  = 1'b0;
    reg ap_start_1d = 1'b0;
    // Implement memory mapped register select and read logic generation
    // Slave register read enable is asserted when valid address is available
    // and the slave is ready to accept the read address.
    assign slv_reg_rden = axi_arready & S_AXIL_ARVALID & ~axi_rvalid;
    always @(*) begin
          // Address decoding for reading registers
          case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
            /* Bit Name 
             *   0 ap_start
             *   1 ap_done
             *   2 ap_idle
            */
            7'h00   : reg_data_out <= {{29{1'b0}},ap_idle,ap_done_1d,ap_start_1d};
            7'h04   : reg_data_out <= MD_state_reg;
            7'h05   : reg_data_out <= outbound_dest_reg;
            7'h06   : reg_data_out <= num_pkts_lsb_reg;
            7'h07   : reg_data_out <= num_pkts_msb_reg;
            7'h08   : reg_data_out <= init_id_reg;
            7'h09   : reg_data_out <= dump_bank_sel_reg;
            7'h0A   : reg_data_out <= reset_fsm;
            7'h0B   : reg_data_out <= {32{1'b0}};       // Were debug_fsm related signals
            7'h0D   : reg_data_out <= debug_slot_producer_pos[160 +: 32];
            7'h0E   : reg_data_out <= debug_slot_producer_pos[128 +: 32];
            7'h0F   : reg_data_out <= debug_slot_producer_pos[ 96 +: 32];
            7'h10   : reg_data_out <= debug_slot_producer_pos[ 64 +: 32];
            7'h11   : reg_data_out <= debug_slot_producer_pos[ 32 +: 32];
            7'h12   : reg_data_out <= debug_slot_producer_pos[  0 +: 32];
            7'h13   : reg_data_out <= debug_slot_consumer_pos[160 +: 32];
            7'h14   : reg_data_out <= debug_slot_consumer_pos[128 +: 32];
            7'h15   : reg_data_out <= debug_slot_consumer_pos[ 96 +: 32];
            7'h16   : reg_data_out <= debug_slot_consumer_pos[ 64 +: 32];
            7'h17   : reg_data_out <= debug_slot_consumer_pos[ 32 +: 32];
            7'h18   : reg_data_out <= debug_slot_consumer_pos[  0 +: 32];
            7'h20   : reg_data_out <= debug_slot_producer_frc[160 +: 32];
            7'h21   : reg_data_out <= debug_slot_producer_frc[128 +: 32];
            7'h22   : reg_data_out <= debug_slot_producer_frc[ 96 +: 32];
            7'h23   : reg_data_out <= debug_slot_producer_frc[ 64 +: 32];
            7'h24   : reg_data_out <= debug_slot_producer_frc[ 32 +: 32];
            7'h25   : reg_data_out <= debug_slot_producer_frc[  0 +: 32];
            7'h26   : reg_data_out <= debug_slot_consumer_frc[160 +: 32];
            7'h27   : reg_data_out <= debug_slot_consumer_frc[128 +: 32];
            7'h28   : reg_data_out <= debug_slot_consumer_frc[ 96 +: 32];
            7'h29   : reg_data_out <= debug_slot_consumer_frc[ 64 +: 32];
            7'h2A   : reg_data_out <= debug_slot_consumer_frc[ 32 +: 32];
            7'h2B   : reg_data_out <= debug_slot_consumer_frc[  0 +: 32];
            7'h2C   : reg_data_out <= {{31{1'b0}}, debug_fifo_pos_full};
            7'h2D   : reg_data_out <= {{31{1'b0}}, debug_fifo_frc_full};
//            7'h2E   : reg_data_out <= {{(32-PARTICLE_ID_WIDTH){1'b0}}, debug_num_particles};
            7'h2F   : reg_data_out <= {{31{1'b0}}, debug_all_dirty};
            7'h30   : reg_data_out <= {{31{1'b0}}, debug_disp_back_pressure};
            7'h31   : reg_data_out <= {{31{1'b0}}, debug_home_buf_almost_full};
            7'h32   : reg_data_out <= {{31{1'b0}}, debug_nb_buf_almost_full};
            7'h33   : reg_data_out <= {{31{1'b0}}, debug_all_frc_output_ring_buf_empty};
            7'h34   : reg_data_out <= {{31{1'b0}}, debug_all_frc_output_ring_done};
            7'h35   : reg_data_out <= {{31{1'b0}}, debug_all_home_buf_empty};
            7'h36   : reg_data_out <= {{31{1'b0}}, debug_all_nb_buf_empty};
            7'h37   : reg_data_out <= {{31{1'b0}}, debug_all_disp_buf_empty};
            7'h38   : reg_data_out <= {{31{1'b0}}, debug_all_MU_buf_empty};
//            7'h39   : reg_data_out <= {{31{1'b0}}, debug_MU_spinning};
//            7'h3a   : reg_data_out <= {{31{1'b0}}, debug_MU_reading};
//            7'h3b   : reg_data_out <= {{31{1'b0}}, debug_MU_writing};
//            7'h3c   : reg_data_out <= {{31{1'b0}}, debug_MU_busy};
//            7'h3d   : reg_data_out <= {{27{1'b0}}, debug_MU_busy_cnt};
//            7'h3e   : reg_data_out <= {{28{1'b0}}, debug_pos_state};
//            7'h3f   : reg_data_out <= {{31{1'b0}}, debug_MU_started};
//            7'h40   : reg_data_out <= {{31{1'b0}}, debug_MU_frc_once_valid};
//            7'h41   : reg_data_out <= {{31{1'b0}}, debug_MU_offset_once_valid};
//            7'h42   : reg_data_out <= {{31{1'b0}}, debug_MU_vel_once_valid};
//            7'h43   : reg_data_out <= {{31{1'b0}}, debug_MU_once_writing};
//            7'h44   : reg_data_out <= {{31{1'b0}}, debug_MU_once_reading};
            7'h45   : reg_data_out <= {{31{1'b0}}, debug_chk_nb_frc};
            7'h46   : reg_data_out <= {{31{1'b0}}, debug_chk_home_frc};
            7'h47   : reg_data_out <= {{31{1'b0}}, debug_chk_MU_vel_out};
            7'h48   : reg_data_out <= {{31{1'b0}}, debug_chk_MU_vel_produced};
            7'h49   : reg_data_out <= {{31{1'b0}}, debug_chk_MU_offset_in};
            7'h4a   : reg_data_out <= {{23{1'b0}}, debug_MU_num_particles};
            7'h4b   : reg_data_out <= {{23{1'b0}}, debug_MU_rd_cnt};
            7'h4c   : reg_data_out <= debug_iter_cnt;
            7'h4d   : reg_data_out <= iter_target_reg;
            7'h4e   : reg_data_out <= debug_operation_cycle_cnt;
            7'h4f   : reg_data_out <= debug_MU_migration;
            7'h50   : reg_data_out <= debug_num_particles_0;
            7'h51   : reg_data_out <= debug_num_particles_1;
            7'h52   : reg_data_out <= debug_num_particles_2;
            7'h53   : reg_data_out <= debug_num_particles_3;
            7'h54   : reg_data_out <= debug_num_particles_4;
            7'h55   : reg_data_out <= debug_num_particles_5;
            7'h56   : reg_data_out <= debug_num_particles_6;
            7'h57   : reg_data_out <= debug_num_particles_7;
            7'h58   : reg_data_out <= debug_init_step;
            7'h59   : reg_data_out <= debug_init_wr_addr;
            7'h5a   : reg_data_out <= debug_num_particles_8;
            7'h5b   : reg_data_out <= debug_num_particles_9;
            7'h5c   : reg_data_out <= debug_num_particles_10;
            7'h5d   : reg_data_out <= debug_num_particles_11;
            7'h5e   : reg_data_out <= debug_num_particles_12;
            7'h5f   : reg_data_out <= debug_num_particles_13;
            7'h60   : reg_data_out <= debug_num_particles_14;
            7'h61   : reg_data_out <= debug_num_particles_15;
            7'h62   : reg_data_out <= debug_num_particles_16;
            7'h63   : reg_data_out <= debug_num_particles_17;
            7'h64   : reg_data_out <= debug_num_particles_18;
            7'h65   : reg_data_out <= debug_num_particles_19;
            7'h66   : reg_data_out <= debug_num_particles_20;
            7'h67   : reg_data_out <= debug_num_particles_21;
            7'h68   : reg_data_out <= debug_num_particles_22;
            7'h69   : reg_data_out <= debug_num_particles_23;
            7'h6a   : reg_data_out <= debug_num_particles_24;
            7'h6b   : reg_data_out <= debug_num_particles_25;
            7'h6c   : reg_data_out <= debug_num_particles_26;
            7'h6d   : reg_data_out <= debug_first_migration_iter;
            7'h6e   : reg_data_out <= debug_first_anomaly_nop_iter;
            default : reg_data_out <= {32{1'b0}};
          endcase
    end

    // Output register or memory read data
    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            axi_rdata  <= 0;
        end 
        else begin    
        // When there is a valid read address (S_AXIL_ARVALID) with 
        // acceptance of read address by the slave (axi_arready), 
        // output the read dada 
        if (slv_reg_rden) begin
            axi_rdata <= reg_data_out;     // register read data
        end   
        end
    end

    // Hold high ap_start until ap_done is asserted
    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            ap_start_1d  <= 0;
        end 
        else begin
            if (ctrl_signals[0])
                ap_start_1d <= 1'b1;
            if (ap_done)
                ap_start_1d <= 1'b0;
        end
    end

    // Hold ap_done until the address 0x0 is read
    always @( posedge S_AXIL_ACLK ) begin
        if ( S_AXIL_ARESETN == 1'b0 ) begin
            ap_done_1d  <= 0;
        end 
        else begin
            if (ap_done)
                ap_done_1d <=1'b1;
            if (slv_reg_rden && (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 0))
                ap_done_1d <=1'b0;
        end
    end


    assign ap_start             = ctrl_signals[0];
    assign dest_id              = outbound_dest_reg[STREAMING_TDEST_WIDTH-1:0];
    assign number_packets       = {num_pkts_lsb_reg};
    assign MD_state             = MD_state_reg[2:0];
    assign iter_target          = iter_target_reg;
    assign init_id              = init_id_reg[STREAMING_TDEST_WIDTH-1:0];
    assign dump_bank_sel        = dump_bank_sel_reg[INIT_STEP_WIDTH-1:0];
    assign reset_fsm_n          = ~reset_fsm[0];
    assign debug_reset_n        = ~debug_reset_reg[0];

endmodule
