`include "env.sv"
class test_fifo;
  
  int no_of_pkts=70;
  
  virtual fifo_interface.m_drv gif_drv;
  virtual fifo_interface.m_imon gif_imon;
  virtual fifo_interface.m_omon gif_omon;
  
  env_fifo env;
  
  function new(input virtual fifo_interface.m_drv drv,
               input virtual fifo_interface.m_imon imon,
               input virtual fifo_interface.m_omon omon);
    
    gif_drv=drv;
    gif_imon=imon;
    gif_omon=omon;
    
  endfunction
  
  virtual task run();
    $display("@%0t [TEST BLOCK] TEST1 - Simulation started",$time);
    env=new(gif_drv,gif_imon,gif_omon,no_of_pkts);
    env.build();
    env.run();
    $display("Packets = %0d",no_of_pkts);
    $display("@%0t [TEST BLOCK] TEST1 - Simulation Concluded",$time);
  endtask
endclass
    
