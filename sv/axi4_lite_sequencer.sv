/********************************************** /
AXI4-Lite VIP

file: axi4_lite_sequencer.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: Sequencer that will manage the sequences
of the AXI4 Lite
************************************************/

class axi4_lite_sequencer extends uvm_sequencer#(axi4_lite_packet);
    `uvm_component_utils(axi4_lite_sequencer)

    //  Constructor: new
    function new(string name = "axi4_lite_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    /*------------------------------------*/
    //  Function: build_phase
    extern virtual function void build_phase(uvm_phase phase);
    
endclass: axi4_lite_sequencer


/*----------------------------------------------------------------------------*/
/*  UVM Build Phases                                                          */
/*----------------------------------------------------------------------------*/
virtual function void axi4_lite_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction: build_phase
