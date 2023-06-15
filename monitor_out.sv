class monitor_out;
  packet pkt;
  int no_of_pkts_rcvd,no_of_full,no_of_empty;
  
  virtual fifo_interface.m_omon gif_omon;
  mailbox #(packet) mbox;
  
  
  function new(input mailbox #(packet) mbox_in,
               input virtual fifo_interface.m_omon gif_omon_in);
    mbox = mbox_in;
    gif_omon = gif_omon_in;
  if(gif_omon==null)
    $display("[OUTPUT-MONITOR] Fatal interface handle not set");
  endfunction
  
  task run();
    $display("@%0t[OUTPUT-MONITOR] RUN STARTED",$time);
    @(gif_omon.clk_omon);
    while(1)
      begin
        @(gif_omon.clk_omon);
        pkt=new();
        pkt.empty = gif_omon.clk_omon.empty;
        pkt.full = gif_omon.clk_omon.full;
        
        if(gif_omon.clk_omon.rd_en==1)
          pkt.data_out=gif_omon.clk_omon.data_out;
        
        else if(gif_omon.clk_omon.empty==1)
          no_of_empty=no_of_empty+1;
        
        else if(gif_omon.clk_omon.full==1)
          no_of_full=no_of_full+1;
        no_of_pkts_rcvd=no_of_pkts_rcvd+1;
        
        $display("@%0d [MONITOR-OUT] PKTs=%0d to SCB with data_out=%0d, full=%0d, empty=%0d, rd_en=%0d",$time,no_of_pkts_rcvd,pkt.data_out,pkt.full,pkt.empty,gif_omon.clk_omon.rd_en);
        mbox.put(pkt);
      end
    
    $display("@%0t[OUTPUT-MONITOR] RUN ENDED",$time);
  endtask
endclass
        
