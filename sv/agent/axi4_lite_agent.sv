class axi4_lite_agent extends uvm_agent;
    `uvm_component_utils(axi4_lite_agent)

    axi4_lite_agent_config agt_cfg;

    axi4_lite_base_driver drv;
    axi4_lite_sequencer sqr;
    
    function new(string name="axi4_lite_agent", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    extern function void build_phase(uvm_phase phase);

    extern function void connect_phase(uvm_phase phase);

endclass : axi4_lite_agent



function void axi4_lite_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

    assert(uvm_config_db#(axi4_lite_agent_config)::get(this, "", "agt_cfg", this.agt_cfg))
    else `uvm_fatal(get_type_name(), "Failed to config master or slave agent")
    
    uvm_config_db#(int)::set(this, "drv", "max_clks_to_handshake", agt_cfg.max_clks_to_handshake);
    uvm_config_db#(bit)::set(this, "drv", "is_master", agt_cfg.is_master);


    if(!agt_cfg.is_master)
        set_inst_override_by_type("*", axi4_lite_base_driver::get_type(), axi4_lite_slave_driver::get_type());
    else
        set_inst_override_by_type("*", axi4_lite_base_driver::get_type(), axi4_lite_master_driver::get_type());

    drv = axi4_lite_base_driver::type_id::create("drv", this);
    sqr = axi4_lite_sequencer::type_id::create("sqr", this);
endfunction : build_phase

function void axi4_lite_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(sqr.seq_item_export);
endfunction : connect_phase