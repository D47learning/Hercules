`timescale 1 ns / 100 ps
module sys_tb ();

// Signal for ILC
reg         save;
reg         restore;
reg         ti_req;
wire        ti_gnt;
reg         pr_done;
reg         clk_en;
reg         init;

// Signal for ModelSim to control different state
reg         load;
reg         dump;

initial begin
  load      = 1'b0;
  dump      = 1'b0;
end

reg         i_rst;
reg         i_clk;
reg [31:0]  breakpoint;
reg         ap_start;
wire        ap_done;
wire[10:0]  write_address;
wire[31:0]  write_data;
wire        write_enable;

//generate clk signal
always #5 i_clk =  ~i_clk;

initial begin
  ti_req    = 1'b0;
  pr_done   = 1'b0;
  restore   = 1'b0;
  save      = 1'b0;
  clk_en    = 1'b1;
  i_clk     = 1'b0;

  forever begin
    @(posedge load or posedge dump);

    if (load) begin
      /* Request Task Interruption */
      ti_req  = 1'b1;
      $display("%t: %m: TI LOAD REQUEST ASSERTED", $time);
      /* Wait till the TI is granted */
      //wait(ti_gnt);
      clk_en = 0;
      $display("%t: %m: TI LOAD REQUEST GRANTED", $time);
      /* Restore the state */
      #20;
      restore = 1'b1; // calls restore_hardware_state() in CSR-SIM
      /* Resume the Task */
      #20;
      ti_req  = 1'b0;
      pr_done = 1'b1;
      clk_en = 1'b1;
      /* Disable signals */
      pr_done = 1'b0;
      restore = 1'b0;
    end

    else if (dump) begin
      /* Request Task Interruption */
      ti_req  = 1'b1;
      $display("%t: %m: TI REQUEST ASSERTED", $time);
      /* Wait till the TI is granted */
      //wait(ti_gnt);
      clk_en = 0;
      $display("%t: %m: TI REQUEST GRANTED", $time);
      /* Save the state */
      #20;
      save = 1'b1; // calls dump_simulation_state() in CSR-SIM
      /* Resume the Task */
      #20;
      ti_req  = 1'b0;
      pr_done = 1'b1;
      clk_en = 1'b1;
      /* Disable signals */
      pr_done = 1'b0;
      save = 1'b0;
    end

  end
end
  /**
   * Generate reset
   */
  initial begin
    $display("%t: %m: Starting testbench", $time);
    $monitor("%t: %m: System reset detected: %0d", $time, i_rst);
    i_rst = 1'b1;
    breakpoint = 32'hFFFF_FFFF;
    ap_start = 1'b0;
    #100
    i_rst = 1'b0;
    #100 
    ap_start = 1'b1;
  end

top_main top_main(
.clk_en         (clk_en),
.breakpoint     (breakpoint),
.sys_clk        (i_clk),
.sys_resetn     (~i_rst),
.ap_start       (ap_start),
.ap_done        (ap_done),
.write_address  (write_address),
.write_data     (write_data),
.write_enable   (write_enable)

);

endmodule