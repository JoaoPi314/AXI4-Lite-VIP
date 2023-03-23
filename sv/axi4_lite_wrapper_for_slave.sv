/********************************************** /
AXI4-Lite VIP

file: axi4_lite_wrapper_for_slave.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: AXI4-Lite wrapper to drive interface to 
a slave DUT (Prevent an error involving clocking blocks)
************************************************/

module axi4_lite_wrapper_for_slave(output_if, cb_if);
    axi4_lite_wrapper_if output_if;
    axi4_lite_if cb_if;

    assign output_if.clk = cb_if.clk;
    assign output_if.arst_n = cb_if.arst_n;

    assign output_if.awaddr = cb_if.awaddr;
    assign output_if.awvalid = cb_if.awvalid;
    assign output_if.awprot = cb_if.awprot;

    assign output_if.wvalid = cb_if.wvalid;
    assign output_if.wdata = cb_if.wdata;
    assign output_if.wstrb = cb_if.wstrb;

    assign output_if.bready = cb_if.bready;

    assign output_if.arvalid = cb_if.arvalid;
    assign output_if.araddr = cb_if.araddr;
    assign output_if.arprot = cb_if.arprot;

    assign output_if.rready = cb_if.rready;


    always@(*)begin
        cb_if.awready = output_if.awready;
        cb_if.wready = output_if.wready;
        cb_if.bvalid = output_if.bvalid;
        cb_if.bresp = output_if.bresp;
        cb_if.arready = output_if.arready;
        cb_if.rvalid = output_if.rvalid;
        cb_if.rdata = output_if.rdata;
        cb_if.rresp = output_if.rresp;
    end





endmodule : axi4_lite_wrapper_for_slave