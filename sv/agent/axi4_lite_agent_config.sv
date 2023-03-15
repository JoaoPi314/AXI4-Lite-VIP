/********************************************** /
AXI4-Lite VIP

file: axi4_lite_agent_config.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: VIP Configuration file. It contains
all the possible configurations, each one is des-
cribed here and
***********************************************/ 

class axi4_lite_agent_config extends uvm_object;
    `uvm_object_utils(axi4_lite_agent_config)
    
    /*
     * is_master: Bit that controls if the agent will be
     * a master agent (to use with a Slave DUT) or a slave
     * agent (to use with a Master DUT).
     */
    bit is_master = 1'b1;

    /*
     * has_monitor: Bit that controls if the VIP will create a
     * monitor. Just in case the user wants to send data to a
     * scoreboard or just drive data into the interface.
     */
    bit has_monitor = 1'b0;
    
    /*
     * max_clks_to_handshake: It controls the maximum number
     of clk periods to the active channel stop waiting a response from
     master or slave.
     */
    int max_clks_to_handshake = 20;

    /*
     * *_always_ready: Each flag controls if the receiver of that channel
     * will always be ready to receive the transaction or not
     */
    bit wr_addr_always_ready = 1'b0;
    bit wr_data_always_ready = 1'b0;
    bit wr_resp_always_ready = 1'b0;

    function new(string name="axi4_lite_agent_config");
        super.new(name);
    endfunction : new
endclass : axi4_lite_agent_config