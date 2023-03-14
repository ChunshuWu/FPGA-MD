//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:13:09 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target NB_FRC_TO_RING_BUF.bd
//Design      : NB_FRC_TO_RING_BUF
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "NB_FRC_TO_RING_BUF,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=NB_FRC_TO_RING_BUF,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "NB_FRC_TO_RING_BUF.hwdef" *) 
module NB_FRC_TO_RING_BUF
   (almost_full,
    buf_empty,
    clk,
    rd_data,
    rd_en,
    rst,
    wr_data,
    wr_en);
  output almost_full;
  output buf_empty;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN NB_FRC_TO_RING_BUF_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  output [110:0]rd_data;
  input rd_en;
  input rst;
  input [110:0]wr_data;
  input wr_en;

  wire clk_0_1;
  wire [110:0]din_0_1;
  wire [110:0]home_frc_fifo_dout;
  wire home_frc_fifo_empty;
  wire home_frc_fifo_prog_full;
  wire rd_en_0_1;
  wire srst_0_1;
  wire wr_en_1_1;

  assign almost_full = home_frc_fifo_prog_full;
  assign buf_empty = home_frc_fifo_empty;
  assign clk_0_1 = clk;
  assign din_0_1 = wr_data[110:0];
  assign rd_data[110:0] = home_frc_fifo_dout;
  assign rd_en_0_1 = rd_en;
  assign srst_0_1 = rst;
  assign wr_en_1_1 = wr_en;
  NB_FRC_TO_RING_BUF_frc_fifo_0 frc_fifo
       (.clk(clk_0_1),
        .din(din_0_1),
        .dout(home_frc_fifo_dout),
        .empty(home_frc_fifo_empty),
        .prog_full(home_frc_fifo_prog_full),
        .rd_en(rd_en_0_1),
        .srst(srst_0_1),
        .wr_en(wr_en_1_1));
endmodule
