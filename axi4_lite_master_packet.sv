/********************************************** /
AXI4-Lite VIP

file: axi4_lite_master_packet.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: This transaction and all child ones
must be used if the DUT is a SLAVE AXI4-Lite.
************************************************/
typedef enum bit {FULL, MSB_HALF, LSB_HALF, RANDOM} wstrb_types_t;

class axi4_lite_master_packet#(
    P_DATA_WIDTH = 32,
    P_ADDR_WIDTH = 32
) extends uvm_sequence_item;

    // Packet variables
    rand bit [P_ADDR_WIDTH-1:0]     awaddr;
    rand bit [P_ADDR_WIDTH-1:0]     araddr;

    rand bit [2:0]                  awprot;
    rand bit [2:0]                  arprot;

    rand bit [P_DATA_WIDTH-1:0]     wdata;
    bit [P_DATA_WIDTH/8-1:0]        wstrb;

    // Control variables
    rand wstrb_types_t strb_types;


    `uvm_object_utils_begin(axi4_lite_master_packet)
        `uvm_field_int(awaddr, UVM_ALL_ON)
        `uvm_field_int(araddr, UVM_ALL_ON)
        `uvm_field_int(awprot, UVM_ALL_ON)
        `uvm_field_int(arprot, UVM_ALL_ON)
        `uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(wstrb, UVM_ALL_ON)
        `uvm_field_enum(wstrb_types_t, strb_types, UVM_NOCOMPARE)
    `uvm_object_utils_end
    
    function new(string name="axi4_lite_master_packet");
        super.new(.name(name));
    endfunction : new


    // Base constraints
    constraint full_strb_c {
        strb_types = FULL;
    }

    constraint no_privilege_secure_data_access {
        awprot = 3'b010;
        arprot = 3'b010;
    }

    function void update_wstrb();
        wstrb = {P_DATA_WIDTH/8{1'b0}}
        case(strb_types)
            FULL:       wstrb = {P_DATA_WIDTH/8{1'b1}};
            MSB_HALF:   wstrb[P_DATA_WIDTH/8-1 : P_DATA_WIDTH/16] = {1'b1};
            LSB_HALF:   wstrb[P_DATA_WIDTH/16-1 : 0] = {1'b1};
            RANDOM:     wstrb.randomize();
        endcase
        
    endfunction : update_wstrb


    void function post_randomize();
        update_wstrb();
    endfunction : post_randomize


endclass : axi4_lite_master_packet