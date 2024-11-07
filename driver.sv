//gets the packet from generator and drive the transaction packet items into interface(interface is connected to DUT, so items driven into interface signal will get driven to DUT)

//hierarical reference to driver clocking block to drive signals inside clocking block

`define DRIV_IF mem_vif.DRIVER.driver_cb
class driver;
  //used to count number of transactions received
  int no_trans;

  //creating virtual interface handle can't take direct interface handle as reference as it is static in nature
  virtual mem_intf mem_vif;

  //creating mailbox handle to receive transaction from generator
  mailbox gen2driv;

  transaction trans;

  //constructor
  function new(virtual mem_intf mem_vif,mailbox gen2driv);
    //getting the interface
    this.mem_vif=mem_vif;
    //getting the mailbox handles from env
    this.gen2driv=gen2driv;
  endfunction

  //drivers the transaction items to interface signals
  task drive;
    `DRIV_IF.wem<=0;
    `DRIV_IF.me<=0;
    gen2driv.get(trans);
    $display("----------[DRIVER-TRANSFER:%)d]--------");

    @(posedge mem_vif.DRIVER.clk);
    `DRIV_IF.addr<=trans.addr;
    `DRIV_IF.me<=trans.me;

    if(trans.me) begin
      if(trans.wen) begin
        `DRIV_IF.wen<=trans.wen;
        `DRIV_IF.wdata<=trans.wdata;
        $display("\t ADDR=%0h \t WDATA=%0h",trans.addr,trans.wdata);
        @(posedge mem_vif.DRIVER.clk);
      end
      else begin
        @(posedge mem_vif.DRIVER.clk);
        `DRIV_IF.me<=0;
        @(posedge mem_vif.DRIVER.clk);
        trans.rdata=`DRIV_IF.rdata;
        $display("\tADDR=%0h \t RDATA=%0h",trans.addr,`DRIV_IF.rdata);
      end
    end
    $display("------------------------------------------");
    no_trans++;
  endtask

  //main task to call drive task
  task main;
    forever begin
      drive();
    end
  endtask
endclass
