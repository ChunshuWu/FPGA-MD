//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Tue Mar  7 18:39:52 2023
//Host        : fpga-tools running 64-bit Ubuntu 18.04.6 LTS
//Command     : generate_target REMOTE_POS_IN_FIFO_wrapper.bd
//Design      : REMOTE_POS_IN_FIFO_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module REMOTE_POS_IN_FIFO_wrapper
   (clk,
    din,
    dout,
    empty,
    prog_full,
    rd_en,
    rst,
    wr_en);
  input clk;
  input [511:0]din;
  output [511:0]dout;
  output empty;
  output prog_full;
  input rd_en;
  input rst;
  input wr_en;

  wire clk;
  wire [511:0]din;
  wire [511:0]dout;
  wire empty;
  wire prog_full;
  wire rd_en;
  wire rst;
  wire wr_en;

  REMOTE_POS_IN_FIFO REMOTE_POS_IN_FIFO_i
       (.clk(clk),
        .din(din),
        .dout(dout),
        .empty(empty),
        .prog_full(prog_full),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en));
endmodule
