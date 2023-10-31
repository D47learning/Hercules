`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/21 00:53:01
// Design Name: 
// Module Name: fold_xor
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


module fold_xor(
    input                   clk,
    input                   resetn,
    input                   we,
    input       [511:0]     dut_data,
    input       [11:0]      addr,
    output reg              enable,
    output reg  [63:0]      compress_data,
    output reg  [11:0]      out_addr
    );
    reg		[31:0]        fold_1st[0:7];
    reg     [15:0]        fold_2nd[0:7];
    reg     [8:0]         fold_3rd[0:7];
    reg     [11:0]        addr_0;
    reg     [11:0]        addr_1;
    reg     [11:0]        addr_2;
    reg     [11:0]        addr_3;
    reg     [511:0]         temp_dut_data;
    reg                     we_step0;
    reg                 we_step1;
    reg                 we_step2;
    reg                 we_step3;
    always@(posedge clk)begin
        if(!resetn)begin
            temp_dut_data <= 0;
            we_step0 <= 0;
            addr_0 <= 0;
        end
        else begin
            temp_dut_data <= dut_data;
            we_step0 <= we;
            addr_0 <= addr;
        end
    end
    
    genvar i;
    generate
        for(i=0;i<8;i=i+1) begin
            always@(posedge clk)begin
                if(!resetn)begin
                    fold_1st[i] <= 32'b0;
                    we_step1 <= 0;
                    addr_1 <= 0;
                end
                else begin
                    fold_1st[i] <= temp_dut_data[64*i+31:64*i] ^ temp_dut_data[64*i+63:64*i+32];
                    we_step1 <= we_step0;
                    addr_1 <= addr_0;
                end
            end
        end    
    endgenerate
    
    genvar j;
    generate
        for(j=0;j<8;j=j+1) begin
            always@(posedge clk)begin
                if(!resetn)begin
                    fold_2nd[j] <= 16'b0;
                    we_step2 <= 0;
                    addr_2 <= 0;
                end
                else begin
                    fold_2nd[j] <= fold_1st[j][15:0] ^ fold_1st[j][31:16];
                    we_step2 <= we_step1;
                    addr_2 <= addr_1;
                end
            end
        end    
    endgenerate
    
    genvar k;
    generate
        for(k=0;k<8;k=k+1) begin
            always@(posedge clk)begin
                if(!resetn)begin
                    fold_3rd[k] <= 8'b0;
                    we_step3 <= 0;
                    addr_3 <= 0;
                end
                else begin
                    fold_3rd[k] <= fold_2nd[k][7:0] ^ fold_2nd[k][15:8];
                    we_step3 <= we_step2;
                    addr_3 <= addr_2;
                end
            end
        end    
    endgenerate
    
    always @(posedge clk)begin
        if(!resetn)begin
            enable <= 0;
            compress_data <= 0;
            out_addr <= 0;
        end
        else begin
            compress_data <= {fold_3rd[0][7:0], fold_3rd[1][7:0], fold_3rd[2][7:0], fold_3rd[3][7:0], fold_3rd[4][7:0], fold_3rd[5][7:0], fold_3rd[6][7:0],fold_3rd[7][7:0]};
            enable <= we_step3;
            out_addr <= addr_3;
        end
    
    end
    
    
endmodule
