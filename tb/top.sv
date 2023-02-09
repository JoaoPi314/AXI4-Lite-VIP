module top;

    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "../sv/axi4_lite_packet.sv"

    axi4_lite_packet p1;


    initial begin
        p1 = new("p1");
    end

endmodule : top