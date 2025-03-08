
## CPLD Toolchain

This repo contains a docker file that will build a tool chain for compiling PLD files with Wincupl or verilog files with yosys for the ATF150x CPLD devices, and PLD devices

To use the pre-built published file, run this at your terminal:

```
docker run -v ${PWD}:/work -e CHOWN=$(id -u ${USER}):$(id -g ${USER}) -it dinoboards/cpld-toolchain:latest cupld sample
```

To make this easier, create an alias (update your .bashrc or equivalent file) with:

```
alias cupld='docker run -v ${PWD}:/work -e CHOWN=$(id -u ${USER}):$(id -g ${USER}) -it cpld-toolchain cupld'
```

thereafter you can then:

```
cupld sample
```

# Building the docker image

### Prerequisite for building Docker image

Before attempting to run `docker build .`, you need to prepare the Wincupl directory.

1. Grab the windows installed files of Wincupl and add as directory within this project
2. Grab the updated fitter for the ATF150x devices as described (https://github.com/peterzieba/5Vpld/blob/main/atmel-fitters/README.md)

### Docker Build

To Build Docker image

```
docker build  --progress plain -t cpld-toolchain .
```

Thereafter to run:

```
docker run -v ${PWD}:/work -e CHOWN=$(id -u ${USER}):$(id -g ${USER}) -it cpld-toolchain cupld <your pld file>
```

you can also create an alias to make this easier:

```
alias cupld='docker run -v ${PWD}:/work -e CHOWN=$(id -u ${USER}):$(id -g ${USER}) -it cpld-toolchain cupld'
```

Once an alias is created you can this do something like:

```
cupld sample
```


## References
* https://github.com/peterzieba/5Vpld

