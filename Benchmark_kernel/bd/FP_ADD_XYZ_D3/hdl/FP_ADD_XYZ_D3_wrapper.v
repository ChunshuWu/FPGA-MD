//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:40 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FP_ADD_XYZ_D3_wrapper.bd
//Design      : FP_ADD_XYZ_D3_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module FP_ADD_XYZ_D3_wrapper
   (acc_valid_out,
    clk,
    delay_signals,
    delayed_signals,
    frag_valid,
    x_acc_in,
    x_acc_out,
    x_frag,
    y_acc_in,
    y_acc_out,
    y_frag,
    z_acc_in,
    z_acc_out,
    z_frag);
  output acc_valid_out;
  input clk;
  input [21:0]delay_signals;
  output [21:0]delayed_signals;
  input frag_valid;
  input [31:0]x_acc_in;
  output [31:0]x_acc_out;
  input [31:0]x_frag;
  input [31:0]y_acc_in;
  output [31:0]y_acc_out;
  input [31:0]y_frag;
  input [31:0]z_acc_in;
  output [31:0]z_acc_out;
  input [31:0]z_frag;

  wire acc_valid_out;
  wire clk;
  wire [21:0]delay_signals;
  wire [21:0]delayed_signals;
  wire frag_valid;
  wire [31:0]x_acc_in;
  wire [31:0]x_acc_out;
  wire [31:0]x_frag;
  wire [31:0]y_acc_in;
  wire [31:0]y_acc_out;
  wire [31:0]y_frag;
  wire [31:0]z_acc_in;
  wire [31:0]z_acc_out;
  wire [31:0]z_frag;

  FP_ADD_XYZ_D3 FP_ADD_XYZ_D3_i
       (.acc_valid_out(acc_valid_out),
        .clk(clk),
        .delay_signals(delay_signals),
        .delayed_signals(delayed_signals),
        .frag_valid(frag_valid),
        .x_acc_in(x_acc_in),
        .x_acc_out(x_acc_out),
        .x_frag(x_frag),
        .y_acc_in(y_acc_in),
        .y_acc_out(y_acc_out),
        .y_frag(y_frag),
        .z_acc_in(z_acc_in),
        .z_acc_out(z_acc_out),
        .z_frag(z_frag));
endmodule
