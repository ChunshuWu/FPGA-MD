//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:47 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FRC_ADD_XYZ_wrapper.bd
//Design      : FRC_ADD_XYZ_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module FRC_ADD_XYZ_wrapper
   (clk,
    frc_acc_valid,
    frc_acc_x,
    frc_acc_y,
    frc_acc_z,
    frc_valid_1,
    frc_valid_2,
    frc_x1,
    frc_x2,
    frc_y1,
    frc_y2,
    frc_z1,
    frc_z2);
  input clk;
  output frc_acc_valid;
  output [31:0]frc_acc_x;
  output [31:0]frc_acc_y;
  output [31:0]frc_acc_z;
  input frc_valid_1;
  input frc_valid_2;
  input [31:0]frc_x1;
  input [31:0]frc_x2;
  input [31:0]frc_y1;
  input [31:0]frc_y2;
  input [31:0]frc_z1;
  input [31:0]frc_z2;

  wire clk;
  wire frc_acc_valid;
  wire [31:0]frc_acc_x;
  wire [31:0]frc_acc_y;
  wire [31:0]frc_acc_z;
  wire frc_valid_1;
  wire frc_valid_2;
  wire [31:0]frc_x1;
  wire [31:0]frc_x2;
  wire [31:0]frc_y1;
  wire [31:0]frc_y2;
  wire [31:0]frc_z1;
  wire [31:0]frc_z2;

  FRC_ADD_XYZ FRC_ADD_XYZ_i
       (.clk(clk),
        .frc_acc_valid(frc_acc_valid),
        .frc_acc_x(frc_acc_x),
        .frc_acc_y(frc_acc_y),
        .frc_acc_z(frc_acc_z),
        .frc_valid_1(frc_valid_1),
        .frc_valid_2(frc_valid_2),
        .frc_x1(frc_x1),
        .frc_x2(frc_x2),
        .frc_y1(frc_y1),
        .frc_y2(frc_y2),
        .frc_z1(frc_z1),
        .frc_z2(frc_z2));
endmodule
