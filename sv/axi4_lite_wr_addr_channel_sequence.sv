/********************************************** /
AXI4-Lite VIP

file: axi4_lite_wr_addr_channel_sequence.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: Sequencer that will manage the sequences
of the AXI4 Lite
************************************************/
class axi4_lite_wr_addr_channel_sequence extends axi4_lite_base_sequence;
    `uvm_object_utils(axi4_lite_wr_addr_channel_sequence);

    //  Constructor: new
    function new(string name = "axi4_lite_wr_addr_channel_sequence");
        super.new(name);
    endfunction: new
    /*
    Task: body
    Description: This task will randomize the req transaction with
    the channel set to WR_ADDR
    */
    extern task body();

endclass: axi4_lite_wr_addr_channel_sequence

task axi4_lite_wr_addr_channel_sequence::body();
    `uvm_do_with(req, req.active_channel == WR_ADDR)
endtask : body