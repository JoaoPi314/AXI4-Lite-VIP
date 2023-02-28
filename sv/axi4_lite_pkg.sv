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

    typedef virtual axi4_lite_if.mst axi4_lite_vif;
    typedef enum bit[1:0] {FULL, MSB_HALF, LSB_HALF, RANDOM} wstrb_types_t;
    typedef enum bit[2:0] {WR_ADDR, WR_DATA, WR_RESP, RD_ADDR, RD_DATA} channels_t;
    typedef enum bit  {WAIT_SLAVE, SEND_FIRST} handshake_t;
    
    `include "./axi4_lite_packet.sv"

    `include "./axi4_lite_sequencer.sv"
  	`include "./axi4_lite_base_sequence.sv"
  	`include "./axi4_lite_wr_addr_master_sequence.sv"
  	`include "./axi4_lite_wr_data_master_sequence.sv"
    `include "./axi4_lite_wr_resp_master_sequence.sv"
  	`include "./axi4_lite_wr_master_sequence.sv"

  	`include "./axi4_lite_driver.sv"

	`include "./axi4_lite_base_test.sv"  

endpackage : axi4_lite_pkg