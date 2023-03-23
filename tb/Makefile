sim: 
	xrun -64 -timescale 1ns/1ns -sysv -uvm -incdir ../sv/ ../sv/axi4_lite_if.sv ../sv/axi4_lite_wrapper_if.sv ../sv/axi4_lite_wrapper_for_slave.sv ../sv/axi4_lite_pkg.sv top.sv +access+rwc  +UVM_VERBOSITY=UVM_MEDIUM  -svseed random +UVM_TESTNAME=axi4_lite_vip_test -gui
clean:
	@rm -rf .simvision *.shm *.d *.dump xrun* *.diag *.vcd