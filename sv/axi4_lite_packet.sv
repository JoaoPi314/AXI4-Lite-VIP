/********************************************** /
AXI4-Lite VIP

file: axi4_lite_packet.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: File containing the base transaction
that will be driven to the DUT (Slave or Master AXI4-Lite)
************************************************/

class axi4_lite_packet#(
    P_DATA_WIDTH = 32,
    P_ADDR_WIDTH = 32
) extends uvm_sequence_item;

    // Address channel
    rand bit [P_ADDR_WIDTH-1:0]     addr;
    rand bit [2:0]                  prot;
    
    // Data channel
    rand bit [P_DATA_WIDTH-1:0]     data;
    rand bit [2:0]                  resp;
    
    rand bit [P_DATA_WIDTH/8-1:0]   wstrb;

    // Control variables
    rand wstrb_types_t strb_types;
    rand channels_t active_channel;
    rand handshake_t handshake_type;

  	// To avoid warnings
  	int ok;
  
    `uvm_object_utils_begin(axi4_lite_packet)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(prot, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(wstrb, UVM_ALL_ON)
        `uvm_field_int(resp, UVM_ALL_ON)
        `uvm_field_enum(wstrb_types_t, strb_types, UVM_NOCOMPARE)
        `uvm_field_enum(channels_t, active_channel, UVM_NOCOMPARE)
        `uvm_field_enum(handshake_t, handshake_type, UVM_NOCOMPARE)
    `uvm_object_utils_end
    
    function new(string name="axi4_lite_packet");
        super.new(.name(name));
    endfunction : new

    // Base constraints
    constraint full_strb_c {
        strb_types == FULL;
    }
    constraint no_privilege_secure_data_access {
        prot == 3'b010;
    }
    // constraint default_resp{
    //     resp == 'b0;
    // }

    /**
    Function: update_wstrb
    Description: After the randomization, this function will
    look into the strb_types value and updates the strobe based
    on this value.
    */
    extern function void update_wstrb();

    function void post_randomize();
        update_wstrb();
    endfunction : post_randomize
endclass : axi4_lite_packet


function void axi4_lite_packet::update_wstrb();
    wstrb = {P_DATA_WIDTH/8{1'b0}};
    case(strb_types)
        FULL:       wstrb = {P_DATA_WIDTH/8{1'b1}};
        MSB_HALF:   wstrb[P_DATA_WIDTH/8-1 : P_DATA_WIDTH/16] = {1'b1};
        LSB_HALF:   wstrb[P_DATA_WIDTH/16-1 : 0] = {1'b1};
        RANDOM:     ok = this.randomize(wstrb);
    endcase
endfunction : update_wstrb