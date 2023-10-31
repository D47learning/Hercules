`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/25 23:01:15
// Design Name: 
// Module Name: take_beat
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


module take_beat(
    input           clk,
    input           resetn,
    input           we,
    input   [63:0]  data,
    input   [11:0]  addr,
    output reg[11:0]addr_out,
    output reg      we_out,
    output reg[63:0]data_out
    
    );
    always@(posedge clk)begin
        if(!resetn)begin
            we_out <= 0;
            data_out <= 0;
            addr_out <= 0;
        end
        else begin
            we_out <= we;
            data_out <= data;
            addr_out <= addr;
        end
    end
    
    
endmodule
