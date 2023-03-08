/********************************************** /
AXI4-Lite VIP

file: axi4_lite_base_driver.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: The driver is capable of drive to master and
slave AXI4 Lite interfaces. It will be pipelined to drive
multichannels in parallel.
************************************************/

class axi4_lite_base_driver extends uvm_driver#(axi4_lite_packet);
    `uvm_component_utils(axi4_lite_base_driver)

    axi4_lite_mst_vif vif;

    semaphore pipeline_lock = new(1);
    bit valid_transfers;
    bit lock_write = 1'b0;

    //  Constructor: new
    function new(string name = "axi4_lite_base_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);

    //  Task: main_phase
    extern task main_phase(uvm_phase phase);

    /*
    Task: pipeline_selector()
    This task will check the sequence channel and call the
    respective task to drive the data from sequence
    */
    extern task automatic pipeline_selector();


    /*
    Task: drive_wr_addr_channel
    This task will be responsible for drive data into the
    write address channel of the AXI4 Lite
    */
    virtual task automatic drive_wr_addr_channel();
    endtask


    /*
    Task: drive_wr_data_channel
    This task will be responsible for drive data into the
    write dataess channel of the AXI4 Lite
    */
    virtual task automatic drive_wr_data_channel();
    endtask

    /*
    Task: drive_wr_resp_channel
    This task will be responsible for drive the ready into the
    write response channel of the AXI4 Lite
    */
    virtual task automatic drive_wr_resp_channel();
    endtask

endclass: axi4_lite_base_driver

function void axi4_lite_base_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(bit)::get(this, "", "valid_transfers", valid_transfers))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration")
    assert(uvm_config_db#(axi4_lite_mst_vif)::get(this, "", "mst_vif", vif))
        else `uvm_fatal(get_type_name(), "Failed to get virtual interface")
endfunction: build_phase


task axi4_lite_base_driver::main_phase(uvm_phase phase);
    @(negedge vif.arst_n);
    @(posedge vif.arst_n);

    fork
        pipeline_selector();
        pipeline_selector();
        pipeline_selector();
    join
endtask: main_phase

task axi4_lite_base_driver::pipeline_selector();
    forever begin
        pipeline_lock.get();
        seq_item_port.get(req);
        case(req.active_channel)
            WR_ADDR: drive_wr_addr_channel();
            WR_DATA: drive_wr_data_channel();
            WR_RESP: drive_wr_resp_channel();
        endcase
    end 
endtask : pipeline_selector
