//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:18 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FP_RSQUARE_wrapper.bd
//Design      : FP_RSQUARE_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module FP_RSQUARE_wrapper
   (aclk,
    d25_elements,
    d36_home_parid,
    d36_nb_cid,
    d36_nb_parid,
    d36_nb_reg_release_flag,
    d36_nb_reg_sel,
    dx,
    dy,
    dz,
    elements,
    home_parid,
    home_valid,
    home_x,
    home_y,
    home_z,
    nb_cid,
    nb_parid,
    nb_reg_release_flag,
    nb_reg_sel,
    nb_valid,
    nb_x,
    nb_y,
    nb_z,
    r2,
    r2_valid);
  input aclk;
  output [3:0]d25_elements;
  output [8:0]d36_home_parid;
  output [5:0]d36_nb_cid;
  output [8:0]d36_nb_parid;
  output [0:0]d36_nb_reg_release_flag;
  output [5:0]d36_nb_reg_sel;
  output [31:0]dx;
  output [31:0]dy;
  output [31:0]dz;
  input [3:0]elements;
  input [8:0]home_parid;
  input home_valid;
  input [31:0]home_x;
  input [31:0]home_y;
  input [31:0]home_z;
  input [5:0]nb_cid;
  input [8:0]nb_parid;
  input [0:0]nb_reg_release_flag;
  input [5:0]nb_reg_sel;
  input nb_valid;
  input [31:0]nb_x;
  input [31:0]nb_y;
  input [31:0]nb_z;
  output [31:0]r2;
  output r2_valid;

  wire aclk;
  wire [3:0]d25_elements;
  wire [8:0]d36_home_parid;
  wire [5:0]d36_nb_cid;
  wire [8:0]d36_nb_parid;
  wire [0:0]d36_nb_reg_release_flag;
  wire [5:0]d36_nb_reg_sel;
  wire [31:0]dx;
  wire [31:0]dy;
  wire [31:0]dz;
  wire [3:0]elements;
  wire [8:0]home_parid;
  wire home_valid;
  wire [31:0]home_x;
  wire [31:0]home_y;
  wire [31:0]home_z;
  wire [5:0]nb_cid;
  wire [8:0]nb_parid;
  wire [0:0]nb_reg_release_flag;
  wire [5:0]nb_reg_sel;
  wire nb_valid;
  wire [31:0]nb_x;
  wire [31:0]nb_y;
  wire [31:0]nb_z;
  wire [31:0]r2;
  wire r2_valid;

  FP_RSQUARE FP_RSQUARE_i
       (.aclk(aclk),
        .d25_elements(d25_elements),
        .d36_home_parid(d36_home_parid),
        .d36_nb_cid(d36_nb_cid),
        .d36_nb_parid(d36_nb_parid),
        .d36_nb_reg_release_flag(d36_nb_reg_release_flag),
        .d36_nb_reg_sel(d36_nb_reg_sel),
        .dx(dx),
        .dy(dy),
        .dz(dz),
        .elements(elements),
        .home_parid(home_parid),
        .home_valid(home_valid),
        .home_x(home_x),
        .home_y(home_y),
        .home_z(home_z),
        .nb_cid(nb_cid),
        .nb_parid(nb_parid),
        .nb_reg_release_flag(nb_reg_release_flag),
        .nb_reg_sel(nb_reg_sel),
        .nb_valid(nb_valid),
        .nb_x(nb_x),
        .nb_y(nb_y),
        .nb_z(nb_z),
        .r2(r2),
        .r2_valid(r2_valid));
endmodule
