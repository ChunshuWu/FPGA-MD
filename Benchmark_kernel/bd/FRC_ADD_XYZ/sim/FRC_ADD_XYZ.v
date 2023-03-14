//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:47 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FRC_ADD_XYZ.bd
//Design      : FRC_ADD_XYZ
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "FRC_ADD_XYZ,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=FRC_ADD_XYZ,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "FRC_ADD_XYZ.hwdef" *) 
module FRC_ADD_XYZ
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN FRC_ADD_XYZ_clk, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
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

  wire aclk_0_1;
  wire [31:0]floating_point_0_m_axis_result_tdata;
  wire [31:0]floating_point_1_m_axis_result_tdata;
  wire floating_point_1_m_axis_result_tvalid;
  wire [31:0]floating_point_2_m_axis_result_tdata;
  wire [31:0]s_axis_a_tdata_0_1;
  wire [31:0]s_axis_a_tdata_1_1;
  wire [31:0]s_axis_a_tdata_2_1;
  wire s_axis_a_tvalid_0_1;
  wire [31:0]s_axis_b_tdata_0_1;
  wire [31:0]s_axis_b_tdata_1_1;
  wire [31:0]s_axis_b_tdata_2_1;
  wire s_axis_b_tvalid_0_1;

  assign aclk_0_1 = clk;
  assign frc_acc_valid = floating_point_1_m_axis_result_tvalid;
  assign frc_acc_x[31:0] = floating_point_0_m_axis_result_tdata;
  assign frc_acc_y[31:0] = floating_point_1_m_axis_result_tdata;
  assign frc_acc_z[31:0] = floating_point_2_m_axis_result_tdata;
  assign s_axis_a_tdata_0_1 = frc_z1[31:0];
  assign s_axis_a_tdata_1_1 = frc_y1[31:0];
  assign s_axis_a_tdata_2_1 = frc_x1[31:0];
  assign s_axis_a_tvalid_0_1 = frc_valid_1;
  assign s_axis_b_tdata_0_1 = frc_z2[31:0];
  assign s_axis_b_tdata_1_1 = frc_y2[31:0];
  assign s_axis_b_tdata_2_1 = frc_x2[31:0];
  assign s_axis_b_tvalid_0_1 = frc_valid_2;
  FRC_ADD_XYZ_floating_point_0_0 floating_point_0
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(floating_point_0_m_axis_result_tdata),
        .s_axis_a_tdata(s_axis_a_tdata_2_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_2_1),
        .s_axis_b_tvalid(s_axis_b_tvalid_0_1));
  FRC_ADD_XYZ_floating_point_1_0 floating_point_1
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(floating_point_1_m_axis_result_tdata),
        .m_axis_result_tvalid(floating_point_1_m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata_1_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_1_1),
        .s_axis_b_tvalid(s_axis_b_tvalid_0_1));
  FRC_ADD_XYZ_floating_point_2_0 floating_point_2
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(floating_point_2_m_axis_result_tdata),
        .s_axis_a_tdata(s_axis_a_tdata_0_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(s_axis_b_tvalid_0_1));
endmodule
