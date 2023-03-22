/********************************************** /
AXI4-Lite VIP

file: axi4_lite_pkg.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: VIP package
************************************************/

package axi4_lite_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    typedef virtual axi4_lite_if.mst axi4_lite_mst_vif;
    typedef virtual axi4_lite_if.slv axi4_lite_slv_vif;

    typedef enum bit[1:0] {FULL, MSB_HALF, LSB_HALF, RANDOM} wstrb_types_t;
    typedef enum bit[2:0] {WR_ADDR, WR_DATA, WR_RESP, RD_ADDR, RD_DATA} channels_t;
    typedef enum bit  {WAIT_TO_SEND, SEND_FIRST} handshake_t;
    
    `include "../sv/axi4_lite_packet.sv"

    `include "../sv/axi4_lite_sequencer.sv"
  	`include "../sv/sequences/axi4_lite_base_sequence.sv"
  	`include "../sv/sequences/axi4_lite_wr_master_sequence.sv"
  	`include "../sv/sequences/axi4_lite_rd_master_sequence.sv"
  	`include "../sv/sequences/axi4_lite_rd_slave_sequence.sv"
  	`include "../sv/sequences/axi4_lite_wr_slave_sequence.sv"

  	`include "../sv/agent/axi4_lite_base_driver.sv"
  	`include "../sv/agent/axi4_lite_master_driver.sv"
  	`include "../sv/agent/axi4_lite_slave_driver.sv"
    `include "../sv/agent/axi4_lite_agent_config.sv"
    `include "../sv/agent/axi4_lite_agent.sv"

	  `include "./axi4_lite_base_test.sv" 
	  `include "./axi4_lite_write_test.sv" 
endpackage : axi4_lite_pkg