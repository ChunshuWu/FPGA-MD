//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:13:03 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target MU_PIPELINE.bd
//Design      : MU_PIPELINE
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "MU_PIPELINE,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=MU_PIPELINE,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=16,numReposBlks=16,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "MU_PIPELINE.hwdef" *) 
module MU_PIPELINE
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN MU_PIPELINE_clk, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  input [31:0]i_coeff;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.I_DELAY_SIGNALS DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.I_DELAY_SIGNALS, LAYERED_METADATA undef" *) input [73:0]i_delay_signals;
  input [31:0]i_fx;
  input [31:0]i_fy;
  input [31:0]i_fz;
  input [31:0]i_time_step;
  input i_valid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.I_VX DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.I_VX, LAYERED_METADATA undef" *) input [31:0]i_vx;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.I_VY DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.I_VY, LAYERED_METADATA undef" *) input [31:0]i_vy;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.I_VZ DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.I_VZ, LAYERED_METADATA undef" *) input [31:0]i_vz;
  output o_data_valid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.O_DELAY_SIGNALS DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.O_DELAY_SIGNALS, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 74} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 74}" *) output [73:0]o_delay_signals;
  output [31:0]o_dx;
  output [31:0]o_dy;
  output [31:0]o_dz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.O_VX DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.O_VX, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 32} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 32}" *) output [31:0]o_vx;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.O_VY DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.O_VY, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 32} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 32}" *) output [31:0]o_vy;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.O_VZ DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.O_VZ, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency data_bitwidth format long minimum {} maximum {}} value 32} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} DATA_WIDTH 32}" *) output [31:0]o_vz;

  wire [31:0]D_0_1;
  wire [73:0]D_0_2;
  wire [31:0]D_1_1;
  wire [31:0]D_2_1;
  wire [31:0]acceleration_to_vel_x_m_axis_result_tdata;
  wire [31:0]acceleration_to_vel_y_m_axis_result_tdata;
  wire acceleration_to_vel_y_m_axis_result_tvalid;
  wire [31:0]acceleration_to_vel_z_m_axis_result_tdata;
  wire aclk_0_1;
  wire [73:0]delay_signals_D13_Q;
  wire [31:0]frc_to_acceleration_x_m_axis_result_tdata;
  wire [31:0]frc_to_acceleration_y_m_axis_result_tdata;
  wire frc_to_acceleration_y_m_axis_result_tvalid;
  wire [31:0]frc_to_acceleration_z_m_axis_result_tdata;
  wire [31:0]new_vel_x_D4_Q;
  wire [31:0]new_vel_y_D4_Q;
  wire [31:0]new_vel_z_D4_Q;
  wire [31:0]s_axis_a_tdata_0_1;
  wire [31:0]s_axis_a_tdata_1_1;
  wire [31:0]s_axis_a_tdata_2_1;
  wire s_axis_a_tvalid_0_1;
  wire [31:0]s_axis_b_tdata_0_1;
  wire [31:0]s_axis_b_tdata_1_1;
  wire [31:0]vel_to_pos_x_m_axis_result_tdata;
  wire vel_to_pos_x_m_axis_result_tvalid;
  wire [31:0]vel_to_pos_y_m_axis_result_tdata;
  wire [31:0]vel_to_pos_z_m_axis_result_tdata;
  wire [31:0]vel_x_D3_Q;
  wire [31:0]vel_y_D3_Q;
  wire [31:0]vel_z_D3_Q;

  assign D_0_1 = i_vx[31:0];
  assign D_0_2 = i_delay_signals[73:0];
  assign D_1_1 = i_vz[31:0];
  assign D_2_1 = i_vy[31:0];
  assign aclk_0_1 = clk;
  assign o_data_valid = vel_to_pos_x_m_axis_result_tvalid;
  assign o_delay_signals[73:0] = delay_signals_D13_Q;
  assign o_dx[31:0] = vel_to_pos_x_m_axis_result_tdata;
  assign o_dy[31:0] = vel_to_pos_y_m_axis_result_tdata;
  assign o_dz[31:0] = vel_to_pos_z_m_axis_result_tdata;
  assign o_vx[31:0] = new_vel_x_D4_Q;
  assign o_vy[31:0] = new_vel_y_D4_Q;
  assign o_vz[31:0] = new_vel_z_D4_Q;
  assign s_axis_a_tdata_0_1 = i_fz[31:0];
  assign s_axis_a_tdata_1_1 = i_fy[31:0];
  assign s_axis_a_tdata_2_1 = i_fx[31:0];
  assign s_axis_a_tvalid_0_1 = i_valid;
  assign s_axis_b_tdata_0_1 = i_time_step[31:0];
  assign s_axis_b_tdata_1_1 = i_coeff[31:0];
  MU_PIPELINE_acceleration_to_vel_x_0 acceleration_to_vel_x
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(acceleration_to_vel_x_m_axis_result_tdata),
        .s_axis_a_tdata(frc_to_acceleration_x_m_axis_result_tdata),
        .s_axis_a_tvalid(frc_to_acceleration_y_m_axis_result_tvalid),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(frc_to_acceleration_y_m_axis_result_tvalid),
        .s_axis_c_tdata(vel_x_D3_Q),
        .s_axis_c_tvalid(frc_to_acceleration_y_m_axis_result_tvalid));
  MU_PIPELINE_acceleration_to_vel_y_0 acceleration_to_vel_y
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(acceleration_to_vel_y_m_axis_result_tdata),
        .m_axis_result_tvalid(acceleration_to_vel_y_m_axis_result_tvalid),
        .s_axis_a_tdata(frc_to_acceleration_y_m_axis_result_tdata),
        .s_axis_a_tvalid(frc_to_acceleration_y_m_axis_result_tvalid),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(frc_to_acceleration_y_m_axis_result_tvalid),
        .s_axis_c_tdata(vel_y_D3_Q),
        .s_axis_c_tvalid(frc_to_acceleration_y_m_axis_result_tvalid));
  MU_PIPELINE_acceleration_to_vel_z_0 acceleration_to_vel_z
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(acceleration_to_vel_z_m_axis_result_tdata),
        .s_axis_a_tdata(frc_to_acceleration_z_m_axis_result_tdata),
        .s_axis_a_tvalid(frc_to_acceleration_y_m_axis_result_tvalid),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(frc_to_acceleration_y_m_axis_result_tvalid),
        .s_axis_c_tdata(vel_z_D3_Q),
        .s_axis_c_tvalid(frc_to_acceleration_y_m_axis_result_tvalid));
  MU_PIPELINE_delay_signals_D13_0 delay_signals_D13
       (.CLK(aclk_0_1),
        .D(D_0_2),
        .Q(delay_signals_D13_Q));
  MU_PIPELINE_frc_to_acceleration_x_0 frc_to_acceleration_x
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(frc_to_acceleration_x_m_axis_result_tdata),
        .s_axis_a_tdata(s_axis_a_tdata_2_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_1_1),
        .s_axis_b_tvalid(s_axis_a_tvalid_0_1));
  MU_PIPELINE_frc_to_acceleration_y_0 frc_to_acceleration_y
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(frc_to_acceleration_y_m_axis_result_tdata),
        .m_axis_result_tvalid(frc_to_acceleration_y_m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata_1_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_1_1),
        .s_axis_b_tvalid(s_axis_a_tvalid_0_1));
  MU_PIPELINE_frc_to_acceleration_z_0 frc_to_acceleration_z
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(frc_to_acceleration_z_m_axis_result_tdata),
        .s_axis_a_tdata(s_axis_a_tdata_0_1),
        .s_axis_a_tvalid(s_axis_a_tvalid_0_1),
        .s_axis_b_tdata(s_axis_b_tdata_1_1),
        .s_axis_b_tvalid(s_axis_a_tvalid_0_1));
  MU_PIPELINE_new_vel_x_D4_0 new_vel_x_D4
       (.CLK(aclk_0_1),
        .D(acceleration_to_vel_x_m_axis_result_tdata),
        .Q(new_vel_x_D4_Q));
  MU_PIPELINE_new_vel_y_D4_0 new_vel_y_D4
       (.CLK(aclk_0_1),
        .D(acceleration_to_vel_y_m_axis_result_tdata),
        .Q(new_vel_y_D4_Q));
  MU_PIPELINE_new_vel_z_D4_0 new_vel_z_D4
       (.CLK(aclk_0_1),
        .D(acceleration_to_vel_z_m_axis_result_tdata),
        .Q(new_vel_z_D4_Q));
  MU_PIPELINE_vel_to_dx_0 vel_to_dx
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(vel_to_pos_x_m_axis_result_tdata),
        .m_axis_result_tvalid(vel_to_pos_x_m_axis_result_tvalid),
        .s_axis_a_tdata(acceleration_to_vel_x_m_axis_result_tdata),
        .s_axis_a_tvalid(acceleration_to_vel_y_m_axis_result_tvalid),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(acceleration_to_vel_y_m_axis_result_tvalid));
  MU_PIPELINE_vel_to_dy_0 vel_to_dy
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(vel_to_pos_y_m_axis_result_tdata),
        .s_axis_a_tdata(acceleration_to_vel_y_m_axis_result_tdata),
        .s_axis_a_tvalid(acceleration_to_vel_y_m_axis_result_tvalid),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(acceleration_to_vel_y_m_axis_result_tvalid));
  MU_PIPELINE_vel_to_dz_0 vel_to_dz
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(vel_to_pos_z_m_axis_result_tdata),
        .s_axis_a_tdata(acceleration_to_vel_z_m_axis_result_tdata),
        .s_axis_a_tvalid(acceleration_to_vel_y_m_axis_result_tvalid),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(acceleration_to_vel_y_m_axis_result_tvalid));
  MU_PIPELINE_vel_x_D4_0 vel_x_D4
       (.CLK(aclk_0_1),
        .D(D_0_1),
        .Q(vel_x_D3_Q));
  MU_PIPELINE_vel_y_D4_0 vel_y_D4
       (.CLK(aclk_0_1),
        .D(D_2_1),
        .Q(vel_y_D3_Q));
  MU_PIPELINE_vel_z_D4_0 vel_z_D4
       (.CLK(aclk_0_1),
        .D(D_1_1),
        .Q(vel_z_D3_Q));
endmodule
