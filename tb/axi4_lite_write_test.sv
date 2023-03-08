class axi4_lite_write_test extends axi4_lite_base_test;
    `uvm_component_utils(axi4_lite_write_test)
    

    axi4_lite_wr_master_sequence mst_seq;
    axi4_lite_wr_slave_sequence slv_seq;
  

    //  Constructor: new
    function new(string name = "axi4_lite_write_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);

    // Task: main phase
    extern task main_phase(uvm_phase phase);

endclass : axi4_lite_write_test


function void axi4_lite_write_test::build_phase(uvm_phase phase);
  	super.build_phase(phase);
endfunction: build_phase


task axi4_lite_write_test::main_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    mst_seq = axi4_lite_wr_master_sequence::type_id::create("mst_seq");
    slv_seq = axi4_lite_wr_slave_sequence::type_id::create("slv_seq");

    fork        
        mst_seq.start(mst_agt.sqr);
        slv_seq.start(slv_agt.sqr);
    join
    
    phase.phase_done.set_drain_time(this, 500);
    phase.drop_objection(this);
endtask : main_phase