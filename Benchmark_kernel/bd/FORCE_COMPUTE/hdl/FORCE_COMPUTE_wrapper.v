//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:36 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FORCE_COMPUTE_wrapper.bd
//Design      : FORCE_COMPUTE_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module FORCE_COMPUTE_wrapper
   (clk,
    coeff_14,
    coeff_8,
    dx,
    dy,
    dz,
    frc_valid,
    fx,
    fy,
    fz,
    r2,
    term_0_14,
    term_0_8,
    term_1_14,
    term_1_8,
    term_valid);
  input clk;
  input [31:0]coeff_14;
  input [31:0]coeff_8;
  input [31:0]dx;
  input [31:0]dy;
  input [31:0]dz;
  output frc_valid;
  output [31:0]fx;
  output [31:0]fy;
  output [31:0]fz;
  input [31:0]r2;
  input [31:0]term_0_14;
  input [31:0]term_0_8;
  input [31:0]term_1_14;
  input [31:0]term_1_8;
  input term_valid;

  wire clk;
  wire [31:0]coeff_14;
  wire [31:0]coeff_8;
  wire [31:0]dx;
  wire [31:0]dy;
  wire [31:0]dz;
  wire frc_valid;
  wire [31:0]fx;
  wire [31:0]fy;
  wire [31:0]fz;
  wire [31:0]r2;
  wire [31:0]term_0_14;
  wire [31:0]term_0_8;
  wire [31:0]term_1_14;
  wire [31:0]term_1_8;
  wire term_valid;

  FORCE_COMPUTE FORCE_COMPUTE_i
       (.clk(clk),
        .coeff_14(coeff_14),
        .coeff_8(coeff_8),
        .dx(dx),
        .dy(dy),
        .dz(dz),
        .frc_valid(frc_valid),
        .fx(fx),
        .fy(fy),
        .fz(fz),
        .r2(r2),
        .term_0_14(term_0_14),
        .term_0_8(term_0_8),
        .term_1_14(term_1_14),
        .term_1_8(term_1_8),
        .term_valid(term_valid));
endmodule
