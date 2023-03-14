//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:50 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FRC_CACHES_wrapper.bd
//Design      : FRC_CACHES_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module FRC_CACHES_wrapper
   (clk,
    frc_rd_addr,
    frc_rd_data,
    frc_wr_addr,
    frc_wr_data,
    frc_wr_en);
  input clk;
  input [8:0]frc_rd_addr;
  output [95:0]frc_rd_data;
  input [8:0]frc_wr_addr;
  input [95:0]frc_wr_data;
  input frc_wr_en;

  wire clk;
  wire [8:0]frc_rd_addr;
  wire [95:0]frc_rd_data;
  wire [8:0]frc_wr_addr;
  wire [95:0]frc_wr_data;
  wire frc_wr_en;

  FRC_CACHES FRC_CACHES_i
       (.clk(clk),
        .frc_rd_addr(frc_rd_addr),
        .frc_rd_data(frc_rd_data),
        .frc_wr_addr(frc_wr_addr),
        .frc_wr_data(frc_wr_data),
        .frc_wr_en(frc_wr_en));
endmodule
