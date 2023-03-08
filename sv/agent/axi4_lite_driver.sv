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

    axi4_lite_mst_vif vif;

    semaphore pipeline_lock = new(1);
    bit valid_transfers;
    bit lock_write = 1'b0;

    //  Constructor: new
    function new(string name = "axi4_lite_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);


    //Task: reset_phase

    extern virtual task reset_phase(uvm_phase phase);


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
    extern virtual task automatic drive_wr_addr_channel();


    /*
    Task: drive_wr_data_channel
    This task will be responsible for drive data into the
    write dataess channel of the AXI4 Lite
    */
    extern virtual task automatic drive_wr_data_channel();

    /*
    Task: drive_wr_resp_channel
    This task will be responsible for drive the ready into the
    write response channel of the AXI4 Lite
    */
    extern virtual task automatic drive_wr_resp_channel();

endclass: axi4_lite_driver

function void axi4_lite_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(axi4_lite_mst_vif)::get(this, "", "mst_vif", vif))
        else `uvm_fatal(get_type_name(), "Failed to get virtual interface")
    assert(uvm_config_db#(bit)::get(this, "", "valid_transfers", valid_transfers))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration")
endfunction: build_phase


task axi4_lite_driver::reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Reseting interface");
    
    vif.master_cb.awvalid <= 'b0;
    vif.master_cb.awaddr <= 'b0;
    vif.master_cb.awprot <= 'b0;
    vif.master_cb.wvalid <= 'b0;
    vif.master_cb.wdata <= 'b0;
    vif.master_cb.wstrb <= 'b0;
    vif.master_cb.bready <= 'b0;
    vif.master_cb.arvalid <= 'b0;
    vif.master_cb.araddr <= 'b0;
    vif.master_cb.arprot <= 'b0;
    vif.master_cb.rready <= 'b0;


    phase.drop_objection(this, "Reseting interface - Done");
endtask : reset_phase

task axi4_lite_driver::main_phase(uvm_phase phase);
    @(negedge vif.arst_n);
    @(posedge vif.arst_n);

    fork
        pipeline_selector();
        pipeline_selector();
        pipeline_selector();
    join
endtask: main_phase

task axi4_lite_driver::pipeline_selector();
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


task axi4_lite_driver::drive_wr_addr_channel();
    `uvm_info(get_type_name(), $sformatf("Driving WR_ADDR channel: \n%s", req.sprint()), UVM_HIGH)

    @(posedge vif.clk iff (~(valid_transfers & lock_write)));

    // This channel cannot wait for the ready to raise the valid
    vif.master_cb.awvalid <= 1'b1;
    vif.master_cb.awaddr <= req.addr;

    //Unlocks pipeline
    pipeline_lock.put();

    @(posedge vif.clk iff vif.awready === 1'b1);
    vif.master_cb.awvalid <= 1'b0;

endtask : drive_wr_addr_channel

task axi4_lite_driver::drive_wr_data_channel();
    `uvm_info(get_type_name(), $sformatf("Driving WR_DATA channel: \n%s", req.sprint()), UVM_HIGH)

    @(posedge vif.clk iff (~(valid_transfers & lock_write)));

    // This channel cannot wait for the ready to raise the valid
    vif.master_cb.wvalid <= 1'b1;
    vif.master_cb.wdata <= req.data;
    vif.master_cb.wstrb <= req.wstrb;

    //Unlocks pipeline
    pipeline_lock.put();

    @(posedge vif.clk iff vif.wready === 1'b1);
    vif.master_cb.wvalid <= 1'b0;
endtask : drive_wr_data_channel


task axi4_lite_driver::drive_wr_resp_channel();
    `uvm_info(get_type_name(), $sformatf("Driving WR_RESP: \n%s", req.sprint()), UVM_HIGH)

    // This channel can wait for the slave to raise the READY
    if(req.handshake_type == WAIT_TO_SEND) begin
        @(posedge vif.clk iff vif.bvalid === 1'b1);
    end
    
    lock_write = 1'b1;

    vif.master_cb.bready <= 1'b1;
    pipeline_lock.put();
    // Temp. I will create a flag later to randomize the delay to low the ready resp
    @(posedge vif.clk iff vif.bvalid === 1'b1);

    vif.master_cb.bready <= 1'b0;
    lock_write = 1'b0;
endtask : drive_wr_resp_channel