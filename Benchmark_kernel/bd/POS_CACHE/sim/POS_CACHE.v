//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Wed Oct  5 21:12:03 2022
//Host        : caadlab-01 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target POS_CACHE.bd
//Design      : POS_CACHE
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "POS_CACHE,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=POS_CACHE,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "POS_CACHE.hwdef" *) 
module POS_CACHE
   (clk,
    i_data,
    i_rd_addr,
    i_rd_en,
    i_wr_addr,
    i_wr_en,
    o_data);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN POS_CACHE_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input clk;
  input [71:0]i_data;
  input [8:0]i_rd_addr;
  input i_rd_en;
  input [8:0]i_wr_addr;
  input i_wr_en;
  output [71:0]o_data;

  wire [8:0]addra_0_1;
  wire [8:0]addrb_0_1;
  wire [71:0]blk_mem_gen_0_doutb;
  wire clka_0_1;
  wire [71:0]dina_0_1;
  wire ena_0_1;
  wire enb_0_1;

  assign addra_0_1 = i_wr_addr[8:0];
  assign addrb_0_1 = i_rd_addr[8:0];
  assign clka_0_1 = clk;
  assign dina_0_1 = i_data[71:0];
  assign ena_0_1 = i_wr_en;
  assign enb_0_1 = i_rd_en;
  assign o_data[71:0] = blk_mem_gen_0_doutb;
  POS_CACHE_blk_mem_gen_1_0 blk_mem_gen_1
       (.addra(addra_0_1),
        .addrb(addrb_0_1),
        .clka(clka_0_1),
        .clkb(clka_0_1),
        .dina(dina_0_1),
        .doutb(blk_mem_gen_0_doutb),
        .ena(ena_0_1),
        .enb(enb_0_1),
        .wea(ena_0_1));
endmodule
