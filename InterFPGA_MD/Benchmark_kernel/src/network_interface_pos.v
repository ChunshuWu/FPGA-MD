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

`default_nettype wire
`timescale 1 ns / 1 ps
module network_interface_pos #(
  parameter integer AXIS_TDATA_WIDTH      = 512,
  parameter integer STREAMING_TDEST_WIDTH =  16
)(
  // System clocks and resets
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXIS_n2k:M_AXIS_k2n, ASSOCIATED_RESET ap_rst_n" *)
  input  wire                                 ap_clk,
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *)
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
  input  wire                                 ap_rst_n,

  // AXI4-Stream network layer to streaming kernel 
  input  wire       [AXIS_TDATA_WIDTH-1:0]    S_AXIS_n2k_tdata,
  input  wire     [AXIS_TDATA_WIDTH/8-1:0]    S_AXIS_n2k_tkeep,
  input  wire                                 S_AXIS_n2k_tvalid,
  input  wire                                 S_AXIS_n2k_tlast,
  input  wire  [STREAMING_TDEST_WIDTH-1:0]    S_AXIS_n2k_tdest,
  output reg                                  S_AXIS_n2k_tready,
  // AXI4-Stream streaming kernel to network layer
  output  reg       [AXIS_TDATA_WIDTH-1:0]    M_AXIS_k2n_tdata,
  output  reg     [AXIS_TDATA_WIDTH/8-1:0]    M_AXIS_k2n_tkeep,
  output  reg                                 M_AXIS_k2n_tvalid,
  output  reg                                 M_AXIS_k2n_tlast,
  output  reg  [STREAMING_TDEST_WIDTH-1:0]    M_AXIS_k2n_tdest,
  input  wire                                 M_AXIS_k2n_tready,
  
  input  wire                                 reset_fsm_n,
  input  wire                                 ap_start,
  output  reg                                 ap_idle,
  output  reg                                 ap_done, 
  output wire                                 axis_producer_free
);

  reg                                 ap_start_1d = 1'b0;

  reg       [AXIS_TDATA_WIDTH-1:0]    producer_tdata  = {(AXIS_TDATA_WIDTH/8){1'b1}};
  reg     [AXIS_TDATA_WIDTH/8-1:0]    producer_tkeep  = {((AXIS_TDATA_WIDTH/8)){1'b1}};
  reg                                 producer_tvalid = 1'b0;
  reg                                 producer_tlast  = 1'b0;
  reg  [STREAMING_TDEST_WIDTH-1:0]    producer_tdest  = {(STREAMING_TDEST_WIDTH){1'b0}};

  assign axis_producer_free = M_AXIS_k2n_tready | ~M_AXIS_k2n_tvalid;
  
  always @(*) begin
    M_AXIS_k2n_tdata  <= producer_tdata;
    M_AXIS_k2n_tkeep  <= producer_tkeep;
    M_AXIS_k2n_tvalid <= producer_tvalid;
    M_AXIS_k2n_tlast  <= producer_tlast;
    M_AXIS_k2n_tdest  <= producer_tdest;
    S_AXIS_n2k_tready <= M_AXIS_k2n_tready;
  end


  localparam      IDLE                        = 0,
                  FORWARD                     = 1,
                  FSM_DONE                    = 2;

  
  reg [3:0]      fsm_state = IDLE;

  always @(posedge ap_clk) begin
    if (~ap_rst_n || ~reset_fsm_n) begin
      ap_done            <= 1'b0;
      ap_idle            <= 1'b1;
      producer_tdata     <= {(AXIS_TDATA_WIDTH){1'b0}};
      producer_tdest     <= {(STREAMING_TDEST_WIDTH){1'b0}};
      producer_tvalid    <= 1'b0;
      producer_tlast     <= 1'b0;
      fsm_state          <= IDLE;
    end
    else begin
      producer_tvalid <= producer_tvalid & ~M_AXIS_k2n_tready;
      producer_tlast  <= 1'b1;
  
      case (fsm_state)
        IDLE : begin
          ap_done                        <= 1'b0;
          ap_idle                        <= 1'b1;
          if (ap_start == 1'b0 && ap_start_1d == 1'b1) begin
            ap_done                      <= 1'b0;
            ap_idle                      <= 1'b0;
            fsm_state                    <= FORWARD;
          end
        end
        FORWARD : begin
          if (axis_producer_free) begin
            producer_tdata               <= S_AXIS_n2k_tdata;
            producer_tdest               <= S_AXIS_n2k_tdest;
            producer_tkeep               <= S_AXIS_n2k_tkeep;
            producer_tvalid              <= S_AXIS_n2k_tvalid;
            producer_tlast               <= S_AXIS_n2k_tlast;

            if (ap_start == 1'b0 && ap_start_1d == 1'b1)
              fsm_state                    <= FSM_DONE;
            else 
              fsm_state                    <= FORWARD;
	  end
        end
        FSM_DONE: begin
          ap_done                      <= 1'b1;
          fsm_state                    <= IDLE;
        end
      endcase
    end
  end                  

  always @(posedge ap_clk) begin
    ap_start_1d <= ap_start;
  end

endmodule
