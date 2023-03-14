//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:42 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FIFO_9W512D_wrapper.bd
//Design      : FIFO_9W512D_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module FIFO_9W512D_wrapper
   (clk,
    din,
    dout,
    empty,
    prog_full,
    rd_en,
    srst,
    wr_en);
  input clk;
  input [8:0]din;
  output [8:0]dout;
  output empty;
  output prog_full;
  input rd_en;
  input srst;
  input wr_en;

  wire clk;
  wire [8:0]din;
  wire [8:0]dout;
  wire empty;
  wire prog_full;
  wire rd_en;
  wire srst;
  wire wr_en;

  FIFO_9W512D FIFO_9W512D_i
       (.clk(clk),
        .din(din),
        .dout(dout),
        .empty(empty),
        .prog_full(prog_full),
        .rd_en(rd_en),
        .srst(srst),
        .wr_en(wr_en));
endmodule
