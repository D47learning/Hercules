`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/25 21:50:41
// Design Name: 
// Module Name: gen_writedown
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


module gen_writedown(
    input               [0:0]           clk,
    input               [0:0]           resetn,
    input               [0:0]           we_m2,
    input               [0:0]           we_tempx,
    input               [0:0]           we_mul,
    output    reg       [0:0]           writedown
    );
    reg [0:0]flag_m2;
    reg [0:0]flag_tempx;
    reg [0:0]flag_mul;
    always@(posedge clk)begin
        if(!resetn)begin
            writedown <= 0;
            flag_m2 <= 0;
            flag_tempx <= 0;
            flag_mul <= 0;
        end
        else begin
            if(we_m2)begin
                flag_m2 <= 1'b1;
            end
            else begin
                flag_m2 <= flag_m2;
            end
            if(we_tempx)begin
                flag_tempx <= 1'b1;
            end
            else begin
                flag_tempx <= flag_tempx;
            end
            if(we_mul)begin
                flag_mul <= 1'b1;
            end
            else begin
                flag_mul <= flag_mul;
            end
            if(flag_m2 && flag_tempx && flag_mul)begin
                writedown <= 1'b1;
            end
            else begin
                writedown <= 1'b0;
            end
        end
    end
    
    
endmodule
