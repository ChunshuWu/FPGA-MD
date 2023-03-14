//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:40 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FP_ADD_XYZ_D3.bd
//Design      : FP_ADD_XYZ_D3
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "FP_ADD_XYZ_D3,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=FP_ADD_XYZ_D3,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "FP_ADD_XYZ_D3.hwdef" *) 
module FP_ADD_XYZ_D3
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN FP_ADD_XYZ_D3_clk, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.DELAY_SIGNALS DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.DELAY_SIGNALS, LAYERED_METADATA undef" *) input [21:0]delay_signals;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.DELAYED_SIGNALS DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.DELAYED_SIGNALS, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 22} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 22}" *) output [21:0]delayed_signals;
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

  wire [21:0]D_0_1;
  wire aclk_0_1;
  wire [21:0]c_shift_ram_0_Q;
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

  assign D_0_1 = delay_signals[21:0];
  assign acc_valid_out = floating_point_1_m_axis_result_tvalid;
  assign aclk_0_1 = clk;
  assign delayed_signals[21:0] = c_shift_ram_0_Q;
  assign s_axis_a_tdata_0_1 = z_acc_in[31:0];
  assign s_axis_a_tdata_1_1 = y_acc_in[31:0];
  assign s_axis_a_tdata_2_1 = x_acc_in[31:0];
  assign s_axis_a_tvalid_0_1 = frag_valid;
  assign s_axis_b_tdata_0_1 = z_frag[31:0];
  assign s_axis_b_tdata_1_1 = y_frag[31:0];
  assign s_axis_b_tdata_2_1 = x_frag[31:0];
  assign x_acc_out[31:0] = floating_point_0_m_axis_result_tdata;
  assign y_acc_out[31:0] = floating_point_1_m_axis_result_tdata;
  assign z_acc_out[31:0] = floating_point_2_m_axis_result_tdata;
  FP_ADD_XYZ_D3_c_shift_ram_0_0 c_shift_ram_0
       (.CLK(aclk_0_1),
        .D(D_0_1),
        .Q(c_shift_ram_0_Q));
  FP_ADD_XYZ_D3_floating_point_0_0 floating_point_0
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(floating_point_0_m_axis_result_tdata),
        .s_axis_a_tdata(s_axis_a_tdata_2_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_2_1),
        .s_axis_b_tvalid(s_axis_a_tvalid_0_1));
  FP_ADD_XYZ_D3_floating_point_1_0 floating_point_1
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(floating_point_1_m_axis_result_tdata),
        .m_axis_result_tvalid(floating_point_1_m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata_1_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_1_1),
        .s_axis_b_tvalid(s_axis_a_tvalid_0_1));
  FP_ADD_XYZ_D3_floating_point_2_0 floating_point_2
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(floating_point_2_m_axis_result_tdata),
        .s_axis_a_tdata(s_axis_a_tdata_0_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(s_axis_a_tvalid_0_1));
endmodule
