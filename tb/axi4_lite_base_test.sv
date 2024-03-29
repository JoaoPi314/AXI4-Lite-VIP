/********************************************** /
AXI4-Lite VIP

file: axi4_lite_base_test.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: Base test class
************************************************/
class axi4_lite_base_test extends uvm_test;
    `uvm_component_utils(axi4_lite_base_test)

    // Components

    axi4_lite_env mst_env;
    axi4_lite_env slv_env;

    axi4_lite_agent_config mst_env_cfg;
    axi4_lite_agent_config slv_env_cfg;


    function new(string name = "axi4_lite_base_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // Function: build_phase
    extern function void build_phase(uvm_phase phase);

    // Function: end_of_elaboration_phase
    extern function void end_of_elaboration_phase(uvm_phase phase);

endclass: axi4_lite_base_test


function void axi4_lite_base_test::build_phase(uvm_phase phase);
  	super.build_phase(phase);
	
    // Creates agent configurations
    mst_env_cfg = axi4_lite_agent_config::type_id::create("mst_env_cfg", this);
    slv_env_cfg = axi4_lite_agent_config::type_id::create("slv_env_cfg", this);

    // Sets configuration to respective agents
    uvm_config_db#(axi4_lite_agent_config)::set(null, "uvm_test_top.mst_env", "env_cfg", this.mst_env_cfg);
    uvm_config_db#(axi4_lite_agent_config)::set(null, "uvm_test_top.slv_env", "env_cfg", this.slv_env_cfg);
    
    // Configures the agents
    mst_env_cfg.is_master = 1'b1;
    slv_env_cfg.is_master = 1'b0;

    // mst_agt_cfg.wr_resp_always_ready = 1'b1;
    // slv_agt_cfg.wr_addr_always_ready = 1'b1;
    // slv_agt_cfg.wr_data_always_ready = 1'b1;
    // mst_agt_cfg.rd_data_always_ready = 1'b1;
    // slv_agt_cfg.rd_addr_always_ready = 1'b1;


    // Creates the agents
    mst_env = axi4_lite_env::type_id::create("mst_env", this);
    slv_env = axi4_lite_env::type_id::create("slv_env", this);
endfunction: build_phase


function void axi4_lite_base_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction: end_of_elaboration_phase
