`include "test_fifo.sv"
program fifo_program(fifo_interface gif);
  test_fifo test;
  //test_fifo_wr_rd test_wr_rd;
  //test_fifo_wrall_rdall test_wrall_rdall;
  
  initial
    begin
      repeat(2)
        begin
          //$display("Checking");
          @(posedge top.clk); top.rst<=1;
          
        end
      
      @(posedge top.clk); top.rst<=0;
      
      $display("@%0t [PROGRAM BLOCK] PGM1 - Random write and read simulation started",$time);
      test=new(gif.m_drv,gif.m_imon,gif.m_omon);
      test.run();
      $display("@%0t [PROGRAM BLOCK] PGM1 - Random write and read Simulation Concluded",$time);
      
      $finish;
    end
endprogram
