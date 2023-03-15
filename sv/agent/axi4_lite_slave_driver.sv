class axi4_lite_slave_driver extends axi4_lite_base_driver;
    `uvm_component_utils(axi4_lite_slave_driver)

    function new(string name="axi4_lite_slave_driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);

    // Task: reset_phase
    extern task reset_phase(uvm_phase phase);
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


endclass : axi4_lite_slave_driver


function void axi4_lite_slave_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction: build_phase

task axi4_lite_slave_driver::reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Reseting interface");
    
    slv_vif.slave_cb.awready <= wr_addr_always_ready;
    slv_vif.slave_cb.wready <= wr_data_always_ready;
    slv_vif.slave_cb.bvalid <= 'b0;
    slv_vif.slave_cb.bresp <= 'b0;
    slv_vif.slave_cb.arready <= 'b0;
    slv_vif.slave_cb.rvalid <= 'b0;
    slv_vif.slave_cb.rdata <= 'b0;
    slv_vif.slave_cb.rresp <= 'b0;
    slv_vif.slave_cb.araddr <= 'b0;

    phase.drop_objection(this, "Reseting interface - Done");
endtask : reset_phase

task axi4_lite_slave_driver::drive_wr_addr_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving WR_ADDR channel: \n%s", req.sprint()), UVM_HIGH)


    if(wr_addr_always_ready) begin
        //Unlocks pipeline
        pipeline_lock.put();

        @(posedge slv_vif.clk iff slv_vif.awvalid === 1'b1);
    end else begin
        if(req.handshake_type == WAIT_TO_SEND) begin
            @(posedge slv_vif.clk iff (slv_vif.awvalid === 1'b1));
        end
    
        slv_vif.slave_cb.awready <= 1'b1;
    
        //Unlocks pipeline
        pipeline_lock.put();
        
        @(posedge slv_vif.clk iff slv_vif.awvalid === 1'b1);
        slv_vif.slave_cb.awready <= 1'b0;

    end
    
    seq_item_port.put_response(pkt);

endtask : drive_wr_addr_channel

task axi4_lite_slave_driver::drive_wr_data_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving WR_DATA channel: \n%s", req.sprint()), UVM_HIGH)
    
    if(wr_data_always_ready) begin
        //Unlocks pipeline
        pipeline_lock.put();
        
        @(posedge slv_vif.clk iff slv_vif.wvalid === 1'b1);
    end else begin 
        if(req.handshake_type == WAIT_TO_SEND) begin
            @(posedge slv_vif.clk iff (slv_vif.wvalid === 1'b1));
        end

        slv_vif.slave_cb.wready <= 1'b1;

        //Unlocks pipeline
        pipeline_lock.put();
        
        @(posedge slv_vif.clk iff slv_vif.wvalid === 1'b1);
        slv_vif.slave_cb.wready <= 1'b0;
    end
    seq_item_port.put_response(pkt);

endtask : drive_wr_data_channel


task axi4_lite_slave_driver::drive_wr_resp_channel(axi4_lite_packet pkt);
    `uvm_info(get_type_name(), $sformatf("Driving WR_RESP: \n%s", req.sprint()), UVM_HIGH)
    
    slv_vif.slave_cb.bvalid <= 1'b1;
    slv_vif.slave_cb.bresp <= req.resp;
    pipeline_lock.put();

    @(posedge slv_vif.clk iff slv_vif.bready === 1'b1);

    slv_vif.slave_cb.bvalid<= 1'b0;

    seq_item_port.put_response(pkt);

endtask : drive_wr_resp_channel