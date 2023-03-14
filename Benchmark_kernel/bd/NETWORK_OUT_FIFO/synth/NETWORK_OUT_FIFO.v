//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:07 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target NETWORK_OUT_FIFO.bd
//Design      : NETWORK_OUT_FIFO
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "NETWORK_OUT_FIFO,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=NETWORK_OUT_FIFO,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "NETWORK_OUT_FIFO.hwdef" *) 
module NETWORK_OUT_FIFO
   (clk_0,
    din_0,
    dout_0,
    empty_0,
    prog_full_0,
    rd_en_0,
    srst_0,
    valid_0,
    wr_en_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN NETWORK_OUT_FIFO_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_0;
  input [592:0]din_0;
  output [592:0]dout_0;
  output empty_0;
  output prog_full_0;
  input rd_en_0;
  input srst_0;
  output valid_0;
  input wr_en_0;

  wire clk_0_1;
  wire [592:0]din_0_1;
  wire [592:0]fifo_generator_0_dout;
  wire fifo_generator_0_empty;
  wire fifo_generator_0_prog_full;
  wire fifo_generator_0_valid;
  wire rd_en_0_1;
  wire srst_0_1;
  wire wr_en_0_1;

  assign clk_0_1 = clk_0;
  assign din_0_1 = din_0[592:0];
  assign dout_0[592:0] = fifo_generator_0_dout;
  assign empty_0 = fifo_generator_0_empty;
  assign prog_full_0 = fifo_generator_0_prog_full;
  assign rd_en_0_1 = rd_en_0;
  assign srst_0_1 = srst_0;
  assign valid_0 = fifo_generator_0_valid;
  assign wr_en_0_1 = wr_en_0;
  NETWORK_OUT_FIFO_fifo_generator_0_0 fifo_generator_0
       (.clk(clk_0_1),
        .din(din_0_1),
        .dout(fifo_generator_0_dout),
        .empty(fifo_generator_0_empty),
        .prog_full(fifo_generator_0_prog_full),
        .rd_en(rd_en_0_1),
        .srst(srst_0_1),
        .valid(fifo_generator_0_valid),
        .wr_en(wr_en_0_1));
endmodule
