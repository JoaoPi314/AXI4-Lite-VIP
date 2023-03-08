class axi4_lite_agent_config extends uvm_object;
    `uvm_object_utils(axi4_lite_agent_config)

    bit is_master = 1'b1;
    bit has_monitor = 1'b0;
    bit valid_transfers = 1'b1;

    function new(string name="axi4_lite_agent_config");
        super.new(name);
    endfunction : new

endclass : axi4_lite_agent_config