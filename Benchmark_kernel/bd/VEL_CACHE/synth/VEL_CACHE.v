//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:13:08 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target VEL_CACHE.bd
//Design      : VEL_CACHE
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "VEL_CACHE,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=VEL_CACHE,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "VEL_CACHE.hwdef" *) 
module VEL_CACHE
   (clk,
    rd_addr,
    vel_in,
    vel_out,
    wr_addr,
    wr_en);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN VEL_CACHE_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  input [8:0]rd_addr;
  input [95:0]vel_in;
  output [95:0]vel_out;
  input [8:0]wr_addr;
  input wr_en;

  wire [8:0]addra_0_1;
  wire [8:0]addrb_0_1;
  wire clka_0_1;
  wire [95:0]dina_0_1;
  wire ena_0_1;
  wire [95:0]vel_cache_doutb;

  assign addra_0_1 = wr_addr[8:0];
  assign addrb_0_1 = rd_addr[8:0];
  assign clka_0_1 = clk;
  assign dina_0_1 = vel_in[95:0];
  assign ena_0_1 = wr_en;
  assign vel_out[95:0] = vel_cache_doutb;
  VEL_CACHE_vel_cache_0 vel_cache
       (.addra(addra_0_1),
        .addrb(addrb_0_1),
        .clka(clka_0_1),
        .clkb(clka_0_1),
        .dina(dina_0_1),
        .doutb(vel_cache_doutb),
        .ena(ena_0_1),
        .wea(ena_0_1));
endmodule
