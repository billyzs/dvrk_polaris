# dvrk_polaris
Using Polaris to Track the DVRK

## Quick Start
1. make sure the `3rdparty` and `src` folders are in Matlab's search path
2. run Puls Server with `data/PlusDeviceSet_Server_PolarisDefault.xml`. 
3. run `3rdparty/testReceiveTransforms.m` to verify that the OpenIGTLink server is working
4. open `src/testIGTL2ROS.m`, modify `this_pc` and `adnan_pc` to be the right IP address and run the script
5. run `rosnode list` on master PC to see if the Matlab node shows up
6. run `rostopic list` on master PC to see if the topic `/polaris` shows up