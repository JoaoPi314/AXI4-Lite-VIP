/********************************************** /
AXI4-Lite VIP

file: axi4_lite_driver.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: The driver is capable of drive to master and
slave AXI4 Lite interfaces. It will be pipelined to drive
multichannels in parallel.
************************************************/

class axi4_lite_driver extends uvm_driver#(axi4_lite_packet);
    `uvm_component_utils(axi4_lite_driver)

    //  Constructor: new
    function new(string name = "axi4_lite_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);

    //  Function: main_phase
    extern task main_phase(uvm_phase phase);
    
endclass: axi4_lite_driver

function void axi4_lite_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction: build_phase


task axi4_lite_driver::main_phase(uvm_phase phase);
    seq_item_port.get_next_item(req);
    req.print();
    seq_item_port.item_done();
endtask: main_phase

