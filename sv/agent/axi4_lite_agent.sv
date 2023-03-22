/********************************************** /
AXI4-Lite VIP

file: axi4_lite_agent.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: VIP agent. It will instantiate the
driver and (if desired) the monitor. The configurations
are passed to the driver via config_db.
***********************************************/ 

class axi4_lite_agent extends uvm_agent;
    `uvm_component_utils(axi4_lite_agent)

    // UVM components
    axi4_lite_agent_config agt_cfg;

    axi4_lite_base_driver drv;
    axi4_lite_sequencer sqr;

    function new(string name="axi4_lite_agent", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Function: build_phase
    extern function void build_phase(uvm_phase phase);
   
    // Function: connect_phase
    extern function void connect_phase(uvm_phase phase);
endclass : axi4_lite_agent



function void axi4_lite_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Receives the configuration from the test or environment
    assert(uvm_config_db#(axi4_lite_agent_config)::get(this, "", "agt_cfg", this.agt_cfg))
        else `uvm_fatal(get_type_name(), "Failed to config master or slave agent")
    
    // Sets driver control variables
    uvm_config_db#(int)::set(this, "drv", "max_clks_to_handshake", agt_cfg.max_clks_to_handshake);
    uvm_config_db#(bit)::set(this, "drv", "is_master", agt_cfg.is_master);
    uvm_config_db#(bit)::set(this, "drv", "wr_addr_always_ready", agt_cfg.wr_addr_always_ready);
    uvm_config_db#(bit)::set(this, "drv", "wr_data_always_ready", agt_cfg.wr_data_always_ready);
    uvm_config_db#(bit)::set(this, "drv", "wr_resp_always_ready", agt_cfg.wr_resp_always_ready);
    uvm_config_db#(bit)::set(this, "drv", "rd_addr_always_ready", agt_cfg.rd_addr_always_ready);
    uvm_config_db#(bit)::set(this, "drv", "rd_data_always_ready", agt_cfg.rd_data_always_ready);

    // Selects if the agent will be a master or slave
    if(!agt_cfg.is_master)
        set_inst_override_by_type("*", axi4_lite_base_driver::get_type(), axi4_lite_slave_driver::get_type());
    else
        set_inst_override_by_type("*", axi4_lite_base_driver::get_type(), axi4_lite_master_driver::get_type());

    // Creates the other components
    drv = axi4_lite_base_driver::type_id::create("drv", this);
    sqr = axi4_lite_sequencer::type_id::create("sqr", this);
endfunction : build_phase


function void axi4_lite_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
endfunction : connect_phase