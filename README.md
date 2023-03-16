# AXI4-Lite-VIP

## Description
***

This repository containts a VIP built to drive to AXI4 Lite DUTs. It can be used as a Master AXI4 Lite or a Slave AXI4 Lite, and all the channels are independent. This was possible using pipelined driver.

Obs: For now, only the Write channels were implemented. I will update the code as soon as I can with the Read channels.

## Possible configurations

In the Agent Config file there is some possible configurations that can be changed in order to use the VIP in different ways:
* `is_master`: Configures the agent to be a Master or a Slave AXI4 Lite Agent;
* `has_monitor`: Configures a monitor if the user wants to send the AXI4 Lite transactions to a scoreboard or a coverage component;
* `max_clks_to_handshake`: Configures a maximum number of clock periods that one channel can wait before cancelling the operation;
* `*_always_ready`: Configures if the receiver of that channel will be always ready to receive data or not.


## Using the VIP

There is a Test example where I perform valid write operations (Obeying the Protocol). The logic to drive correctly is responsability of the owner. At the end of each channel handshake, the driver sends back to the sequence a response, and this response can be used to control the correct time to drive to other channels. I think that the only thing you need to know before using this VIP is how the transactions were built.

### Transactions

Each transaction will have the data of one of the five AXI4 Lite channels. So, in order to perform a Write operation, the user must send one `WR_ADDR` transaction, one `WR_DATA` transaction and if he wants to get the response, one `WR_RESP` transaction. The channel can be selected by constraining the `active_channel` value, and all possible values of this `enum` are listed in `axi4_lite_pkg`.

According with the protocol, the handshake can occurs with VALID being sent before or at the same time of READY being asserted by the other AXI4 Lite device. So, there is one field in transactions that controls if the VIP will wait (`WAIT_TO_SEND`) or send (`SEND_FIRST`) to assert it handshake control signal. Note that in case of Master VIP, this field doesn't matter to `WR_DATA` and `WR_ADDR` channels, once the protocol says that these channels must no wait the Slave assert the READY before assert the VALID. In the Slave VIP, the channel that cannot wait is the `WR_RESP`.

### Waveforms

These waveforms are the result of the `axi4_lite_write_test`. The waveforms were generated with Simvision.

## Future updates

This is the first version of the VIP, and it has only the Write channels implemented. The next steps are:

* Implement Read channels
* Implement a monitor if the user desires to have one (But I think that it's better the user implement a passive Agent to monitor the interface as he wants)

## References

* [Documentation – arm developer](https://developer.arm.com/documentation/ihi0022/e/AMBA-AXI4-Lite-Interface-Specification)
* [UVM Driver Use Models – Part 2](https://learnuvmverification.com/index.php/2015/10/28/uvm-driver-use-models-part-2/)

