//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:51 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target MU_OUT_BUF_wrapper.bd
//Design      : MU_OUT_BUF_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module MU_OUT_BUF_wrapper
   (almost_full,
    clk,
    data_in,
    data_out,
    empty,
    rd_en,
    rst,
    wr_en);
  output almost_full;
  input clk;
  input [169:0]data_in;
  output [169:0]data_out;
  output empty;
  input rd_en;
  input rst;
  input wr_en;

  wire almost_full;
  wire clk;
  wire [169:0]data_in;
  wire [169:0]data_out;
  wire empty;
  wire rd_en;
  wire rst;
  wire wr_en;

  MU_OUT_BUF MU_OUT_BUF_i
       (.almost_full(almost_full),
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en));
endmodule
