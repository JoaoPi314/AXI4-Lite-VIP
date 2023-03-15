
module top;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_lite_pkg::*;

  logic clk;
  logic arst_n;
    
  axi4_lite_if a4_lite_in(.clk(clk), .arst_n(arst_n));
    
  initial begin
      clk = 1;
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
  
endmodule : top