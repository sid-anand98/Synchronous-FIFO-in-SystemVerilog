// Code your testbench here
// or browse Examples
`include "fifo_interface.sv"
`include "fifo_program.sv"

module top;
  bit clk,rst;
  
  initial
    begin
      clk=0;
      forever #5 clk=~clk;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  
  fifo_interface fifo_in(clk,rst);
  fifo duv(.data_in(fifo_in.data_in),.wr_en(fifo_in.wr_en),.rd_en(fifo_in.rd_en),.data_out(fifo_in.data_out),.full(fifo_in.full),.empty(fifo_in.empty),.clk(clk),.rst(rst));
  fifo_program pro(fifo_in);
endmodule
