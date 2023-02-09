/********************************************** /
AXI4-Lite VIP

file: axi4_lite_packet.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: File containing all the transactions
that will be driven to the DUT (Slave or Master AXI4-Lite)
************************************************/
typedef enum bit[1:0] {FULL, MSB_HALF, LSB_HALF, RANDOM} wstrb_types_t;
typedef enum bit[2:0] {WR_ADDR, WR_DATA, WR_RESP, RD_ADDR, RD_DATA} channels_t;

class axi4_lite_packet#(
    P_DATA_WIDTH = 32,
    P_ADDR_WIDTH = 32
) extends uvm_sequence_item;

    // Write address channel
    rand bit [P_ADDR_WIDTH-1:0]     awaddr;
    rand bit [2:0]                  awprot;
    
    // Write data channel
    rand bit [P_DATA_WIDTH-1:0]     wdata;
    rand bit [P_DATA_WIDTH/8-1:0]        wstrb;

    // Write response channel
    rand bit [2:0]                  bresp;

    // Read address channel
    rand bit [P_ADDR_WIDTH-1:0]     araddr;
    rand bit [2:0]                  arprot;

    // Read data channel
    rand bit [P_DATA_WIDTH-1:0]     rdata;
    rand bit [2:0]                  rresp;

    // Control variables
    rand wstrb_types_t strb_types;
    rand channels_t active_channel;

  	// To avoid warnings
  	int ok;
  
    `uvm_object_utils_begin(axi4_lite_packet)
        `uvm_field_int(awaddr, UVM_ALL_ON)
        `uvm_field_int(awprot, UVM_ALL_ON)
        `uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(wstrb, UVM_ALL_ON)
        `uvm_field_int(bresp, UVM_ALL_ON)
        `uvm_field_int(araddr, UVM_ALL_ON)
        `uvm_field_int(arprot, UVM_ALL_ON)
        `uvm_field_int(rdata, UVM_ALL_ON)
        `uvm_field_int(rresp, UVM_ALL_ON)
        `uvm_field_enum(wstrb_types_t, strb_types, UVM_NOCOMPARE)
        `uvm_field_enum(channels_t, active_channel, UVM_NOCOMPARE)
    `uvm_object_utils_end
    
    function new(string name="axi4_lite_packet");
        super.new(.name(name));
    endfunction : new


    // Base constraints
    constraint full_strb_c {
        strb_types == FULL;
    }

    constraint no_privilege_secure_data_access {
        awprot == 3'b010;
        arprot == 3'b010;
    }

    constraint default_resp{
        bresp == 'b0;
        rresp == 'b0;
    }

    function void update_wstrb();
     	wstrb = {P_DATA_WIDTH/8{1'b0}};
        case(strb_types)
            FULL:       wstrb = {P_DATA_WIDTH/8{1'b1}};
            MSB_HALF:   wstrb[P_DATA_WIDTH/8-1 : P_DATA_WIDTH/16] = {1'b1};
            LSB_HALF:   wstrb[P_DATA_WIDTH/16-1 : 0] = {1'b1};
            RANDOM:     ok = this.randomize(wstrb);
        endcase
        
    endfunction : update_wstrb


    function void post_randomize();
        update_wstrb();
    endfunction : post_randomize


endclass : axi4_lite_packet