/********************************************** /
AXI4-Lite VIP

file: axi4_lite_wr_slave_sequence.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: Sequence to perform a write operation
via AXI4 Lite
************************************************/
class axi4_lite_wr_slave_sequence extends axi4_lite_base_sequence;
    `uvm_object_utils(axi4_lite_wr_slave_sequence)

    axi4_lite_wr_addr_slave_sequence waddr_seq;
    axi4_lite_wr_data_slave_sequence wdata_seq;
    axi4_lite_wr_resp_slave_sequence wresp_seq;
    //  Constructor: new
    function new(string name = "axi4_lite_wr_slave_sequence");
        super.new(name);
    endfunction: new
    /*
    Task: body
    Description: This task will randomize the req transaction with
    the slave set to WR_data
    */
    extern task body();

endclass: axi4_lite_wr_slave_sequence

task axi4_lite_wr_slave_sequence::body();

    repeat(100) begin
        fork
            `uvm_do(waddr_seq)
            `uvm_do(wdata_seq)
            `uvm_do(wresp_seq)
        join
    end
endtask : body

