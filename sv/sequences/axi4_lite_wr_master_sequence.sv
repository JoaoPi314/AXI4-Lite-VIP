/********************************************** /
AXI4-Lite VIP

file: axi4_lite_wr_master_sequence.sv
author: João Pedro Melquiades Gomes
mail: jmelquiadesgomes@gmail.com

Description: Sequence to perform a write operation
via AXI4 Lite
************************************************/
class axi4_lite_wr_master_sequence extends axi4_lite_base_sequence;
    `uvm_object_utils(axi4_lite_wr_master_sequence)

    // Control variables
    bit unlock_next_write = 1'b1;
    int num_of_transactions = 100;

    function new(string name = "axi4_lite_wr_master_sequence");
        super.new(name);
    endfunction: new
    
    /*
     * Function: response_handler
     * Description: When using use_response_handler(1), this function will 
     * be called every time the driver sends a response back to the sequence.
     * Here, it is used to keep the sequences sending packets in order to per-
     * form valid write operations.
     */
    extern virtual function void response_handler(uvm_sequence_item response);
    
    // Task: body
    extern task body();

endclass: axi4_lite_wr_master_sequence

function void axi4_lite_wr_master_sequence::response_handler(uvm_sequence_item response);

    axi4_lite_packet rsp;
    channels_t current_channel;

    assert($cast(rsp, response))
    else `uvm_error(get_type_name(), "Response isn't a axi4_lite packet")
    
    current_channel = rsp.active_channel;
    `uvm_info(get_type_name(), $sformatf("Got Response from Driver - %s channel", current_channel.name()), UVM_HIGH)

    if(current_channel == WR_RESP)
        unlock_next_write = 1'b1;

endfunction : response_handler

task axi4_lite_wr_master_sequence::body();
    use_response_handler(1);

    repeat(num_of_transactions) begin
        wait(unlock_next_write === 1'b1);
        fork
            unlock_next_write = 1'b0;
            begin
                fork
                    `uvm_do_with(req, {req.active_channel == WR_ADDR; req.handshake_type == SEND_FIRST;})
                    `uvm_do_with(req, {req.active_channel == WR_DATA; req.handshake_type == SEND_FIRST;})
                join
            end
            begin
                `uvm_do_with(req, {req.active_channel == WR_RESP;})
            end
        join  
    end
endtask : body


