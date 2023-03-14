//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:13:03 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target MU_PIPELINE_wrapper.bd
//Design      : MU_PIPELINE_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module MU_PIPELINE_wrapper
   (clk,
    i_coeff,
    i_delay_signals,
    i_fx,
    i_fy,
    i_fz,
    i_time_step,
    i_valid,
    i_vx,
    i_vy,
    i_vz,
    o_data_valid,
    o_delay_signals,
    o_dx,
    o_dy,
    o_dz,
    o_vx,
    o_vy,
    o_vz);
  input clk;
  input [31:0]i_coeff;
  input [73:0]i_delay_signals;
  input [31:0]i_fx;
  input [31:0]i_fy;
  input [31:0]i_fz;
  input [31:0]i_time_step;
  input i_valid;
  input [31:0]i_vx;
  input [31:0]i_vy;
  input [31:0]i_vz;
  output o_data_valid;
  output [73:0]o_delay_signals;
  output [31:0]o_dx;
  output [31:0]o_dy;
  output [31:0]o_dz;
  output [31:0]o_vx;
  output [31:0]o_vy;
  output [31:0]o_vz;

  wire clk;
  wire [31:0]i_coeff;
  wire [73:0]i_delay_signals;
  wire [31:0]i_fx;
  wire [31:0]i_fy;
  wire [31:0]i_fz;
  wire [31:0]i_time_step;
  wire i_valid;
  wire [31:0]i_vx;
  wire [31:0]i_vy;
  wire [31:0]i_vz;
  wire o_data_valid;
  wire [73:0]o_delay_signals;
  wire [31:0]o_dx;
  wire [31:0]o_dy;
  wire [31:0]o_dz;
  wire [31:0]o_vx;
  wire [31:0]o_vy;
  wire [31:0]o_vz;

  MU_PIPELINE MU_PIPELINE_i
       (.clk(clk),
        .i_coeff(i_coeff),
        .i_delay_signals(i_delay_signals),
        .i_fx(i_fx),
        .i_fy(i_fy),
        .i_fz(i_fz),
        .i_time_step(i_time_step),
        .i_valid(i_valid),
        .i_vx(i_vx),
        .i_vy(i_vy),
        .i_vz(i_vz),
        .o_data_valid(o_data_valid),
        .o_delay_signals(o_delay_signals),
        .o_dx(o_dx),
        .o_dy(o_dy),
        .o_dz(o_dz),
        .o_vx(o_vx),
        .o_vy(o_vy),
        .o_vz(o_vz));
endmodule
