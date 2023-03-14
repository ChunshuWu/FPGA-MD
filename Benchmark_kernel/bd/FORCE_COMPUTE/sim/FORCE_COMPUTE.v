//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:36 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FORCE_COMPUTE.bd
//Design      : FORCE_COMPUTE
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "FORCE_COMPUTE,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=FORCE_COMPUTE,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=8,numReposBlks=8,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "FORCE_COMPUTE.hwdef" *) 
module FORCE_COMPUTE
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN FORCE_COMPUTE_clk, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  input [31:0]coeff_14;
  input [31:0]coeff_8;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.DX DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.DX, LAYERED_METADATA undef" *) input [31:0]dx;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.DY DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.DY, LAYERED_METADATA undef" *) input [31:0]dy;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.DZ DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.DZ, LAYERED_METADATA undef" *) input [31:0]dz;
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

  wire [31:0]MUL_ADD_TERM_14_m_axis_result_tdata;
  wire [31:0]MUL_ADD_TERM_8_m_axis_result_tdata;
  wire MUL_ADD_TERM_8_m_axis_result_tvalid;
  wire [31:0]MUL_COEFF_14_m_axis_result_tdata;
  wire MUL_COEFF_14_m_axis_result_tvalid;
  wire [31:0]MUL_COEFF_8_m_axis_result_tdata;
  wire MUL_COEFF_8_m_axis_result_tvalid;
  wire [31:0]MUL_FX1_m_axis_result_tdata;
  wire [31:0]MUL_FX2_m_axis_result_tdata;
  wire [31:0]MUL_FX_m_axis_result_tdata;
  wire MUL_FY_m_axis_result_tvalid;
  wire [31:0]SUB_BASE_FORCE_m_axis_result_tdata;
  wire SUB_BASE_FORCE_m_axis_result_tvalid;
  wire aclk_0_1;
  wire [31:0]dx_1;
  wire [31:0]dy_1;
  wire [31:0]dz_1;
  wire [31:0]s_axis_a_tdata_0_1;
  wire [31:0]s_axis_a_tdata_0_2;
  wire [31:0]s_axis_a_tdata_0_3;
  wire [31:0]s_axis_a_tdata_1_1;
  wire s_axis_a_tvalid_0_1;
  wire [31:0]s_axis_b_tdata_0_1;
  wire [31:0]s_axis_c_tdata_0_1;
  wire [31:0]s_axis_c_tdata_1_1;

  assign aclk_0_1 = clk;
  assign dx_1 = dx[31:0];
  assign dy_1 = dy[31:0];
  assign dz_1 = dz[31:0];
  assign frc_valid = MUL_FY_m_axis_result_tvalid;
  assign fx[31:0] = MUL_FX_m_axis_result_tdata;
  assign fy[31:0] = MUL_FX1_m_axis_result_tdata;
  assign fz[31:0] = MUL_FX2_m_axis_result_tdata;
  assign s_axis_a_tdata_0_1 = term_1_14[31:0];
  assign s_axis_a_tdata_0_2 = coeff_8[31:0];
  assign s_axis_a_tdata_0_3 = coeff_14[31:0];
  assign s_axis_a_tdata_1_1 = term_1_8[31:0];
  assign s_axis_a_tvalid_0_1 = term_valid;
  assign s_axis_b_tdata_0_1 = r2[31:0];
  assign s_axis_c_tdata_0_1 = term_0_8[31:0];
  assign s_axis_c_tdata_1_1 = term_0_14[31:0];
  FORCE_COMPUTE_MUL_ADD_TERM_14_0 MUL_ADD_TERM_14
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(MUL_ADD_TERM_14_m_axis_result_tdata),
        .s_axis_a_tdata(s_axis_a_tdata_0_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_c_tdata(s_axis_c_tdata_1_1),
        .s_axis_c_tvalid(s_axis_a_tvalid_0_1));
  FORCE_COMPUTE_MUL_ADD_TERM_8_0 MUL_ADD_TERM_8
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(MUL_ADD_TERM_8_m_axis_result_tdata),
        .m_axis_result_tvalid(MUL_ADD_TERM_8_m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata_1_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_c_tdata(s_axis_c_tdata_0_1),
        .s_axis_c_tvalid(s_axis_a_tvalid_0_1));
  FORCE_COMPUTE_MUL_COEFF_14_0 MUL_COEFF_14
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(MUL_COEFF_14_m_axis_result_tdata),
        .m_axis_result_tvalid(MUL_COEFF_14_m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata_0_3),
        .s_axis_a_tvalid(MUL_ADD_TERM_8_m_axis_result_tvalid),
        .s_axis_b_tdata(MUL_ADD_TERM_14_m_axis_result_tdata),
        .s_axis_b_tvalid(MUL_ADD_TERM_8_m_axis_result_tvalid));
  FORCE_COMPUTE_MUL_COEFF_8_0 MUL_COEFF_8
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(MUL_COEFF_8_m_axis_result_tdata),
        .m_axis_result_tvalid(MUL_COEFF_8_m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata_0_2),
        .s_axis_a_tvalid(MUL_ADD_TERM_8_m_axis_result_tvalid),
        .s_axis_b_tdata(MUL_ADD_TERM_8_m_axis_result_tdata),
        .s_axis_b_tvalid(MUL_ADD_TERM_8_m_axis_result_tvalid));
  FORCE_COMPUTE_MUL_FX_0 MUL_FX
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(MUL_FX_m_axis_result_tdata),
        .s_axis_a_tdata(dx_1),
        .s_axis_a_tvalid(SUB_BASE_FORCE_m_axis_result_tvalid),
        .s_axis_b_tdata(SUB_BASE_FORCE_m_axis_result_tdata),
        .s_axis_b_tvalid(SUB_BASE_FORCE_m_axis_result_tvalid));
  FORCE_COMPUTE_MUL_FY_0 MUL_FY
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(MUL_FX1_m_axis_result_tdata),
        .m_axis_result_tvalid(MUL_FY_m_axis_result_tvalid),
        .s_axis_a_tdata(dy_1),
        .s_axis_a_tvalid(SUB_BASE_FORCE_m_axis_result_tvalid),
        .s_axis_b_tdata(SUB_BASE_FORCE_m_axis_result_tdata),
        .s_axis_b_tvalid(SUB_BASE_FORCE_m_axis_result_tvalid));
  FORCE_COMPUTE_MUL_FZ_0 MUL_FZ
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(MUL_FX2_m_axis_result_tdata),
        .s_axis_a_tdata(dz_1),
        .s_axis_a_tvalid(SUB_BASE_FORCE_m_axis_result_tvalid),
        .s_axis_b_tdata(SUB_BASE_FORCE_m_axis_result_tdata),
        .s_axis_b_tvalid(SUB_BASE_FORCE_m_axis_result_tvalid));
  FORCE_COMPUTE_SUB_BASE_FORCE_0 SUB_BASE_FORCE
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(SUB_BASE_FORCE_m_axis_result_tdata),
        .m_axis_result_tvalid(SUB_BASE_FORCE_m_axis_result_tvalid),
        .s_axis_a_tdata(MUL_COEFF_14_m_axis_result_tdata),
        .s_axis_a_tvalid(MUL_COEFF_8_m_axis_result_tvalid),
        .s_axis_b_tdata(MUL_COEFF_8_m_axis_result_tdata),
        .s_axis_b_tvalid(MUL_COEFF_14_m_axis_result_tvalid));
endmodule
