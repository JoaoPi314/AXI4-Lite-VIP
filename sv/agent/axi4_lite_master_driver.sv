/********************************************** /
AXI4-Lite VIP

file: axi4_lite_master_driver.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: The driver is capable of drive to master and
slave AXI4 Lite interfaces. It will be pipelined to drive
multichannels in parallel.
************************************************/

class axi4_lite_master_driver extends axi4_lite_base_driver;
    `uvm_component_utils(axi4_lite_master_driver)

    //  Constructor: new
    function new(string name = "axi4_lite_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);


    //Task: reset_phase

    extern virtual task reset_phase(uvm_phase phase);

    /*
    Task: drive_wr_addr_channel
    This task will be responsible for drive data into the
    write address channel of the AXI4 Lite
    */
    extern task automatic drive_wr_addr_channel(axi4_lite_packet pkt);


    /*
    Task: drive_wr_data_channel
    This task will be responsible for drive data into the
    write dataess channel of the AXI4 Lite
    */
    extern task automatic drive_wr_data_channel(axi4_lite_packet pkt);

    /*
    Task: drive_wr_resp_channel
    This task will be responsible for drive the ready into the
    write response channel of the AXI4 Lite
    */
    extern task automatic drive_wr_resp_channel(axi4_lite_packet pkt);

endclass: axi4_lite_master_driver

function void axi4_lite_master_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction: build_phase


task axi4_lite_master_driver::reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Reseting interface");
    
    mst_vif.master_cb.awvalid <= 'b0;
    mst_vif.master_cb.awaddr <= 'b0;
    mst_vif.master_cb.awprot <= 'b0;
    mst_vif.master_cb.wvalid <= 'b0;
    mst_vif.master_cb.wdata <= 'b0;
    mst_vif.master_cb.wstrb <= 'b0;
    mst_vif.master_cb.bready <= 'b0;
    mst_vif.master_cb.arvalid <= 'b0;
    mst_vif.master_cb.araddr <= 'b0;
    mst_vif.master_cb.arprot <= 'b0;
    mst_vif.master_cb.rready <= 'b0;


    phase.drop_objection(this, "Reseting interface - Done");
endtask : reset_phase

task axi4_lite_master_driver::drive_wr_addr_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving WR_ADDR channel: \n%s", req.sprint()), UVM_HIGH)
    
    // This channel cannot wait for the ready to raise the valid
    mst_vif.master_cb.awvalid <= 1'b1;
    mst_vif.master_cb.awaddr <= req.addr;

    //Unlocks pipeline    
    seq_item_port.put_response(pkt);
    pipeline_lock.put();
    @(posedge mst_vif.clk iff mst_vif.awready === 1'b1);
    mst_vif.master_cb.awvalid <= 1'b0;

endtask : drive_wr_addr_channel

task axi4_lite_master_driver::drive_wr_data_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving WR_DATA channel: \n%s", req.sprint()), UVM_HIGH)

    // This channel cannot wait for the ready to raise the valid
    mst_vif.master_cb.wvalid <= 1'b1;
    mst_vif.master_cb.wdata <= req.data;
    mst_vif.master_cb.wstrb <= req.wstrb;

    //Unlocks pipeline
    seq_item_port.put_response(pkt);
    pipeline_lock.put();

    @(posedge mst_vif.clk iff mst_vif.wready === 1'b1);
    mst_vif.master_cb.wvalid <= 1'b0;
endtask : drive_wr_data_channel


task axi4_lite_master_driver::drive_wr_resp_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving WR_RESP: \n%s", req.sprint()), UVM_HIGH)

    // This channel can wait for the slave to raise the READY
    if(req.handshake_type == WAIT_TO_SEND) begin
        @(posedge mst_vif.clk iff mst_vif.bvalid === 1'b1);
    end
    
    mst_vif.master_cb.bready <= 1'b1;
    pipeline_lock.put();
    // Temp. I will create a flag later to randomize the delay to low the ready resp
    @(posedge mst_vif.clk iff mst_vif.bvalid === 1'b1);
    
    mst_vif.master_cb.bready <= 1'b0;
    seq_item_port.put_response(pkt);
endtask : drive_wr_resp_channel