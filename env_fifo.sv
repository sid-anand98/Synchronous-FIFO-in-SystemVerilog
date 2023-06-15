`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "scoreboard.sv"

class env_fifo;
  
  int no_of_pkts;
  
  virtual fifo_interface.m_drv gif_drv;
  virtual fifo_interface.m_imon gif_imon;
  virtual fifo_interface.m_omon gif_omon;
  
  generator gen;
  driver drv;
  monitor_in monin;
  monitor_out monout;
  scoreboard scb;
  
  //mailboxes
  mailbox #(packet) gen_drv_mbox;
  mailbox #(packet) scr_gen_minbox;
  mailbox #(packet) scr_gen_monbox;
  
  
  function new(input virtual fifo_interface.m_drv drv,
               input virtual fifo_interface.m_imon imon,
               input virtual fifo_interface.m_omon omon,
               input int no_of_pkts);
    
    gif_drv = drv;
    gif_imon = imon;
    gif_omon = omon;
    this.no_of_pkts = no_of_pkts;
    
  endfunction
  
  task build();
    $display("@%0t [ENV BUILD] Environment build Started",$time);
    gen_drv_mbox=new;
    scr_gen_minbox=new;
    scr_gen_monbox=new;
    
    
    gen=new(gen_drv_mbox,no_of_pkts);
    drv=new(gen_drv_mbox,gif_drv);
    monin=new(scr_gen_minbox,gif_imon);
    monout=new(scr_gen_monbox,gif_omon);
    scb=new(scr_gen_monbox,scr_gen_minbox);
    
    $display("@%0t [ENV BUILD] Environment build Ended",$time);
  endtask
  
  task run();
    $display("@%0t [ENV RUN] Simulation build Started",$time);
    gen.run();
    fork
      drv.run();
      monin.run();
      monout.run();
      scb.run();
      wait(this.no_of_pkts==monout.no_of_pkts_rcvd);
    join_any
    disable fork;
    
    
    $display("@%0t [ENV RUN] Simulation build Ended",$time);
      final_result();
  endtask
      
      task final_result();
        $display("Total pkts sent to DUT		=%0d",no_of_pkts);
        $display("Write pkts sent to DUT		=%0d",drv.wr_pkt);
        $display("Read pkts sent to DUT			=%0d",drv.rd_pkt);
        $display("Matches (write=read)			=%0d",scb.match);
        $display("Mismatches (write!=read)		=%0d",scb.mismatch);
        $display("Missed						=%0d",scb.missed);
        $display("EMPTY							=%0d",monout.no_of_empty);
        $display("FULL							=%0d",monout.no_of_full);
        if(scb.mismatch==0)
          begin
            $display("*************************************************************************************************");
            $display("******************************************PASS***********************************************");
            $display("*************************************************************************************************");
            $finish();
          end
        else
          begin
            $display("*************************************************************************************************");
            $display("******************************************FAIL***********************************************");
            $display("*************************************************************************************************");
          end
      endtask
endclass    
