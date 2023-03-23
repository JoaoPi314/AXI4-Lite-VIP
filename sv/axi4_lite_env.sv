/********************************************** /
AXI4-Lite VIP

file: axi4_lite_env.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: VIP environment
************************************************/

class axi4_lite_env extends uvm_env;
    `uvm_component_utils(axi4_lite_env)

    axi4_lite_wr_agent wr_agent;
    axi4_lite_rd_agent rd_agent;

    axi4_lite_agent_config env_cfg;
    
    function new(string name="axi4_lite_env", uvm_component parent);
        super.new(.name(name), .parent(parent));
    endfunction : new

    // Function: build_phase
    extern virtual function void build_phase(uvm_phase phase);
endclass : axi4_lite_env


function void axi4_lite_env::build_phase(uvm_phase phase);
    super.build_phase(phase);

    assert(uvm_config_db#(axi4_lite_agent_config)::get(this, "", "env_cfg", this.env_cfg))
        else `uvm_fatal(get_type_name(), "Failed to get configuration from test")

    uvm_config_db#(axi4_lite_agent_config)::set(this, "wr_agent", "agt_cfg", this.env_cfg);
    uvm_config_db#(axi4_lite_agent_config)::set(this, "rd_agent", "agt_cfg", this.env_cfg);
    
    wr_agent = axi4_lite_wr_agent::type_id::create("wr_agent", this);
    rd_agent = axi4_lite_rd_agent::type_id::create("rd_agent", this);
endfunction : axi4_lite_env