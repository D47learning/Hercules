`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2022 09:29:16 AM
// Design Name: 
// Module Name: fifo_control
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


module fifo_control(
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI, ID_WIDTH 16" *)    input   [39:0]    s_axi_araddr,                      //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARBURST" *)  input   [1:0]     s_axi_arburst,    //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARCACHE" *)  input   [3:0]     s_axi_arcache,    //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARLEN" *)    input   [7:0]     s_axi_arlen,      //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARLOCK" *)   input   [0:0]     s_axi_arlock,     //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *)   input   [2:0]     s_axi_arprot,     //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)  output  [0:0]     s_axi_arready,                     //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARSIZE" *)   input   [2:0]     s_axi_arsize,     //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)  input   [0:0]     s_axi_arvalid,                     //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)   input   [39:0]    s_axi_awaddr,                      //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWBURST" *)  input   [1:0]     s_axi_awburst,    //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWCACHE" *)  input   [3:0]     s_axi_awcache,    //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWLEN" *)    input   [7:0]     s_axi_awlen,      //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWLOCK" *)   input   [0:0]     s_axi_awlock,     //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *)   input   [2:0]     s_axi_awprot,     //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)  output  [0:0]     s_axi_awready,                     //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWSIZE" *)   input   [2:0]     s_axi_awsize,     //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)  input   [0:0]     s_axi_awvalid,                     //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)   input   [0:0]     s_axi_bready,                      //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)    output  [1:0]     s_axi_bresp,      //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)   output  [0:0]     s_axi_bvalid,                      //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)    output  [127:0]   s_axi_rdata,                       //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RLAST" *)    output  [0:0]     s_axi_rlast,                       //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)   input   [0:0]     s_axi_rready,                      //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)    output  [1:0]     s_axi_rresp,      //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)   output  [0:0]     s_axi_rvalid,                      //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)    input   [127:0]   s_axi_wdata,                       //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WLAST" *)    input   [0:0]     s_axi_wlast,                       //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)   output  [0:0]     s_axi_wready,                      //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)    input   [15:0]    s_axi_wstrb,      //               //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)   input   [0:0]     s_axi_wvalid,                      //axi
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BID" *)      output  [15:0]    s_axi_bid,
 (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWID" *)     input   [15:0]    s_axi_awid,
  input   [0:0]     s_axi_aclk,                        //axi
  input   [0:0]     s_axi_aresetn,                     //axi
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE ALMOST_FULL" *) input   [0:0]     fifo_almost_full,
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *)        input   [0:0]     fifo_full,
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *)     output  [127:0]   fifo_wr_data,
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *)       output  [0:0]     fifo_wr_en
    );
    
    reg     [0:0]       reg_s_axi_arready;
    reg     [0:0]       reg_s_axi_awready;
    reg     [1:0]       reg_s_axi_bresp;
    reg     [0:0]       reg_s_axi_bvalid;
    reg     [0:0]       reg_s_axi_wready;
    reg     [127:0]     reg_fifo_wr_data;
    reg     [0:0]       reg_fifo_wr_en;
    reg     [15:0]      reg_s_axi_bid;
    reg     [2:0]       state = 0;
    
    assign s_axi_arready = reg_s_axi_arready;
    assign s_axi_awready = reg_s_axi_awready;
    assign s_axi_bresp = reg_s_axi_bresp;
    assign s_axi_bvalid = reg_s_axi_bvalid;
    assign s_axi_wready = reg_s_axi_wready;
    assign fifo_wr_data = reg_fifo_wr_data;
    assign fifo_wr_en = reg_fifo_wr_en;
    assign s_axi_bid = reg_s_axi_bid;

    parameter AXI_READY = 3'd0;
    parameter AXI_AW1   = 3'd1;
    parameter AXI_AW2   = 3'd2;
    parameter AXI_AW3   = 3'd3;
    parameter AXI_B     = 3'd4;
    
    always @(posedge s_axi_aclk)begin
        if(!s_axi_aresetn) begin
            reg_s_axi_arready <= 0;
            reg_s_axi_awready <= 0;
            reg_s_axi_bresp <= 0;
            reg_s_axi_bvalid <= 0;
            reg_s_axi_wready <= 0;
            reg_fifo_wr_en <= 0;
            state <= AXI_READY;
        end
        else begin
            case(state)
            AXI_READY:begin                                 //ready
                reg_s_axi_bvalid <= 0;
                reg_s_axi_bresp <= 0;
                if(s_axi_awvalid) begin
                    state <= AXI_AW1;
                end
                else begin
                    state <= AXI_READY;
                end
            end
            AXI_AW1:begin                                 //axi_aw
                if(!fifo_full && !fifo_almost_full) begin
                    reg_s_axi_awready <= 1;
                    reg_s_axi_bid <= s_axi_awid;
                    state <= AXI_AW2;
                end
                else begin
                    state <= AXI_AW1;
                end
            end
            AXI_AW2:begin                                 //aw_step1
                reg_s_axi_awready <= 0;
                reg_s_axi_wready <= 1;
                state <= AXI_AW3;
            end
            AXI_AW3:begin                                 //aw_step2
                reg_s_axi_wready <= 0;
                if(s_axi_wvalid && reg_s_axi_wready)begin
                    reg_fifo_wr_data <= s_axi_wdata;
                    reg_fifo_wr_en <= 1;
                    state <= AXI_B;
                end
                else begin
                    state <= AXI_AW2;
                end
            end
            AXI_B:begin                                 //axi_b
                reg_fifo_wr_en <= 0;
                reg_s_axi_bvalid <= 1;
                reg_s_axi_bresp <= 0;
                state <= AXI_READY;
            end
            
            endcase
        end
    end
endmodule
