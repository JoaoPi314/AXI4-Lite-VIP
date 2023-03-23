/********************************************** /
AXI4-Lite VIP

file: axi4_lite_base_rd_driver.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: The driver is capable of drive to master and
slave AXI4 Lite interfaces. This is done by overriding
the base driver into one of its childs. Each channel of
AXI4 Lite is independent and can be driven together
************************************************/

class axi4_lite_base_rd_driver extends uvm_driver#(axi4_lite_packet);
    `uvm_component_utils(axi4_lite_base_rd_driver)

    // Interfaces (See typedef in pkg)
    axi4_lite_mst_vif mst_vif;
    axi4_lite_slv_vif slv_vif;

    // Control variables
    semaphore pipeline_lock = new(1);
    int max_clks_to_handshake;
    bit is_master;
    bit rd_addr_always_ready;
    bit rd_data_always_ready;

    function new(string name = "axi4_lite_base_rd_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // Function: build_phase
    extern function void build_phase(uvm_phase phase);

    // Task: main_phase
    extern task main_phase(uvm_phase phase);

    /*
     * Task: pipeline_selector()
     * This task will check the sequence channel and call the
     * respective task to drive the data from sequence.
     */
    extern task automatic pipeline_selector(int id);

    /*
     * Task: drive_rd_addr_channel
     * This task will be responsible for drive the ready into the
     * read address channel of the AXI4 Lite
     */
     virtual task automatic drive_rd_addr_channel(axi4_lite_packet pkt);
     endtask

    /*
     * Task: drive_rd_data_channel
     * This task will be responsible for drive the ready into the
     * read data channel of the AXI4 Lite
     */
     virtual task automatic drive_rd_data_channel(axi4_lite_packet pkt);
     endtask

endclass: axi4_lite_base_rd_driver

function void axi4_lite_base_rd_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get configurations from agent 
    assert(uvm_config_db#(int)::get(this, "", "max_clks_to_handshake", max_clks_to_handshake))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration - max_clks_to_handshake")

    assert(uvm_config_db#(bit)::get(this, "", "is_master", is_master))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration - is_master")

    assert(uvm_config_db#(bit)::get(this, "", "rd_addr_always_ready", rd_addr_always_ready))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration - rd_addr_always_ready")

    assert(uvm_config_db#(bit)::get(this, "", "rd_data_always_ready", rd_data_always_ready))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration - rd_data_always_ready")

    assert(uvm_config_db#(axi4_lite_mst_vif)::get(this, "", "mst_vif", mst_vif))
        else `uvm_fatal(get_type_name(), "Failed to get virtual interface - mst")

    assert(uvm_config_db#(axi4_lite_slv_vif)::get(this, "", "slv_vif", slv_vif))
        else `uvm_fatal(get_type_name(), "Failed to get virtual interface - slv")
endfunction: build_phase


task axi4_lite_base_rd_driver::main_phase(uvm_phase phase);
    @(negedge mst_vif.arst_n);
    @(posedge mst_vif.arst_n);    

    // The IDs are to avoid concurrent get_next_item()
    fork
        pipeline_selector(0);
        pipeline_selector(1);
    join
endtask: main_phase


task axi4_lite_base_rd_driver::pipeline_selector(int id);
    
    
    axi4_lite_packet pkt = axi4_lite_packet::type_id::create("pkt");
    forever begin
        
        pipeline_lock.get();
        seq_item_port.get(req);
        $cast(pkt, req.clone());
        pkt.set_id_info(req);

        assert(pkt.active_channel == RD_ADDR || pkt.active_channel == RD_DATA)
            else `uvm_fatal(get_type_name(), "Trying to drive Write channels into Read driver is forbidden. Modify your sequences and run again")
            
        `uvm_info(get_type_name(), $sformatf("Driving %s channel in ID %d", pkt.active_channel.name(), id), UVM_HIGH)
        
        fork
            // Tries to make handshake with master/slave
            begin
                case(req.active_channel)
                    RD_ADDR: drive_rd_addr_channel(pkt);
                    RD_DATA: drive_rd_data_channel(pkt);
                endcase
            end
            // Waits to drop the channel if no response is received
            begin
                repeat(max_clks_to_handshake) @(posedge mst_vif.clk);
                `uvm_info(get_type_name(), $sformatf("Dropping %s channel - No response from Master/Slave...", pkt.active_channel.name()), UVM_LOW)
                case(pkt.active_channel)
                    RD_ADDR: if (is_master)
                                mst_vif.master_cb.arvalid <= 1'b0;
                             else slv_vif.slave_cb.arready <= 1'b0;
                    RD_DATA: if (is_master)
                                mst_vif.master_cb.rready <= 1'b0;
                             else slv_vif.slave_cb.rvalid <= 1'b0;
                endcase
                #id
                pipeline_lock.put();
                seq_item_port.put(pkt);
            end
        join_any
        // It's necessary to kill the non-finished process after one is finished
        disable fork;
    end 
endtask : pipeline_selector
