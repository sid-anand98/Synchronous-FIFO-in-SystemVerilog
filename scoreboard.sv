class scoreboard;
  
  int total_no_of_pkts_rcvd;
  packet imon_pkt;
  packet omon_pkt;
  mailbox #(packet) mbox_in;
  mailbox #(packet) mbox_out;
  bit [15:0] match;
  bit [15:0] mismatch;
  bit [15:0] missed;
  //bit [15:0] black_hole;
  //int wr_no_of_pkts_recvd;
  //int rd_no_of_pkts_recvd;
  int i;
  
  function new (input mailbox #(packet) mbox_in,
                input mailbox #(packet) mbox_out);
    this.mbox_in = mbox_in;
    this.mbox_out = mbox_out;
    
  endfunction
  
  
  task run;
    $display("@%0t[SCOREBOARD] RUN STARTED\n",$time);
    imon_pkt=new();
    omon_pkt=new();
    fork
      begin
        while(1)
          begin
            //wr_no_of_pkts_recvd++;
            mbox_in.get(imon_pkt);
            $display("@%0t [SCB_IN] with Full=%0d Empty=%0d monin_data(TB):%0d",$time,imon_pkt.full_monin, imon_pkt.empty_monin, imon_pkt.data_out_monin);
          end
      end
      
      begin
        while(1)
          begin
            mbox_out.get(omon_pkt);
            //rd_no_of_pkts_recvd++;
            total_no_of_pkts_rcvd=total_no_of_pkts_rcvd+1;
            $display("@%0t [SCB_OUT] Full=%0d Empty=%0d data_out:%0d",$time,imon_pkt.full_monin, imon_pkt.empty_monin, omon_pkt.data_out);
            
            if((imon_pkt.data_out_monin==omon_pkt.data_out)&&(omon_pkt.empty==imon_pkt.empty_monin&&omon_pkt.full==imon_pkt.full_monin))
              begin
                $display("@%0t [SCB] Pass TB_data:%0d \t DUT_data:%0d ,no_of_pkts_rcvd:%0d",$time,imon_pkt.data_out_monin,omon_pkt.data_out,total_no_of_pkts_rcvd);
                match=match+1;
              end
            
            else if(((imon_pkt.data_out_monin!==omon_pkt.data_out)||(imon_pkt.data_out_monin!==8'dx && omon_pkt.data_out!==8'dx))&& omon_pkt.empty!==imon_pkt.empty_monin && omon_pkt.full!==imon_pkt.full_monin)
              begin
                
                $display("@%0t [SCB] Fail  ATB_data:%0d \t DUT_data:%0d ,no_of_pkts_rcvd:%0d",$time,imon_pkt.data_out_monin,omon_pkt.data_out,total_no_of_pkts_rcvd);
                mismatch=mismatch+1;
              end
            else
              begin
                missed++;
              end
          end
      end
    join
  endtask
endclass
