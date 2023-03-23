/********************************************** /
AXI4-Lite VIP

file: axi4_lite_master_rd_driver.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: The master driver extends the base
driver and it's intended to drive into Slave AXI 4
Lite designs
************************************************/

class axi4_lite_master_rd_driver extends axi4_lite_base_rd_driver;
    `uvm_component_utils(axi4_lite_master_rd_driver)

    function new(string name = "axi4_lite_master_rd_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // Function: build_phase
    extern function void build_phase(uvm_phase phase);

    // Task: reset_phase (Compatibility with phase-jump)
    extern virtual task reset_phase(uvm_phase phase);

    // Task: drive_rd_addr_channel
    extern task automatic drive_rd_addr_channel(axi4_lite_packet pkt);
    
    // Task: drive_rd_data_channel
    extern task automatic drive_rd_data_channel(axi4_lite_packet pkt);
endclass: axi4_lite_master_rd_driver

function void axi4_lite_master_rd_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction: build_phase


task axi4_lite_master_rd_driver::reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Reseting interface");
    
    mst_vif.master_cb.arvalid <= 'b0;
    mst_vif.master_cb.araddr <= 'b0;
    mst_vif.master_cb.arprot <= 'b0;
    mst_vif.master_cb.rready <= rd_data_always_ready;

    phase.drop_objection(this, "Reseting interface - Done");
endtask : reset_phase


task axi4_lite_master_rd_driver::drive_rd_addr_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving RD_ADDR channel: \n%s", req.sprint()), UVM_HIGH)
    
    // This channel cannot wait for the ready to raise the valid
    mst_vif.master_cb.arvalid <= 1'b1;
    mst_vif.master_cb.araddr <= pkt.addr;
    pipeline_lock.put();
    
    @(posedge mst_vif.clk iff mst_vif.arready === 1'b1);
    mst_vif.master_cb.arvalid <= 1'b0;

    // Sends a response back to the sequence and unlocks the pipeline
    seq_item_port.put(pkt);
endtask : drive_rd_addr_channel


task axi4_lite_master_rd_driver::drive_rd_data_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving RD_DATA: \n%s", req.sprint()), UVM_HIGH)

    // This channel can wait for the slave to raise the ready
    if(rd_data_always_ready) begin
        @(posedge mst_vif.clk iff mst_vif.rvalid === 1'b1);
    end else begin
        if(req.handshake_type == WAIT_TO_SEND) begin
            @(posedge mst_vif.clk iff mst_vif.rvalid === 1'b1);
        end
        
        mst_vif.master_cb.rready <= 1'b1;
        
        @(posedge mst_vif.clk iff mst_vif.rvalid === 1'b1);        
        mst_vif.master_cb.rready <= 1'b0;
    end
    // Sends a response back to the sequence
    pipeline_lock.put();
    seq_item_port.put(pkt);
endtask : drive_rd_data_channel