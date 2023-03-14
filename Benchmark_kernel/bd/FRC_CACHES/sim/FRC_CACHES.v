//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:50 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target FRC_CACHES.bd
//Design      : FRC_CACHES
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "FRC_CACHES,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=FRC_CACHES,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "FRC_CACHES.hwdef" *) 
module FRC_CACHES
   (clk,
    frc_rd_addr,
    frc_rd_data,
    frc_wr_addr,
    frc_wr_data,
    frc_wr_en);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN FRC_CACHES_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  input [8:0]frc_rd_addr;
  output [95:0]frc_rd_data;
  input [8:0]frc_wr_addr;
  input [95:0]frc_wr_data;
  input frc_wr_en;

  wire [8:0]addra_1_1;
  wire [8:0]addrb_1_1;
  wire clka_0_1;
  wire [95:0]dina_1_1;
  wire ena_1_1;
  wire [95:0]home_frc_cache_doutb;

  assign addra_1_1 = frc_wr_addr[8:0];
  assign addrb_1_1 = frc_rd_addr[8:0];
  assign clka_0_1 = clk;
  assign dina_1_1 = frc_wr_data[95:0];
  assign ena_1_1 = frc_wr_en;
  assign frc_rd_data[95:0] = home_frc_cache_doutb;
  FRC_CACHES_frc_cache_0 frc_cache
       (.addra(addra_1_1),
        .addrb(addrb_1_1),
        .clka(clka_0_1),
        .clkb(clka_0_1),
        .dina(dina_1_1),
        .doutb(home_frc_cache_doutb),
        .ena(ena_1_1),
        .wea(ena_1_1));
endmodule
