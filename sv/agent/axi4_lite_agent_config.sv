class axi4_lite_agent_config extends uvm_object;
    `uvm_object_utils(axi4_lite_agent_config)

    bit is_master = 1'b1;
    bit has_monitor = 1'b0;
    int max_clks_to_handshake = 20;
    bit wr_addr_always_ready = 1'b0;
    bit wr_data_always_ready = 1'b0;
    bit wr_resp_always_ready = 1'b0;

    function new(string name="axi4_lite_agent_config");
        super.new(name);
    endfunction : new

endclass : axi4_lite_agent_config