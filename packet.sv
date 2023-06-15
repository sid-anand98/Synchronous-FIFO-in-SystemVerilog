class packet;
  
  //inputs randomized
  rand bit rd_en,wr_en;
  rand bit [DATA_WIDTH:0] data_in;
  
  //stable outputs
  logic [DATA_WIDTH:0] data_out,data_out_monin;
  bit full,empty,full_monin,empty_monin;
  
  int i;
  
  constraint valid{
    data_in inside {[0:((2**(DATA_WIDTH+1))-1)]};
    if(wr_en==0)rd_en!=0;
    if(wr_en==1)rd_en!=1;
    if(i<33){
      wr_en==1;
      rd_en==0;
    }
      else{
        wr_en==0;
        rd_en==1;}
      }
        
        constraint wr_rd_prob{
          wr_en dist {0:/10,1:/90};
          rd_en dist {0:/90,1:/10};
        }
        
        function void post_randomize();
    i++;
    endfunction
    
    virtual function void print (string s="Packet");
      $display("@%0t [%s] data_in=%0d wr_en=%0d rd_en=%0d \n",$time,s,data_in,wr_en,rd_en);
    endfunction
    
    virtual function void copy(packet p);
      if(p==null)
        begin
          $display("[Packet] Null object passed to copy methord \n");
        end
      else
        begin
          this.data_in=p.data_in;
          this.rd_en=p.rd_en;
          this.wr_en=p.wr_en;
        end
    endfunction
    endclass
