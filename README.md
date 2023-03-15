# AXI4-Lite-VIP

## Description
***

This repository containts a VIP built to drive to AXI4 Lite DUTs. It can be used as a Master AXI4 Lite or a Slave AXI4 Lite, and all the channels are independent. This was possible using pipelined driver.

Obs: For now, only the Write channels were implemented. I will update the code as soon as I can with the Read channels.

## Possible configurations

In the Agent Config file there is some possible configurations that can be changed in order to use the VIP in different ways:

* is\_master: Configures the agent to be a Master or a Slave AXI4 Lite Agent;
* has\_monitor: Configures a monitor if the user wants to send the AXI4 Lite transactions to a scoreboard or a coverage component;
* max\_clks\_to_handshake: Configures a maximum number of clock periods that one channel can wait before cancelling the operation;
* \*\_always\_ready: Configures if the receiver of that channel will be always ready to receive data or not.

## Using the VIP

