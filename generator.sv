//randomizes the transaction and sends the transaction to driver
class generator;
  //take instance of transaction class
  transaction trans;

  //specify number of items to generate
  int drv_count;

  //mailbox to generate and send the packet to driver
  mailbox gen2driv;

  //event to mention main task in generator is done
  event gen_ended;

  //constructor
  function new(mailbox gen2driv,event gen_ended);
    //get the mailbox handle from env to share the transaction packet between generator and driver
    this.gen2driv=gen2driv;
    this.gen_ended=gen_ended;
    trans=new();
  endfunction

  //main task generate(create and randomize) the repeat count number of transaction packets and puts in mailbox
  task main();
    repeat(drv_count) begin
      if(!trans.randomize()) $fatal("generator::trans randomization failed");
      trans.do_copy();
      gen2driv.put(trans);
    end
    ->gen_ended;
  endtask
endclass
