`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/02 14:41:59
// Design Name: 
// Module Name: stop_msort
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


module stop_msort(
    input ap_done,
    input clk,
    input resetn,
    output ap_stop
    );
    reg reg_ap_stop;
    assign ap_stop = reg_ap_stop;
    always@(posedge clk)begin
        if(!resetn)begin
            reg_ap_stop <= 1;
        end
        else begin
            if(ap_done)begin
                reg_ap_stop <= 0;
            end
            else begin
                reg_ap_stop <= reg_ap_stop;
            end
        end
    end
endmodule
