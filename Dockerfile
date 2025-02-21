# Requires Wincupl files to at ./Wincupl
#
# before running docker build, prepare the  Wincupl files and the updated fitters exes
#
# docker build  --progress plain -t dinoboards/atf15:0.0.6 .
#
# from within the ez80-for-rc/hardware directory
# docker run -v ${PWD}:/work -e CHOWN=$(id -u ${USER}):$(id -g ${USER}) -it dinoboards/wincupl:0.0.6 sample
#
#  docker run -v ./hardware/:/ez80-for-rc/hardware/ --privileged=true -it dinoboards/wincupl:0.0.5 run_yosys sample
#  docker run -v ./hardware/:/ez80-for-rc/hardware/ --privileged=true -it dinoboards/wincupl:0.0.5 run_fitter sample

# to program:
# atfu program Y:\home\dean\dinoboards\ez80-for-rc\hardware\bin\sample.jed

FROM ubuntu:jammy-20240911.1
LABEL Maintainer="Dean Netherton" \
      Description="Tool chain to compile JED files from PLD using Wincupl"

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu/http:\/\/mirror.internet.asn.au\/pub\/ubuntu\/archive/g'  /etc/apt/sources.list

RUN apt update && \
    apt dist-upgrade -y && \
    apt install -y \
    build-essential \
    curl \
    git \
    python3 \
    software-properties-common \
    wget \
    gpg

RUN dpkg --add-architecture i386
RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
RUN apt update
RUN apt install -y --install-recommends winehq-stable

COPY --link Wincupl /Wincupl

RUN git config --global --add safe.directory /src && git config --global --add safe.directory ./

RUN mkdir /opt/oss-cad-suite
WORKDIR /opt

ADD https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2025-01-31/oss-cad-suite-linux-x64-20250131.tgz /opt/oss-cad-suite-linux-x64-20250131.tgz
RUN tar xf oss-cad-suite-linux-x64-20250131.tgz
RUN rm -f oss-cad-suite-linux-x64-20250131.tgz
ENV PATH=/opt/oss-cad-suite/bin:$PATH

RUN mkdir /opt/atf15xx_yosys
WORKDIR /opt/atf15xx_yosys

RUN git clone --depth 1 https://github.com/hoglet67/atf15xx_yosys.git /opt/atf15xx_yosys/

COPY Wincupl/WinCupl/Fitters/aprim.lib  /opt/atf15xx_yosys/vendor/
COPY Wincupl/WinCupl/Fitters/atmel.std  /opt/atf15xx_yosys/vendor/
COPY Wincupl/WinCupl/Fitters/fit1502.exe  /opt/atf15xx_yosys/vendor/
COPY Wincupl/WinCupl/Fitters/fit1504.exe  /opt/atf15xx_yosys/vendor/
COPY Wincupl/WinCupl/Fitters/fit1508.exe  /opt/atf15xx_yosys/vendor/
COPY atf15xx_yosys/run_fitter /opt/atf15xx_yosys/run_fitter
COPY atf15xx_yosys/run_yosys /opt/atf15xx_yosys/run_yosys
COPY cupld /opt/wincupl/cupld
COPY 5vcomp /opt/wincupl/5vcomp

ENV PATH=/opt/wincupl/:opt/atf15xx_yosys:/opt/atf15xx_yosys/vendor/:$PATH

ENV XDG_RUNTIME_DIR="/root"

ENV WINEPATH="z:\\Wincupl\\WINCUPL\\EXE\\;z:\\Wincupl\\Shared\\;z:\\WinCupl\\WINCUPL\\FITTERS\\"
ENV FITTERDIR="z:\\WinCupl\\WINCUPL\\FITTERS"
ENV WINEDEBUG="-all"
ENV WINCUPLPATH="z:\\Wincupl\\Shared\\"

ENV WINEARCH=win32
ENV WINEPREFIX=/root/.wine
RUN wine wineboot

WORKDIR /work

