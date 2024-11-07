class transaction;
  //declaring DUT inputs and outputs
  rand bit [15:0]addr;
  rand bit [63:0]wdata;
  rand bit wen;
  rand bit me;
  bit [63:0]rdata;

  //post randomize function to display randomized items
  function void post randomize();
    $display("-------[Trans]post_randomize-------");
    $display("\t addr=%0h",addr);
    if(me) $display("\t wen=%0h\t wdata=%0h \t me=%0h",wen,wdata,me);
    $display("------------------------------------");
  endfunction

  //function string convert2string();
  //return $sformatf("addr=%0h,wdata=%0h,wen=%0h,me=%0h",addr,wdata,wen,me);
  //endfunction

  //deep copy method
  function transaction do_copy();
    transaction trans;
    trans=new();
    trans.addr=this.addr;
    trans.wen=this.wen;
    trans.me=this.me;
    trans.wdata=this.wdata;
    return trans;
  endfunction
endclass
