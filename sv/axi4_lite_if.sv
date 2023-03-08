/********************************************** /
AXI4-Lite VIP

file: axi4_lite_if.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: AXI4-Lite parametrized interface
************************************************/


interface axi4_lite_if #(
    P_DATA_WIDTH = 32,
    P_ADDR_WIDTH = 32
)(input clk, arst_n);

    // Write addr channel
    logic                       awvalid;
    logic                       awready;
    logic [P_ADDR_WIDTH-1:0]    awaddr;
    logic [2:0]                 awprot;

    // Write data channel
    logic                       wvalid;
    logic                       wready;
    logic [P_DATA_WIDTH-1:0]    wdata;
    logic [P_DATA_WIDTH/8-1:0]  wstrb;

    // Write response channel
    logic                       bvalid;
    logic                       bready;
    logic [2:0]                 bresp;

    // Read address channel
    logic                       arvalid;
    logic                       arready;
    logic [P_ADDR_WIDTH-1:0]    araddr;
    logic [2:0]                 arprot;

    // Read data channel
    logic                       rvalid;
    logic                       rready;
    logic [P_DATA_WIDTH-1:0]    rdata;
    logic [2:0]                 rresp;


    clocking master_cb @ (posedge clk);
        default input #1 output #1;
        output awvalid;
        output awaddr;
        output awprot;
        output wvalid;
        output wdata;
        output wstrb;
        output bready;
        output arvalid;
        output araddr;
        output arprot;
        output rready;
    endclocking : master_cb

    clocking slave_cb @ (posedge clk);
        default input #1 output #1;
        output awready;
        output wready;
        output bvalid;
        output bresp;
        output arready;
        output rvalid;
        output rdata;
        output rresp;
        output araddr;
    endclocking : slave_cb

    // Modports
    modport mst(clocking master_cb, input clk, arst_n, awready, wready, bvalid, bresp, arready, rvalid, rdata, rresp);
    modport slv(clocking slave_cb, input clk, arst_n, awvalid, awaddr, awprot, wvalid, wdata, wstrb, bready, arvalid, araddr, arprot, rready);

endinterface : axi4_lite_if