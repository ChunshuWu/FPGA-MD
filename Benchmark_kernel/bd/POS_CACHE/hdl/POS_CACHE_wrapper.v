//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:03 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target POS_CACHE_wrapper.bd
//Design      : POS_CACHE_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module POS_CACHE_wrapper
   (clk,
    i_data,
    i_rd_addr,
    i_rd_en,
    i_wr_addr,
    i_wr_en,
    o_data);
  input clk;
  input [71:0]i_data;
  input [8:0]i_rd_addr;
  input i_rd_en;
  input [8:0]i_wr_addr;
  input i_wr_en;
  output [71:0]o_data;

  wire clk;
  wire [71:0]i_data;
  wire [8:0]i_rd_addr;
  wire i_rd_en;
  wire [8:0]i_wr_addr;
  wire i_wr_en;
  wire [71:0]o_data;

  POS_CACHE POS_CACHE_i
       (.clk(clk),
        .i_data(i_data),
        .i_rd_addr(i_rd_addr),
        .i_rd_en(i_rd_en),
        .i_wr_addr(i_wr_addr),
        .i_wr_en(i_wr_en),
        .o_data(o_data));
endmodule
