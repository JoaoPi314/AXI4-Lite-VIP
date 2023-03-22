/********************************************** /
AXI4-Lite VIP

file: top.tb
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: A simple testbench to check the VIP
functionality
************************************************/

module top;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_lite_pkg::*;

  logic clk;
  logic shade_clk;
  logic arst_n;
    
  // If driving into a DUT, connect the wrapper_if instead of the a4_lite_int
  axi4_lite_wrapper_if wrapper_if(.clk(clk), .arst_n(arst_n));
  axi4_lite_wrapper_for_slave wrapper_slv(.output_if(wrapper_if), .cb_if(a4_lite_in));
  
  axi4_lite_if a4_lite_in(.clk(clk), .arst_n(arst_n));

  // axiDUT dut(
  //   .DUT_ACLK(clk),
  //   .DUT_ARSTN(arst_n),
    
  //   .DUT_AWADDR(wrapper_if.awaddr),
  //   .DUT_AWPROT(wrapper_if.awprot),
  //   .DUT_AWVALID(wrapper_if.awvalid),
  //   .DUT_AWREADY(wrapper_if.awready),

  //   .DUT_WDATA(wrapper_if.wdata),
  //   .DUT_WSTRB(wrapper_if.wstrb),
  //   .DUT_WVALID(wrapper_if.wvalid),
  //   .DUT_WREADY(wrapper_if.wready),

  //   .DUT_BRESP(wrapper_if.bresp),
  //   .DUT_BVALID(wrapper_if.bvalid),
  //   .DUT_BREADY(wrapper_if.bready),

  //   .DUT_ARADDR(wrapper_if.araddr),
  //   .DUT_ARPROT(wrapper_if.arprot),
  //   .DUT_ARVALID(wrapper_if.arvalid),
  //   .DUT_ARREADY(wrapper_if.arready),

  //   .DUT_RDATA(wrapper_if.rdata),
  //   .DUT_RRESP(wrapper_if.rresp),
  //   .DUT_RVALID(wrapper_if.rvalid),
  //   .DUT_RREADY(wrapper_if.rready)
  // );

  initial begin
      clk = 1;
      shade_clk = 1;
      arst_n = 1;
      @(posedge clk);
      arst_n = 0;
      repeat(5) @(posedge clk);
      arst_n = 1;
  end
      
  initial begin
      uvm_config_db#(virtual interface axi4_lite_if.mst)::set(uvm_root::get(), "*", "mst_vif", a4_lite_in);
      uvm_config_db#(virtual interface axi4_lite_if.slv)::set(uvm_root::get(), "*", "slv_vif", a4_lite_in);

      $dumpfile("dump.vcd"); 
      $dumpvars;
  end
  
  initial begin
    run_test("axi4_lite_base_test");
  end

  always begin
    #10ns clk = ~clk;
  end

  always begin
      @(posedge clk, negedge clk);
      #1ns shade_clk = ~shade_clk;
  end
  
endmodule : top