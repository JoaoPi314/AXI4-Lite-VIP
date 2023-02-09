/********************************************** /
AXI4-Lite VIP

file: axi4_lite_base_test.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: Base test class
************************************************/
class axi4_lite_base_test extends uvm_test;
    `uvm_component_utils(axi4_lite_base_test);



    //  Constructor: new
    function new(string name = "axi4_lite_base_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new


    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);

    //  Function: end_of_elaboration_phase
    extern function void end_of_elaboration_phase(uvm_phase phase);

endclass: axi4_lite_base_test


function void axi4_lite_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction: build_phase

function void axi4_lite_base_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction: end_of_elaboration_phase


