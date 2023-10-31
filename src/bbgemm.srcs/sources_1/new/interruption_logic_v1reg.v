`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2023 03:46:01 PM
// Design Name: 
// Module Name: interruption_logic_v1reg
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

module interruption_logic_v1reg(
//`ifdef MODEL_TECH   
	input 				clk_en,
	input [63:0] 		breakpoint,
//`endif
	input 				sys_clk,
    input               sys_resetn,
	input               difftest_break,
	
	output 				task_clk,
	output              debug_break_df
);

	reg [63:0] 			counter;
	reg 				break;
	wire                break2;
	reg                 break_df;
	assign debug_break_df = break_df;
	
//`ifndef MODEL_TECH
//	wire 				clk_en;
//	wire [63:0] 		breakpoint;
//`endif
    //assign break2 = (reg_64_monitor == breakpoint_reg_64)?1'b1:1'b0;
    
//`ifndef MODEL_TECH
//	vio_0 il_vio (
//		.clk			(sys_clk),
//		.probe_out0		(breakpoint),
//		.probe_out1		(clk_en)
//	);
//`endif
   
   always @(posedge sys_clk)begin
        if(!sys_resetn)begin
            break_df <= 0;
        end
        else begin
            break_df <= difftest_break;
        end 
   end

    
	always @(posedge sys_clk)
	begin
		if (!sys_resetn)
		begin
			counter <= 0;
			break <= 1'b0;
		end
		else if (clk_en)
		begin
			if (counter == breakpoint)
			begin
				break <= 1'b1;
			end
			else
			begin
				counter <= counter + 1;
				break <= 1'b0;
			end
		end
	end

	BUFGCE inst_bufgce (
		.O(task_clk),
		.I(sys_clk),
		.CE(clk_en & ~break ) //no break 2
	);

endmodule
