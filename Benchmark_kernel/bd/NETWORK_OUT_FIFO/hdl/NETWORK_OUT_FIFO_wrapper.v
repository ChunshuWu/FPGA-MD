//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:07 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target NETWORK_OUT_FIFO_wrapper.bd
//Design      : NETWORK_OUT_FIFO_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module NETWORK_OUT_FIFO_wrapper
   (clk_0,
    din_0,
    dout_0,
    empty_0,
    prog_full_0,
    rd_en_0,
    srst_0,
    valid_0,
    wr_en_0);
  input clk_0;
  input [592:0]din_0;
  output [592:0]dout_0;
  output empty_0;
  output prog_full_0;
  input rd_en_0;
  input srst_0;
  output valid_0;
  input wr_en_0;

  wire clk_0;
  wire [592:0]din_0;
  wire [592:0]dout_0;
  wire empty_0;
  wire prog_full_0;
  wire rd_en_0;
  wire srst_0;
  wire valid_0;
  wire wr_en_0;

  NETWORK_OUT_FIFO NETWORK_OUT_FIFO_i
       (.clk_0(clk_0),
        .din_0(din_0),
        .dout_0(dout_0),
        .empty_0(empty_0),
        .prog_full_0(prog_full_0),
        .rd_en_0(rd_en_0),
        .srst_0(srst_0),
        .valid_0(valid_0),
        .wr_en_0(wr_en_0));
endmodule
