//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:25 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FORCE_LUT.bd
//Design      : FORCE_LUT
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "FORCE_LUT,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=FORCE_LUT,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "FORCE_LUT.hwdef" *) 
module FORCE_LUT
   (addr,
    clk,
    data_in,
    rd_en,
    term_0_14,
    term_0_8,
    term_1_14,
    term_1_8,
    wr_en);
  input [11:0]addr;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN FORCE_LUT_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  input [31:0]data_in;
  input rd_en;
  output [31:0]term_0_14;
  output [31:0]term_0_8;
  output [31:0]term_1_14;
  output [31:0]term_1_8;
  input [0:0]wr_en;

  wire [31:0]FORCE_LUT_0_14_douta;
  wire [31:0]FORCE_LUT_0_8_douta;
  wire [31:0]FORCE_LUT_1_14_douta;
  wire [31:0]FORCE_LUT_1_8_douta;
  wire [11:0]addra_0_1;
  wire clka_0_1;
  wire [31:0]dina_0_1;
  wire ena_0_1;
  wire [0:0]wea_0_1;

  assign addra_0_1 = addr[11:0];
  assign clka_0_1 = clk;
  assign dina_0_1 = data_in[31:0];
  assign ena_0_1 = rd_en;
  assign term_0_14[31:0] = FORCE_LUT_0_14_douta;
  assign term_0_8[31:0] = FORCE_LUT_0_8_douta;
  assign term_1_14[31:0] = FORCE_LUT_1_14_douta;
  assign term_1_8[31:0] = FORCE_LUT_1_8_douta;
  assign wea_0_1 = wr_en[0];
  FORCE_LUT_FORCE_LUT_0_14_0 FORCE_LUT_0_14
       (.addra(addra_0_1),
        .clka(clka_0_1),
        .dina(dina_0_1),
        .douta(FORCE_LUT_0_14_douta),
        .ena(ena_0_1),
        .wea(wea_0_1));
  FORCE_LUT_FORCE_LUT_0_8_0 FORCE_LUT_0_8
       (.addra(addra_0_1),
        .clka(clka_0_1),
        .dina(dina_0_1),
        .douta(FORCE_LUT_0_8_douta),
        .ena(ena_0_1),
        .wea(wea_0_1));
  FORCE_LUT_FORCE_LUT_1_14_0 FORCE_LUT_1_14
       (.addra(addra_0_1),
        .clka(clka_0_1),
        .dina(dina_0_1),
        .douta(FORCE_LUT_1_14_douta),
        .ena(ena_0_1),
        .wea(wea_0_1));
  FORCE_LUT_FORCE_LUT_1_8_0 FORCE_LUT_1_8
       (.addra(addra_0_1),
        .clka(clka_0_1),
        .dina(dina_0_1),
        .douta(FORCE_LUT_1_8_douta),
        .ena(ena_0_1),
        .wea(wea_0_1));
endmodule
