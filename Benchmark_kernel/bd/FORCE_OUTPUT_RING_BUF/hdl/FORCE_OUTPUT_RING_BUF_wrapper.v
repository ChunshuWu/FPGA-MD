//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:43 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FORCE_OUTPUT_RING_BUF_wrapper.bd
//Design      : FORCE_OUTPUT_RING_BUF_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module FORCE_OUTPUT_RING_BUF_wrapper
   (almost_full,
    clk,
    data_out,
    empty,
    rd_en,
    rst,
    wr_data,
    wr_en);
  output almost_full;
  input clk;
  output [111:0]data_out;
  output empty;
  input rd_en;
  input rst;
  input [111:0]wr_data;
  input wr_en;

  wire almost_full;
  wire clk;
  wire [111:0]data_out;
  wire empty;
  wire rd_en;
  wire rst;
  wire [111:0]wr_data;
  wire wr_en;

  FORCE_OUTPUT_RING_BUF FORCE_OUTPUT_RING_BUF_i
       (.almost_full(almost_full),
        .clk(clk),
        .data_out(data_out),
        .empty(empty),
        .rd_en(rd_en),
        .rst(rst),
        .wr_data(wr_data),
        .wr_en(wr_en));
endmodule
