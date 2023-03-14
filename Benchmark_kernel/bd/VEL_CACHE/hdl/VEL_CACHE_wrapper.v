//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:13:08 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target VEL_CACHE_wrapper.bd
//Design      : VEL_CACHE_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module VEL_CACHE_wrapper
   (clk,
    rd_addr,
    vel_in,
    vel_out,
    wr_addr,
    wr_en);
  input clk;
  input [8:0]rd_addr;
  input [95:0]vel_in;
  output [95:0]vel_out;
  input [8:0]wr_addr;
  input wr_en;

  wire clk;
  wire [8:0]rd_addr;
  wire [95:0]vel_in;
  wire [95:0]vel_out;
  wire [8:0]wr_addr;
  wire wr_en;

  VEL_CACHE VEL_CACHE_i
       (.clk(clk),
        .rd_addr(rd_addr),
        .vel_in(vel_in),
        .vel_out(vel_out),
        .wr_addr(wr_addr),
        .wr_en(wr_en));
endmodule
