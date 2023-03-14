//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:18 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FP_RSQUARE.bd
//Design      : FP_RSQUARE
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "FP_RSQUARE,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=FP_RSQUARE,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=17,numReposBlks=17,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "FP_RSQUARE.hwdef" *) 
module FP_RSQUARE
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ACLK, CLK_DOMAIN FP_RSQUARE_aclk, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.D25_ELEMENTS DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.D25_ELEMENTS, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 4} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 4}" *) output [3:0]d25_elements;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.D36_HOME_PARID DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.D36_HOME_PARID, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 9} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 9}" *) output [8:0]d36_home_parid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.D36_NB_CID DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.D36_NB_CID, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 6} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 6}" *) output [5:0]d36_nb_cid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.D36_NB_PARID DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.D36_NB_PARID, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 9} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 9}" *) output [8:0]d36_nb_parid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.D36_NB_REG_RELEASE_FLAG DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.D36_NB_REG_RELEASE_FLAG, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 1} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 1}" *) output [0:0]d36_nb_reg_release_flag;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.D36_NB_REG_SEL DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.D36_NB_REG_SEL, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 6} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 6}" *) output [5:0]d36_nb_reg_sel;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.DX DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.DX, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 32} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 32}" *) output [31:0]dx;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.DY DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.DY, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 32} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 32}" *) output [31:0]dy;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.DZ DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.DZ, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 32} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 32}" *) output [31:0]dz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.ELEMENTS DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.ELEMENTS, LAYERED_METADATA undef" *) input [3:0]elements;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.HOME_PARID DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.HOME_PARID, LAYERED_METADATA undef" *) input [8:0]home_parid;
  input home_valid;
  input [31:0]home_x;
  input [31:0]home_y;
  input [31:0]home_z;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.NB_CID DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.NB_CID, LAYERED_METADATA undef" *) input [5:0]nb_cid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.NB_PARID DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.NB_PARID, LAYERED_METADATA undef" *) input [8:0]nb_parid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.NB_REG_RELEASE_FLAG DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.NB_REG_RELEASE_FLAG, LAYERED_METADATA undef" *) input [0:0]nb_reg_release_flag;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.NB_REG_SEL DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.NB_REG_SEL, LAYERED_METADATA undef" *) input [5:0]nb_reg_sel;
  input nb_valid;
  input [31:0]nb_x;
  input [31:0]nb_y;
  input [31:0]nb_z;
  output [31:0]r2;
  output r2_valid;

  wire [8:0]D_0_1;
  wire [3:0]D_0_2;
  wire [5:0]D_0_3;
  wire [5:0]D_0_4;
  wire [8:0]D_1_1;
  wire [0:0]D_1_2;
  wire aclk_0_1;
  wire [31:0]dx2_dy2_m_axis_result_tdata;
  wire dx2_dy2_m_axis_result_tvalid;
  wire [31:0]dx2_m_axis_result_tdata;
  wire dx2_m_axis_result_tvalid;
  wire [31:0]dx_d14_Q;
  wire [31:0]dx_m_axis_result_tdata;
  wire dx_m_axis_result_tvalid;
  wire [31:0]dy_d10_Q;
  wire [31:0]dy_d4_Q;
  wire [31:0]dy_m_axis_result_tdata;
  wire [31:0]dz_d5_Q;
  wire [31:0]dz_d9_Q;
  wire [31:0]dz_m_axis_result_tdata;
  wire [3:0]elements_d18_Q;
  wire [8:0]home_parid_d17_Q;
  wire [8:0]home_parid_d18_Q;
  wire [5:0]nb_cid_d36_Q;
  wire [0:0]nb_reg_release_sel_d36_Q;
  wire [5:0]nb_reg_sel_d37_Q;
  wire [31:0]r2_m_axis_result_tdata;
  wire r2_m_axis_result_tvalid;
  wire [31:0]s_axis_a_tdata_0_1;
  wire [31:0]s_axis_a_tdata_0_2;
  wire [31:0]s_axis_a_tdata_0_3;
  wire s_axis_a_tvalid_0_1;
  wire [31:0]s_axis_b_tdata_0_1;
  wire [31:0]s_axis_b_tdata_0_2;
  wire [31:0]s_axis_b_tdata_0_3;
  wire s_axis_b_tvalid_0_1;

  assign D_0_1 = nb_parid[8:0];
  assign D_0_2 = elements[3:0];
  assign D_0_3 = nb_cid[5:0];
  assign D_0_4 = nb_reg_sel[5:0];
  assign D_1_1 = home_parid[8:0];
  assign D_1_2 = nb_reg_release_flag[0];
  assign aclk_0_1 = aclk;
  assign d25_elements[3:0] = elements_d18_Q;
  assign d36_home_parid[8:0] = home_parid_d17_Q;
  assign d36_nb_cid[5:0] = nb_cid_d36_Q;
  assign d36_nb_parid[8:0] = home_parid_d18_Q;
  assign d36_nb_reg_release_flag[0] = nb_reg_release_sel_d36_Q;
  assign d36_nb_reg_sel[5:0] = nb_reg_sel_d37_Q;
  assign dx[31:0] = dx_d14_Q;
  assign dy[31:0] = dy_d10_Q;
  assign dz[31:0] = dz_d5_Q;
  assign r2[31:0] = r2_m_axis_result_tdata;
  assign r2_valid = r2_m_axis_result_tvalid;
  assign s_axis_a_tdata_0_1 = home_x[31:0];
  assign s_axis_a_tdata_0_2 = home_y[31:0];
  assign s_axis_a_tdata_0_3 = home_z[31:0];
  assign s_axis_a_tvalid_0_1 = home_valid;
  assign s_axis_b_tdata_0_1 = nb_x[31:0];
  assign s_axis_b_tdata_0_2 = nb_y[31:0];
  assign s_axis_b_tdata_0_3 = nb_z[31:0];
  assign s_axis_b_tvalid_0_1 = nb_valid;
  FP_RSQUARE_dx_0 dx_RnM
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(dx_m_axis_result_tdata),
        .m_axis_result_tvalid(dx_m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata_0_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(s_axis_b_tvalid_0_1));
  FP_RSQUARE_dx2_0 dx2
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(dx2_m_axis_result_tdata),
        .m_axis_result_tvalid(dx2_m_axis_result_tvalid),
        .s_axis_a_tdata(dx_m_axis_result_tdata),
        .s_axis_a_tvalid(dx_m_axis_result_tvalid),
        .s_axis_b_tdata(dx_m_axis_result_tdata),
        .s_axis_b_tvalid(dx_m_axis_result_tvalid));
  FP_RSQUARE_dx2_dy2_0 dx2_dy2
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(dx2_dy2_m_axis_result_tdata),
        .m_axis_result_tvalid(dx2_dy2_m_axis_result_tvalid),
        .s_axis_a_tdata(dy_d4_Q),
        .s_axis_a_tvalid(dx2_m_axis_result_tvalid),
        .s_axis_b_tdata(dy_d4_Q),
        .s_axis_b_tvalid(dx2_m_axis_result_tvalid),
        .s_axis_c_tdata(dx2_m_axis_result_tdata),
        .s_axis_c_tvalid(dx2_m_axis_result_tvalid));
  FP_RSQUARE_dx_d28_0 dx_d28
       (.CLK(aclk_0_1),
        .D(dx_m_axis_result_tdata),
        .Q(dx_d14_Q));
  FP_RSQUARE_dy_0 dy_RnM
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(dy_m_axis_result_tdata),
        .s_axis_a_tdata(s_axis_a_tdata_0_2),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_0_2),
        .s_axis_b_tvalid(s_axis_b_tvalid_0_1));
  FP_RSQUARE_dy_d24_0 dy_d24
       (.CLK(aclk_0_1),
        .D(dy_d4_Q),
        .Q(dy_d10_Q));
  FP_RSQUARE_dy_d4_0 dy_d4
       (.CLK(aclk_0_1),
        .D(dy_m_axis_result_tdata),
        .Q(dy_d4_Q));
  FP_RSQUARE_dz_0 dz_RnM
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(dz_m_axis_result_tdata),
        .s_axis_a_tdata(s_axis_a_tdata_0_3),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_0_3),
        .s_axis_b_tvalid(s_axis_b_tvalid_0_1));
  FP_RSQUARE_dz_d19_0 dz_d19
       (.CLK(aclk_0_1),
        .D(dz_d9_Q),
        .Q(dz_d5_Q));
  FP_RSQUARE_dz_d9_0 dz_d9
       (.CLK(aclk_0_1),
        .D(dz_m_axis_result_tdata),
        .Q(dz_d9_Q));
  FP_RSQUARE_elements_d25_0 elements_d25
       (.CLK(aclk_0_1),
        .D(D_0_2),
        .Q(elements_d18_Q));
  FP_RSQUARE_home_parid_d36_0 home_parid_d36
       (.CLK(aclk_0_1),
        .D(D_1_1),
        .Q(home_parid_d17_Q));
  FP_RSQUARE_nb_cid_d36_0 nb_cid_d36
       (.CLK(aclk_0_1),
        .D(D_0_3),
        .Q(nb_cid_d36_Q));
  FP_RSQUARE_nb_parid_d36_0 nb_parid_d36
       (.CLK(aclk_0_1),
        .D(D_0_1),
        .Q(home_parid_d18_Q));
  FP_RSQUARE_nb_reg_release_sel_d36_0 nb_reg_release_sel_d36
       (.CLK(aclk_0_1),
        .D(D_1_2),
        .Q(nb_reg_release_sel_d36_Q));
  FP_RSQUARE_nb_reg_sel_d36_0 nb_reg_sel_d36
       (.CLK(aclk_0_1),
        .D(D_0_4),
        .Q(nb_reg_sel_d37_Q));
  FP_RSQUARE_r2_0 r2_RnM
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(r2_m_axis_result_tdata),
        .m_axis_result_tvalid(r2_m_axis_result_tvalid),
        .s_axis_a_tdata(dz_d9_Q),
        .s_axis_a_tvalid(dx2_dy2_m_axis_result_tvalid),
        .s_axis_b_tdata(dz_d9_Q),
        .s_axis_b_tvalid(dx2_dy2_m_axis_result_tvalid),
        .s_axis_c_tdata(dx2_dy2_m_axis_result_tdata),
        .s_axis_c_tvalid(dx2_dy2_m_axis_result_tvalid));
endmodule
