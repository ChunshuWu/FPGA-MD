//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Tue Mar  7 18:39:52 2023
//Host        : fpga-tools running 64-bit Ubuntu 18.04.6 LTS
//Command     : generate_target REMOTE_POS_IN_FIFO.bd
//Design      : REMOTE_POS_IN_FIFO
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "REMOTE_POS_IN_FIFO,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=REMOTE_POS_IN_FIFO,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "REMOTE_POS_IN_FIFO.hwdef" *) 
module REMOTE_POS_IN_FIFO
   (clk,
    din,
    dout,
    empty,
    prog_full,
    rd_en,
    rst,
    wr_en);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN REMOTE_POS_IN_FIFO_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  input [511:0]din;
  output [511:0]dout;
  output empty;
  output prog_full;
  input rd_en;
  input rst;
  input wr_en;

  wire clk_0_1;
  wire [511:0]din_0_1;
  wire [511:0]fifo_generator_0_dout;
  wire fifo_generator_0_empty;
  wire fifo_generator_0_prog_full;
  wire rd_en_0_1;
  wire srst_0_1;
  wire wr_en_0_1;

  assign clk_0_1 = clk;
  assign din_0_1 = din[511:0];
  assign dout[511:0] = fifo_generator_0_dout;
  assign empty = fifo_generator_0_empty;
  assign prog_full = fifo_generator_0_prog_full;
  assign rd_en_0_1 = rd_en;
  assign srst_0_1 = rst;
  assign wr_en_0_1 = wr_en;
  REMOTE_POS_IN_FIFO_fifo_generator_0_0 fifo_generator_0
       (.clk(clk_0_1),
        .din(din_0_1),
        .dout(fifo_generator_0_dout),
        .empty(fifo_generator_0_empty),
        .prog_full(fifo_generator_0_prog_full),
        .rd_en(rd_en_0_1),
        .srst(srst_0_1),
        .wr_en(wr_en_0_1));
endmodule
