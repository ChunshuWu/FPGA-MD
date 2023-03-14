//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:25 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FORCE_LUT_wrapper.bd
//Design      : FORCE_LUT_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module FORCE_LUT_wrapper
   (addr,
    clk,
    data_in,
    rd_en,
    term_0_14,
    term_0_8,
    term_1_14,
    term_1_8,
    wr_en);
  input [11:0]addr;
  input clk;
  input [31:0]data_in;
  input rd_en;
  output [31:0]term_0_14;
  output [31:0]term_0_8;
  output [31:0]term_1_14;
  output [31:0]term_1_8;
  input [0:0]wr_en;

  wire [11:0]addr;
  wire clk;
  wire [31:0]data_in;
  wire rd_en;
  wire [31:0]term_0_14;
  wire [31:0]term_0_8;
  wire [31:0]term_1_14;
  wire [31:0]term_1_8;
  wire [0:0]wr_en;

  FORCE_LUT FORCE_LUT_i
       (.addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .term_0_14(term_0_14),
        .term_0_8(term_0_8),
        .term_1_14(term_1_14),
        .term_1_8(term_1_8),
        .wr_en(wr_en));
endmodule
