/********************************************** /
AXI4-Lite VIP

file: axi4_lite_slave_rd_driver.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: The slave driver extends the base
driver and it's intended to drive into Master AXI 4
Lite designs
************************************************/

class axi4_lite_slave_rd_driver extends axi4_lite_base_rd_driver;
    `uvm_component_utils(axi4_lite_slave_rd_driver)

    function new(string name="axi4_lite_slave_rd_driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
   
    //Task: reset_phase (Compatibility with phase-jump)
    extern virtual task reset_phase(uvm_phase phase);

    // Task: drive_rd_addr_channel
    extern task automatic drive_rd_addr_channel(axi4_lite_packet pkt);
    
    // Task: drive_rd_data_channel
    extern task automatic drive_rd_data_channel(axi4_lite_packet pkt);

endclass : axi4_lite_slave_rd_driver


function void axi4_lite_slave_rd_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction: build_phase

task axi4_lite_slave_rd_driver::reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Reseting interface");
    
    slv_vif.slave_cb.arready <= rd_addr_always_ready;
    slv_vif.slave_cb.rvalid <= 'b0;
    slv_vif.slave_cb.rdata <= 'b0;
    slv_vif.slave_cb.rresp <= 'b0;

    phase.drop_objection(this, "Reseting interface - Done");
endtask : reset_phase

task axi4_lite_slave_rd_driver::drive_rd_addr_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving RD_ADDR channel: \n%s", req.sprint()), UVM_HIGH)

    // This channel can wait for the master to raise the ready
    if(rd_addr_always_ready) begin
        //Unlocks pipeline
        pipeline_lock.put();
        @(posedge slv_vif.clk iff slv_vif.arvalid === 1'b1);
    end else begin
        if(req.handshake_type == WAIT_TO_SEND) begin
            @(posedge slv_vif.clk iff (slv_vif.arvalid === 1'b1));
        end
    
        slv_vif.slave_cb.arready <= 1'b1;
    
        //Unlocks pipeline
        pipeline_lock.put();
        
        @(posedge slv_vif.clk iff slv_vif.arvalid === 1'b1);
        slv_vif.slave_cb.arready <= 1'b0;
    end
    // Sends response back to the sequence
    seq_item_port.put(pkt);
endtask : drive_rd_addr_channel


task axi4_lite_slave_rd_driver::drive_rd_data_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving RD_DATA: \n%s", req.sprint()), UVM_HIGH)
    
    // This channel cannot wait the master to raise the valid
    slv_vif.slave_cb.rvalid <= 1'b1;
    slv_vif.slave_cb.rresp <= pkt.resp;
    slv_vif.slave_cb.rdata <= pkt.data;
    // Unlocks pipeline
    pipeline_lock.put();

    @(posedge slv_vif.clk iff slv_vif.rready === 1'b1);
    slv_vif.slave_cb.rvalid<= 1'b0;

    // Sends response back to the sequence
    seq_item_port.put(pkt);
endtask : drive_rd_data_channel