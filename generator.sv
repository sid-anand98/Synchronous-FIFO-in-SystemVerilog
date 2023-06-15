//`include "packet.sv"
class generator;
  int no_of_pkts;
  packet ref_pkt,pkt;
  
  mailbox #(packet) mbox;
  
  function new(mailbox #(packet) mbox_in,
               int no_of_pkts=1);
    this.no_of_pkts=no_of_pkts;
    mbox=mbox_in;
    ref_pkt=new();
  endfunction
  
  task run();
    int pkt_count;
    $display("@%0t [GENERATOR BLOCK] Run started",$time);
    repeat(no_of_pkts)
      begin
        assert(ref_pkt.randomize());
        pkt=new;
        pkt.copy(ref_pkt);
        mbox.put(pkt);
        pkt_count=pkt_count+1;
        $display("@%0t [GENERATOR BLOCK] PACKET NO %0d sent to DRIVER",$time,pkt_count);
        pkt.print("GENERATOR");
      end
    $display("@%0t [GENERATOR BLOCK] Run ended, size of mailbox is %0d",$time,mbox.num());
  endtask
endclass
