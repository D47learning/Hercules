module dut_data_generator(
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE ALMOST_FULL" *) input   [0:0]     fifo_almost_full,
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *)        input   [0:0]     fifo_full,
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *)     output  [127:0]   fifo_wr_data,
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *)       output  [0:0]     fifo_wr_en,
  input     [0:0]       clk,
  input     [0:0]       resetn,
  input     [11:0]      dut_address,             //dut_address
  input     [63:0]      dut_data,            //dut_data
  input     [0:0]       instr_exed,
  input     [0:0]       irq_2_empty,
  input     [0:0]       right,
  output    [0:0]       irq_2_full,
  output    [0:0]       clk_dut_right,
  output    [2:0]       out_state
);
  reg   [127:0]     reg_fifo_wr_data;
  reg   [0:0]       reg_fifo_wr_en;
  reg   [2:0]       state = 0;
  reg   [0:0]       reg_irq_2_full;
  reg   [7:0]       irq_counter;
  reg   [127:0]     temp_full_fifo_data1;
  reg   [0:0]       temp_full_fifo_instr_exed1;
  reg   [127:0]     temp_full_fifo_data2;
  reg   [0:0]       temp_full_fifo_instr_exed2;
  reg   [0:0]       mark_instr2;
  reg   [0:0]       temp_irq_2_empty;
  reg   [0:0]       reg_clk_dut_right;
  
  //reg   [127:0]     test_PC;
  
  assign fifo_wr_data = reg_fifo_wr_data;
  assign fifo_wr_en = reg_fifo_wr_en;
  assign irq_2_full = reg_irq_2_full;
  assign out_state = state;
  assign clk_dut_right = reg_clk_dut_right;
  
  parameter DUT_READY   = 3'd0;
  parameter DUT_WRITE   = 3'd1;
  parameter DUT_FULL_1  = 3'd2;
  parameter DUT_IRQ     = 3'd3;
  parameter DUT_FULL_2  = 3'd4;
  parameter DUT_FULL_3  = 3'd5;
  parameter DUT_FULL_4  = 3'd6;
  parameter DUT_FULL_5  = 3'd7;


  always@(posedge clk)begin
    if(!resetn) begin
        reg_clk_dut_right <= 0;
    end
    else begin
        reg_clk_dut_right <= right;
    end
  end
  
  
  always@(posedge clk)begin
    if(!resetn)begin
        reg_fifo_wr_data <= 128'h0000_0000_0000_0000_0000_0000_8000_0000;
        reg_fifo_wr_en <= 0;
        reg_irq_2_full <= 0;
        mark_instr2 <= 0;
        temp_irq_2_empty <= 0;
        irq_counter <= 0;
        state <= DUT_READY;
    end
    else begin
        case(state)
        //Status 0, preparation phase
        DUT_READY:begin 
            reg_fifo_wr_en <= 0;
            state <= DUT_WRITE;
        end
        //State 1, write data to the FIFO on the DUT side
        DUT_WRITE:begin
            reg_fifo_wr_en <= 0;
            //The instr_exed signal indicates whether the PC value is valid. When the FIFO is not full and the PC value is valid, it is written into the FIFO
            if(instr_exed && !fifo_almost_full && !fifo_full)begin
                reg_fifo_wr_en <= 1;
                reg_fifo_wr_data <= {52'd0,dut_address,dut_data};
                //If the current DUT is interrupted (sent by the difftest module), the PC will be written only once
                if(irq_2_empty)begin
                    state <= DUT_IRQ;
                end
                else begin
                    state <= DUT_WRITE;
                end               
            end
            //If the FIFO is full at this time, it cannot be written. Need to temporarily save the PC and register values in the current state
            else if(fifo_almost_full) begin
                //fix full_fifo
                temp_full_fifo_data1 <= {52'd0,dut_address,dut_data};
                temp_full_fifo_instr_exed1 <= instr_exed;
                if(irq_2_empty)begin
                    temp_irq_2_empty <= 1;
                end
                else begin
                    temp_irq_2_empty <= 0;
                end
                mark_instr2 <= 1;
                reg_irq_2_full <= 1;
                irq_counter <= 0;
                state <= DUT_FULL_1;
            end
            else begin
                reg_irq_2_full <= 0; //!!! if not add may stall system
                state <= DUT_WRITE;
            end
         end
         //Status 2. At this time, the FIFO is full, and you need to wait until the FIFO is not full
         DUT_FULL_1:begin
            //fix full fifo
            //Because the interrupt needs to be synchronized across the clock domain, the interrupt signal has a clock cycle delay, and the PC and register values at this time need to be temporarily stored
            if(mark_instr2 == 1)begin
                temp_full_fifo_data2 <= {52'd0,dut_address,dut_data};
                temp_full_fifo_instr_exed2 <= instr_exed & ~irq_2_empty;//~irq_2_empty:judge irq from full_fifo or difftest
                mark_instr2 <= 0;
            end
            //To avoid frequent FIFO full, set the interrupt to occur for at least 32 clock cycles
            if(!fifo_almost_full && irq_counter >= 32)begin
                irq_counter <= 0;
                state <= DUT_FULL_2;
            end
            else begin
                state <= DUT_FULL_1;
                if(irq_counter <= 32)begin
                    irq_counter <= irq_counter + 1;
                end
                else ;
            end
         end
         //The interrupt source of the DUT at this time is not the FIFO is full, but the difftest module sends the interrupt, so you need to wait for the interrupt cancellation of the difftest module
         DUT_IRQ:begin        //wait for end of irq
            reg_fifo_wr_en <= 0;
            //**At this time, the interrupt source is the difftest module, but it may occur at the same time as the FIFO full interrupt. Therefore, the FIFO full interrupt is generated according to the FIFO status
            if(fifo_almost_full)begin
                reg_irq_2_full <= 1;
            end
            else begin
                reg_irq_2_full <= 0;
            end

            if(irq_2_empty)begin
                state <= DUT_IRQ;
            end
            else begin
                state <= DUT_WRITE;
            end
         end
         //Status 4: FIFO full interrupt is canceled, and the temporary CPU status in status 1 needs to be written
         DUT_FULL_2:begin
            reg_fifo_wr_en <= 0;  
            if(!fifo_almost_full && temp_full_fifo_instr_exed1) begin
                reg_fifo_wr_en <= 1;
                reg_fifo_wr_data <= temp_full_fifo_data1;
                //If the interrupt sent by difftest occurs during temporary storage, you need to enter state 3 to wait
                if(temp_irq_2_empty)begin
                    temp_irq_2_empty <= 0;
                    state <= DUT_IRQ;
                end
                else begin
                    state <= DUT_FULL_3;
                end
            end
            else if(!fifo_almost_full && !temp_full_fifo_instr_exed1)begin
                reg_fifo_wr_en <= 0;
                if(temp_irq_2_empty)begin
                    temp_irq_2_empty <= 0;
                    state <= DUT_IRQ;
                end
                else begin 
                    state <= DUT_FULL_3;
                end
            end
            else begin
                reg_fifo_wr_en <= 0; 
                state <= DUT_FULL_2;
            end
            
         end
         //State 5, write the temporary CPU information in state 2
         DUT_FULL_3:begin
            reg_fifo_wr_en <= 0;
             if(!fifo_almost_full && temp_full_fifo_instr_exed2) begin
                reg_fifo_wr_en <= 1;
                reg_fifo_wr_data <= temp_full_fifo_data2;
                state <= DUT_FULL_4;
             end
             else if(!fifo_almost_full && !temp_full_fifo_instr_exed2)begin
                reg_fifo_wr_en <= 0; 
                state <= DUT_FULL_4;
             end
             else begin
                reg_fifo_wr_en <= 0; 
                state <= DUT_FULL_3;
             end
         end
         //Check whether the FIFO is full after writing temporary storage 2
         DUT_FULL_4:begin
            reg_fifo_wr_en <= 0;
            if(!fifo_almost_full)begin
                reg_irq_2_full <= 0;
                state <= DUT_FULL_5;
            end
            else begin
                state <= DUT_FULL_4;
            end
         end
         //Status 7, FIFO full interrupt processing completed
         DUT_FULL_5:begin
            if(irq_2_empty)begin
                state <= DUT_FULL_5;
            end
            else begin
                if(instr_exed)begin
                    reg_fifo_wr_en <= 1;
                    reg_fifo_wr_data <= {52'd0,dut_address,dut_data};
                    state <= DUT_WRITE;
                end
                else begin
                    state <= DUT_WRITE;
                end
            end
         end
        endcase
    end
    
  end
  
  
endmodule