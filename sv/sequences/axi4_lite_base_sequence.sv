/********************************************** /
AXI4-Lite VIP

file: axi4_lite_base_sequence.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: Base Sequence class
************************************************/
class axi4_lite_base_sequence extends uvm_sequence#(axi4_lite_packet);
    `uvm_object_utils(axi4_lite_base_sequence)

    function new(string name = "axi4_lite_base_sequence");
        super.new(name);
    endfunction: new
    
    /*
     * Task: pre_body
     * Description: It will only raise a objection to prevent the
     * main_phase at test being dropped before the sequences are
     * finished. Only used with default sequences
    */
    extern task pre_body();

    /*
     * Task: post_body
     * Description: It will only drop a objection to prevent the
     * main_phase at test being dropped before the sequences are
     * finished. Only used with default sequences
    */
    extern task post_body();


endclass: axi4_lite_base_sequence

task axi4_lite_base_sequence::pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
        phase = get_starting_phase();
    `else 
        phase = starting_phase;
    `endif

    if(phase != null) begin
        phase.raise_objection(this, get_type_name());
        `uvm_info(get_type_name(), "Raised objection...", UVM_MEDIUM)        
    end
endtask : pre_body

task axi4_lite_base_sequence::post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
        phase = get_starting_phase();
    `else 
        phase = starting_phase;
    `endif
    
    if(phase != null) begin
        phase.drop_objection(this, get_type_name());
        `uvm_info(get_type_name(), "Dropped objection...", UVM_MEDIUM)        
    end
endtask : post_body