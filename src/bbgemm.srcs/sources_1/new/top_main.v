`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2023 12:06:24 PM
// Design Name: 
// Module Name: top_main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_main(

    );
    wire    task_clk;
    wire    irq_break;
    wire    break_df;
    wire    sys_clk;
    wire    sys_resetn;
    interruption_logic_v1reg interruption_logic_v1reg(
	.sys_clk                (sys_clk),
    .sys_resetn             (sys_resetn),
    .difftest_break         (irq_break),
	.task_clk               (task_clk),
    .debug_break_df         (break_df)
);
    
    design_1_wrapper design_1_wrapper(
    .Res_0                  (irq_break),
    .clk                    (sys_clk),
    .irq_2_empty_0          (break_df),
    .resetn                 (sys_resetn),
    .task_clk               (task_clk)
    );
    
endmodule
