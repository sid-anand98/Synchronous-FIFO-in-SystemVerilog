interface fifo_interface(input bit clk,rst);
  logic rd_en,wr_en;
  logic full,empty;
  logic [DATA_WIDTH:0] data_in;
  logic [DATA_WIDTH:0] data_out;
  
  
  //clocking block for driver
  clocking clk_drv@(posedge clk);
    default input #0 output #0;
    output rd_en,wr_en,data_in;
    input rst;
  endclocking
  
  //clocking-block for input monitor
  clocking clk_imon@(posedge clk);
    default input #0 output #0;
    input rst,rd_en,wr_en,data_in;
  endclocking
  
  //clocking-block for output monitor
  clocking clk_omon@(posedge clk);
    default input #0 output #0;
    input rst,rd_en,wr_en,data_out,full,empty;
  endclocking
  
  //modport declaration
  modport m_drv(clocking clk_drv);
    modport m_imon(clocking clk_imon);
      modport m_omon(clocking clk_omon);
        
        endinterface
