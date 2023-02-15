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

    axi4_lite_vif vif;

    //  Constructor: new
    function new(string name = "axi4_lite_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);

    //  Task: main_phase
    extern task main_phase(uvm_phase phase);


    /*
    Task: drive_wr_addr_channel
    This task will be responsible for drive data into the
    write address channel of the AXI4 Lite
    */
    extern task drive_wr_addr_channel();


    /*
    Task: drive_wr_data_channel
    This task will be responsible for drive data into the
    write dataess channel of the AXI4 Lite
    */
    extern task drive_wr_data_channel();
    
    /*
    Task: drive_wr_resp_channel
    This task will be responsible for drive the ready into the
    write response channel of the AXI4 Lite
    */
    extern task drive_wr_resp_channel();

endclass: axi4_lite_driver

function void axi4_lite_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(axi4_lite_vif)::get(this, "", "vif", vif))
        else `uvm_fatal(get_type_name(), "Failed to get virtual interface")
endfunction: build_phase


task axi4_lite_driver::main_phase(uvm_phase phase);
    @(negedge vif.arst_n);
    @(posedge vif.arst_n);

    forever begin
        drive_wr_addr_channel();
        drive_wr_data_channel();
        drive_wr_resp_channel();
    end
endtask: main_phase

task axi4_lite_driver::drive_wr_addr_channel();
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("Driver got a transaction: \n%s", req.sprint()), UVM_HIGH)
    
    // This channel cannot wait for the ready to raise the valid

    vif.awvalid = 1'b1;
    vif.awaddr = req.addr;

    @(negedge vif.awready);
    vif.awvalid = 1'b0;
    seq_item_port.item_done();
endtask : drive_wr_addr_channel

task axi4_lite_driver::drive_wr_data_channel();
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("Driver got a transaction: \n%s", req.sprint()), UVM_HIGH)
    
    if(req.handshake_type == WAIT_READY)
        @(posedge vif.wready);

    vif.wvalid = 1'b1;
    vif.wdata = req.data;
    vif.wstrb = req.wstrb;

    @(negedge vif.wready);
    vif.wvalid = 1'b0;
    seq_item_port.item_done();
endtask : drive_wr_data_channel


task axi4_lite_driver::drive_wr_resp_channel();
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("Driver got a transaction: \n%s", req.sprint()), UVM_HIGH)
    
    if(req.handshake_type == WAIT_READY)
        @(posedge vif.bvalid);

    vif.bready = 1'b1;
    
    repeat(10) @(posedge vif.clk);

    vif.bready = 1'b0;
    seq_item_port.item_done();
endtask : drive_wr_resp_channel