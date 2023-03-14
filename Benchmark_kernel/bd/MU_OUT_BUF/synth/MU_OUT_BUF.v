//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:50 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target MU_OUT_BUF.bd
//Design      : MU_OUT_BUF
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "MU_OUT_BUF,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=MU_OUT_BUF,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "MU_OUT_BUF.hwdef" *) 
module MU_OUT_BUF
   (almost_full,
    clk,
    data_in,
    data_out,
    empty,
    rd_en,
    rst,
    wr_en);
  output almost_full;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN MU_OUT_BUF_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  input [169:0]data_in;
  output [169:0]data_out;
  output empty;
  input rd_en;
  input rst;
  input wr_en;

  wire clk_0_1;
  wire [169:0]din_0_1;
  wire [169:0]frc_fifo_dout;
  wire frc_fifo_empty;
  wire frc_fifo_prog_full;
  wire rd_en_0_1;
  wire srst_0_1;
  wire wr_en_0_1;

  assign almost_full = frc_fifo_prog_full;
  assign clk_0_1 = clk;
  assign data_out[169:0] = frc_fifo_dout;
  assign din_0_1 = data_in[169:0];
  assign empty = frc_fifo_empty;
  assign rd_en_0_1 = rd_en;
  assign srst_0_1 = rst;
  assign wr_en_0_1 = wr_en;
  MU_OUT_BUF_MU_fifo_0 MU_fifo
       (.clk(clk_0_1),
        .din(din_0_1),
        .dout(frc_fifo_dout),
        .empty(frc_fifo_empty),
        .prog_full(frc_fifo_prog_full),
        .rd_en(rd_en_0_1),
        .srst(srst_0_1),
        .wr_en(wr_en_0_1));
endmodule
