//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:13:09 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target NB_FRC_TO_RING_BUF_wrapper.bd
//Design      : NB_FRC_TO_RING_BUF_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module NB_FRC_TO_RING_BUF_wrapper
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
  input clk;
  output [110:0]rd_data;
  input rd_en;
  input rst;
  input [110:0]wr_data;
  input wr_en;

  wire almost_full;
  wire buf_empty;
  wire clk;
  wire [110:0]rd_data;
  wire rd_en;
  wire rst;
  wire [110:0]wr_data;
  wire wr_en;

  NB_FRC_TO_RING_BUF NB_FRC_TO_RING_BUF_i
       (.almost_full(almost_full),
        .buf_empty(buf_empty),
        .clk(clk),
        .rd_data(rd_data),
        .rd_en(rd_en),
        .rst(rst),
        .wr_data(wr_data),
        .wr_en(wr_en));
endmodule
