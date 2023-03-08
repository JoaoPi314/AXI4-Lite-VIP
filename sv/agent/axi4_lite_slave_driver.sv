class axi4_lite_slave_driver extends axi4_lite_driver;
    `uvm_component_utils(axi4_lite_slave_driver)


    bit wr_addr_finish = 1'b0;
    bit wr_data_finish = 1'b0;

    axi4_lite_slv_vif vif;

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
    extern task automatic drive_wr_addr_channel();


    /*
    Task: drive_wr_data_channel
    This task will be responsible for drive data into the
    write dataess channel of the AXI4 Lite
    */
    extern task automatic drive_wr_data_channel();
    
    /*
    Task: drive_wr_resp_channel
    This task will be responsible for drive the ready into the
    write response channel of the AXI4 Lite
    */
    extern task automatic drive_wr_resp_channel();


endclass : axi4_lite_slave_driver


function void axi4_lite_slave_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(axi4_lite_slv_vif)::get(this, "", "slv_vif", vif))
    else `uvm_fatal(get_type_name(), "Failed to get virtual interface")
endfunction: build_phase

task axi4_lite_slave_driver::reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Reseting interface");
    
    vif.slave_cb.awready <= 'b0;
    vif.slave_cb.wready <= 'b0;
    vif.slave_cb.bvalid <= 'b0;
    vif.slave_cb.bresp <= 'b0;
    vif.slave_cb.arready <= 'b0;
    vif.slave_cb.rvalid <= 'b0;
    vif.slave_cb.rdata <= 'b0;
    vif.slave_cb.rresp <= 'b0;
    vif.slave_cb.araddr <= 'b0;

    phase.drop_objection(this, "Reseting interface - Done");
endtask : reset_phase

task axi4_lite_slave_driver::drive_wr_addr_channel();
    `uvm_info(get_type_name(), $sformatf("Driving WR_ADDR channel: \n%s", req.sprint()), UVM_HIGH)


    if(req.handshake_type == WAIT_TO_SEND) begin
        @(posedge vif.awvalid);
    end

    vif.slave_cb.awready <= 1'b1;

    //Unlocks pipeline
    pipeline_lock.put();

    @(posedge vif.clk iff vif.awvalid === 1'b1);
    vif.slave_cb.awready <= 1'b0;

    wr_addr_finish = 1'b1;

endtask : drive_wr_addr_channel

task axi4_lite_slave_driver::drive_wr_data_channel();
    `uvm_info(get_type_name(), $sformatf("Driving WR_DATA channel: \n%s", req.sprint()), UVM_HIGH)
    
    if(req.handshake_type == WAIT_TO_SEND) begin
        @(posedge vif.wvalid);
    end

    vif.slave_cb.wready <= 1'b1;

    //Unlocks pipeline
    pipeline_lock.put();

    @(posedge vif.clk iff vif.wvalid === 1'b1);
    vif.slave_cb.wready <= 1'b0;

    wr_data_finish = 1'b1;

endtask : drive_wr_data_channel


task axi4_lite_slave_driver::drive_wr_resp_channel();
    `uvm_info(get_type_name(), $sformatf("Driving WR_RESP: \n%s", req.sprint()), UVM_HIGH)

    
    @(posedge vif.clk iff (wr_data_finish & wr_addr_finish));
    
    vif.slave_cb.bvalid <= 1'b1;
    vif.slave_cb.bresp <= req.resp;
    pipeline_lock.put();

    @(posedge vif.clk iff vif.bready === 1'b1);

    vif.slave_cb.bvalid<= 1'b0;

    wr_addr_finish = 1'b0;
    wr_data_finish = 1'b0;

endtask : drive_wr_resp_channel