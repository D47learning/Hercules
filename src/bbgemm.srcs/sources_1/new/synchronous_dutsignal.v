`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/25 17:36:03
// Design Name: 
// Module Name: synchronous_dutsignal
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


module synchronous_dutsignal(
         input             [0:0]            clk,
         input             [0:0]            resetn,
         input             [0:0]           we_m2,
        input               [0:0]           we_tempx,
        input               [0:0]           we_mul,
         output    reg     [5:0]            m2_addr,
         input             [63:0]           m2_data,
         output            [0:0]            m2_enable,
         output    reg     [5:0]            tempx_addr,
         input             [63:0]           tempx_data,
         output            [0:0]            tempx_enable,
         output    reg     [5:0]            mul_addr,
         input             [63:0]           mul_data,
         output            [0:0]            mul_enable,       
         input              [0:0]           prod_we,   
         output          [63:0]          synchronous_m2,
         output          [63:0]          synchronous_tempx,
         output          [63:0]          synchronous_mul
    );
    parameter encore_buff = 8'd64;
    assign m2_enable = 1'b1;
    assign tempx_enable = 1'b1;
    assign mul_enable = 1'b1;
    reg [0:0]flag_m2;
    reg [0:0]flag_tempx;
    reg [0:0]flag_mul;
    
    assign synchronous_m2 = m2_data;
    assign synchronous_tempx = tempx_data;
    assign synchronous_mul = mul_data;
    
    reg     [2:0]           state;  
    
    
    always @(posedge clk)begin
        if(!resetn)begin
            m2_addr         <= 5'b0;
            tempx_addr      <= 5'b0;
            mul_addr        <= 5'b0;
            flag_m2         <= 1'b0;
            flag_tempx      <= 1'b0;
            flag_mul        <= 1'b0;
            state           <= 3'b0;
        end
        else begin
            case(state)
            //begin
            0: begin
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
                    state <= 1'b1;
                end
                else begin
                    state <= 1'b0;
                end
            end
            //get addr0 data
            1:begin
                if(prod_we)begin
                    m2_addr     <=  m2_addr + 1;
                    tempx_addr  <=  tempx_addr + 1;
                    mul_addr    <=  mul_addr + 1;
                    state <= 1;
                end
                else begin
                    m2_addr     <=  m2_addr;
                    tempx_addr  <=  tempx_addr;
                    mul_addr    <=  mul_addr;
                    state <= 1;
                end  
            end
            
            endcase 
        end
    end
    
endmodule
