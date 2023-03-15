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

    axi4_lite_mst_vif mst_vif;
    axi4_lite_slv_vif slv_vif;

    semaphore pipeline_lock = new(1);
    int max_clks_to_handshake;
    bit is_master;
    bit wr_addr_always_ready;
    bit wr_data_always_ready;
    bit wr_resp_always_ready;


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
    extern task automatic pipeline_selector(int id);


    /*
    Task: drive_wr_addr_channel
    This task will be responsible for drive data into the
    write address channel of the AXI4 Lite
    */
    virtual task automatic drive_wr_addr_channel(axi4_lite_packet pkt);
    endtask


    /*
    Task: drive_wr_data_channel
    This task will be responsible for drive data into the
    write dataess channel of the AXI4 Lite
    */
    virtual task automatic drive_wr_data_channel(axi4_lite_packet pkt);
    endtask

    /*
    Task: drive_wr_resp_channel
    This task will be responsible for drive the ready into the
    write response channel of the AXI4 Lite
    */
    virtual task automatic drive_wr_resp_channel(axi4_lite_packet pkt);
    endtask

endclass: axi4_lite_base_driver

function void axi4_lite_base_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    assert(uvm_config_db#(int)::get(this, "", "max_clks_to_handshake", max_clks_to_handshake))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration - max_clks_to_handshake")

    assert(uvm_config_db#(bit)::get(this, "", "is_master", is_master))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration - is_master")

    assert(uvm_config_db#(bit)::get(this, "", "wr_addr_always_ready", wr_addr_always_ready))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration - wr_addr_always_ready")

    assert(uvm_config_db#(bit)::get(this, "", "wr_data_always_ready", wr_data_always_ready))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration - wr_data_always_ready")

    assert(uvm_config_db#(bit)::get(this, "", "wr_resp_always_ready", wr_resp_always_ready))
        else `uvm_fatal(get_type_name(), "Failed to get agent configuration - wr_resp_always_ready")

    assert(uvm_config_db#(axi4_lite_mst_vif)::get(this, "", "mst_vif", mst_vif))
        else `uvm_fatal(get_type_name(), "Failed to get virtual interface - mst")

    assert(uvm_config_db#(axi4_lite_slv_vif)::get(this, "", "slv_vif", slv_vif))
        else `uvm_fatal(get_type_name(), "Failed to get virtual interface - slv")
endfunction: build_phase


task axi4_lite_base_driver::main_phase(uvm_phase phase);
    @(negedge mst_vif.arst_n);
    @(posedge mst_vif.arst_n);    

    fork
        pipeline_selector(0);
        pipeline_selector(1);
        pipeline_selector(2);
    join
endtask: main_phase


task axi4_lite_base_driver::pipeline_selector(int id);
    forever begin
        #id pipeline_lock.get();
        seq_item_port.get(req);
        fork
            begin
                case(req.active_channel)
                    WR_ADDR: drive_wr_addr_channel(req);
                    WR_DATA: drive_wr_data_channel(req);
                    WR_RESP: drive_wr_resp_channel(req);
                endcase
            end
            
            begin
                repeat(max_clks_to_handshake) @(posedge mst_vif.clk);
                `uvm_info(get_type_name(), $sformatf("Dropping %s channel - No response from Master/Slave...", req.active_channel.name()), UVM_LOW)
                case(req.active_channel)
                    WR_ADDR: if (is_master)
                                mst_vif.master_cb.awvalid <= 1'b0;
                             else slv_vif.slave_cb.awready <= 1'b0;
                    WR_DATA: if (is_master)
                                mst_vif.master_cb.wvalid <= 1'b0;
                             else slv_vif.slave_cb.wready <= 1'b0;
                    WR_RESP: if (is_master)
                                mst_vif.master_cb.bready <= 1'b0;
                             else slv_vif.slave_cb.bvalid <= 1'b0;
                endcase
                #id
                pipeline_lock.put();
            end
        join_any
        disable fork;
    end 
endtask : pipeline_selector
