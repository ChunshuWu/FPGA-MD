//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:41 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FIFO_86W512D.bd
//Design      : FIFO_86W512D
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "FIFO_86W512D,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=FIFO_86W512D,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "FIFO_86W512D.hwdef" *) 
module FIFO_86W512D
   (clk,
    din,
    dout,
    empty,
    prog_full,
    rd_en,
    srst,
    wr_en);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN FIFO_86W512D_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  input [85:0]din;
  output [85:0]dout;
  output empty;
  output prog_full;
  input rd_en;
  input srst;
  input wr_en;

  wire clk_0_1;
  wire [85:0]din_0_1;
  wire [85:0]fifo_generator_0_dout;
  wire fifo_generator_0_empty;
  wire fifo_generator_0_prog_full;
  wire rd_en_0_1;
  wire srst_0_1;
  wire wr_en_0_1;

  assign clk_0_1 = clk;
  assign din_0_1 = din[85:0];
  assign dout[85:0] = fifo_generator_0_dout;
  assign empty = fifo_generator_0_empty;
  assign prog_full = fifo_generator_0_prog_full;
  assign rd_en_0_1 = rd_en;
  assign srst_0_1 = srst;
  assign wr_en_0_1 = wr_en;
  FIFO_86W512D_fifo_generator_0_0 fifo_generator_0
       (.clk(clk_0_1),
        .din(din_0_1),
        .dout(fifo_generator_0_dout),
        .empty(fifo_generator_0_empty),
        .prog_full(fifo_generator_0_prog_full),
        .rd_en(rd_en_0_1),
        .srst(srst_0_1),
        .wr_en(wr_en_0_1));
endmodule
