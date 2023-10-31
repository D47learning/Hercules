//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Sat Aug 19 18:29:37 2023
//Host        : LAPTOP-H5COAKG8 running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (Res_0,
    clk,
    irq_2_empty_0,
    resetn,
    task_clk);
  output [0:0]Res_0;
  output clk;
  input [0:0]irq_2_empty_0;
  output [0:0]resetn;
  input task_clk;

  wire [0:0]Res_0;
  wire clk;
  wire [0:0]irq_2_empty_0;
  wire [0:0]resetn;
  wire task_clk;

  design_1 design_1_i
       (.Res_0(Res_0),
        .clk(clk),
        .irq_2_empty_0(irq_2_empty_0),
        .resetn(resetn),
        .task_clk(task_clk));
endmodule
