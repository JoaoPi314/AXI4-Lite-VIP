/********************************************** /
AXI4-Lite VIP

file: axi4_lite_wr_addr_slave_sequence.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: Sequence to send a Write Address packet to this
channel
************************************************/
class axi4_lite_wr_addr_slave_sequence extends axi4_lite_base_sequence;
    `uvm_object_utils(axi4_lite_wr_addr_slave_sequence)

    //  Constructor: new
    function new(string name = "axi4_lite_wr_addr_slave_sequence");
        super.new(name);
    endfunction: new
    /*
    Task: body
    Description: This task will randomize the req transaction with
    the slave set to WR_ADDR
    */
    extern task body();

endclass: axi4_lite_wr_addr_slave_sequence

task axi4_lite_wr_addr_slave_sequence::body();
    `uvm_do_with(req, {req.active_channel == WR_ADDR;})
endtask : body