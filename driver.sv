class driver;
  int no_of_pkts_rcvd;
  int wr_pkt,rd_pkt;
  
  packet pkt;
  mailbox #(packet) mbox;
  virtual fifo_interface.m_drv gif_drv;
  
  function new(input mailbox #(packet) mbox_in,
               input virtual fifo_interface.m_drv gif_drv_in);
    mbox = mbox_in;
    gif_drv = gif_drv_in;
    
    if(gif_drv==null)
      $display("[DRIVER] Fatal interface handle not set");
  endfunction
  
  virtual task run();
    $display("@%0t [DRIVER BLOCK] Run started",$time);
    wait(top.rst);
    while(1)
      begin
        mbox.get(pkt);
        drive_to_design();
      end
  endtask
  
  task drive_to_design();
    no_of_pkts_rcvd++;
    @(gif_drv.clk_drv)
    
    gif_drv.clk_drv.data_in <= pkt.data_in;
    gif_drv.clk_drv.wr_en <= pkt.wr_en;
    gif_drv.clk_drv.rd_en <= pkt.rd_en;
    
    if(pkt.wr_en==1 && pkt.rd_en==0)
      begin
        $display("@%0t WRITING",$time);
        $display("@%0t packet = %0d, data = %0d, write = %0d, read = %0d",$time,no_of_pkts_rcvd,pkt.data_in,pkt.wr_en,pkt.rd_en);
        wr_pkt=wr_pkt+1;
      end
    else if(pkt.wr_en==0 && pkt.rd_en==1)
      begin
        rd_pkt=rd_pkt+1;                             
        $display("@%0t READING",$time);
        $display("@%0t packet = %0d, data = %0d, write = %0d, read = %0d",$time,no_of_pkts_rcvd,pkt.data_in,pkt.wr_en,pkt.rd_en);
      end
  endtask
endclass

