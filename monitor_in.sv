class monitor_in;
  int no_of_pkts_rcvd;
  logic [DATA_WIDTH:0] queue_array[$];
  packet pkt;
  
  virtual fifo_interface.m_imon gif_imon;
  
  mailbox #(packet) mbox;
  int wr_pkt,rd_pkt,no_of_full,no_of_empty;
  logic [DATA_WIDTH:0] data_out_monin;
  
  function new(input mailbox #(packet) mbox_in,
               virtual fifo_interface.m_imon gif_imon_in);
    mbox = mbox_in;
    gif_imon = gif_imon_in;
  if(gif_imon==null)
    $display("[INPUT-MONITOR] Fatal interface handle not set");
  endfunction
  
  task run();
    pkt=new();
    $display("@%0t[INPUT-MONITOR] RUN STARTED",$time);
    while(1)
      begin
        fork
          begin
            full_empty();
          end
          
          begin
            @(gif_imon.clk_imon);
            pkt.data_out_monin=8'dx;
            pkt.data_in=gif_imon.clk_imon.data_in;
            pkt.rd_en=gif_imon.clk_imon.rd_en;
            pkt.wr_en=gif_imon.clk_imon.wr_en;
            if(gif_imon.clk_imon.wr_en==1 && gif_imon.clk_imon.rd_en==0)
              begin
                wr_pkt=wr_pkt+1;
                queue_array.push_front(gif_imon.clk_imon.data_in);
                $display("@%0t[INPUT-MONITOR] WRITE PKT = %0d To SCB with queue_data=%0d wr_en=%0d rd_en=%0d",$time,no_of_pkts_rcvd,gif_imon.clk_imon.data_in,gif_imon.clk_imon.wr_en,gif_imon.clk_imon.rd_en);
              end
            
            else if(gif_imon.clk_imon.wr_en==0 && gif_imon.clk_imon.rd_en==1)
              begin
                rd_pkt=rd_pkt+1;
                pkt.data_out_monin = queue_array.pop_back();
                $display("@%0t[INPUT-MONITOR] READ PKT = %0d To SCB with queue_data=%0d wr_en=%0d rd_en=%0d",$time,no_of_pkts_rcvd,gif_imon.clk_imon.data_in,gif_imon.clk_imon.wr_en,gif_imon.clk_imon.rd_en);
              end
            no_of_pkts_rcvd=no_of_pkts_rcvd+1;
          end
          
          mbox.put(pkt);
          
        join
      end
    
    $display("@%0t[INPUT-MONITOR] RUN ENDED",$time);
  endtask
  
  task full_empty();
    int no_of_empty,no_of_full;
    if(queue_array.size==6'd0)
    begin
      pkt.full_monin=0;
      pkt.empty_monin=1;
      no_of_empty++;
      $display("@%0d [INPUT-MONITOR FULL_EMPTY] full=%0d empty=%0d",$time,pkt.full_monin,pkt.empty_monin);
    end
    
    else if(queue_array.size==6'd32)
      begin
        pkt.full_monin=0;
        pkt.empty_monin=1;
        no_of_full++;
        $display("@%0d [INPUT-MONITOR FULL_EMPTY] full=%0d empty=%0d",$time,pkt.full_monin,pkt.empty_monin);
      end
    
    else
      begin
        pkt.full_monin=0;
        pkt.empty_monin=0;
         $display("@%0d [INPUT-MONITOR FULL_EMPTY] full=%0d empty=%0d",$time,pkt.full_monin,pkt.empty_monin);
      end
  endtask
endclass
