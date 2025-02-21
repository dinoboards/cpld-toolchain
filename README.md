
## ATF150x CPLD Toolchain

This repo contains a docker file that will build a tool chain for compiling PLD with Wincupl or verilog files with yosys for the ATF150x CPLD devices

To Build

`docker build .`



## Prerequisite for bilding Docker image

Before attempting to run `docker build .`, you need to prepare the Wincupl directory.

1. Grab the windows installed files of Wincupl and add as directory within this project
2. Grab the updated fitter for the ATF150x devices as described (https://github.com/peterzieba/5Vpld/blob/main/atmel-fitters/README.md)

## References
* https://github.com/peterzieba/5Vpld

