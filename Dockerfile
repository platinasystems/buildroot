FROM debian:9 AS platina-buildroot
LABEL maintainer="kph@platinasystems.com"

WORKDIR /root

# Install dependencies.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive\
    apt-get install -y build-essential libncurses5-dev rsync cpio python unzip bc wget git && \
    apt-get clean

# FIXME later in coreboot build: coreboot build dependencies
RUN apt-get clean && \
    DEBIAN_FRONTEND=noninteractive\
    apt-get install -y gcc g++ gnat-6 make patch python diffutils bison \
		flex git doxygen ccache subversion p7zip-full unrar-free \
		m4 wget curl bzip2 vim-common cmake xz-utils pkg-config \
		dh-autoreconf unifont \
		libssl1.0-dev libgmp-dev zlib1g-dev libpci-dev liblzma-dev \
		libyaml-dev libncurses5-dev uuid-dev libusb-dev libftdi-dev \
		libusb-1.0-0-dev libreadline-dev libglib2.0-dev libgmp-dev \
		libelf-dev libxml2-dev libfreetype6-dev && \
    apt-get clean

COPY . buildroot

RUN make -C buildroot O=../builds/example-amd64 example-amd64_defconfig && make -C builds/example-amd64 all

RUN make -C buildroot O=../builds/platina-mk1 platina-mk1_defconfig && make -C builds/platina-mk1 all

RUN make -C buildroot O=../builds/platina-mk1-bmc platina-mk1-bmc_defconfig && make -C builds/platina-mk1-bmc all
