/********************************************** /
AXI4-Lite VIP

file: axi4_lite_vip_test.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: Default test to check if the VIP can 
perform write/read operations. One VIP master is connected
with a VIP slave and them they communicate
************************************************/

class axi4_lite_vip_test extends axi4_lite_base_test;
    `uvm_component_utils(axi4_lite_vip_test)
    
    // Sequences
    axi4_lite_wr_master_sequence mst_seq;
    axi4_lite_rd_master_sequence mst_rd_seq;
    axi4_lite_wr_slave_sequence slv_seq;
    axi4_lite_rd_slave_sequence slv_rd_seq;
    
  
    function new(string name = "axi4_lite_vip_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // Function: build_phase
    extern function void build_phase(uvm_phase phase);

    // Task: main phase
    extern task main_phase(uvm_phase phase);

endclass : axi4_lite_vip_test

function void axi4_lite_vip_test::build_phase(uvm_phase phase);
  	super.build_phase(phase);
endfunction: build_phase

task axi4_lite_vip_test::main_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    // Creates the sequences
    mst_seq = axi4_lite_wr_master_sequence::type_id::create("mst_seq");
    slv_seq = axi4_lite_wr_slave_sequence::type_id::create("slv_seq");
    mst_rd_seq = axi4_lite_rd_master_sequence::type_id::create("mst_rd_seq");
    slv_rd_seq = axi4_lite_rd_slave_sequence::type_id::create("slv_rd_seq");


    // Sets the number of write operations (It needs to be equal once this test is focused in validate valid transactions)
    mst_seq.num_of_transactions = 100;
    slv_seq.num_of_transactions = 100;
    mst_rd_seq.num_of_transactions = 100;
    slv_rd_seq.num_of_transactions = 100;

    fork        
        mst_seq.start(mst_env.wr_agent.sqr);
        slv_seq.start(slv_env.wr_agent.sqr);
        mst_rd_seq.start(mst_env.rd_agent.sqr);
        slv_rd_seq.start(slv_env.rd_agent.sqr);
    join
    
    phase.phase_done.set_drain_time(this, 200);
    phase.drop_objection(this);
endtask : main_phase