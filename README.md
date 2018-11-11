## RISC-V: getting started

This repository contains short proof-of-concepts for SiFive HiFive1 boards. The goal of this repository is to make it easier to quickly port some existing code to HiFive1 boards without having to learn how to set it up. Even the initial 'Hello world' can form an obstacle on a bare-metal device. This repository is especially targeted at code that just runs a computation that needs to be benchmarked and/or briefly communicates with a host, and that barely uses any of the peripherals that the HiFive1 board provides.

### Installing dependencies

This code assumes you have the [RISC-V GNU toolchain](https://github.com/riscv/riscv-gnu-toolchain) installed and accessible. Unfortunately, it is unlikely that your Linux distribution comes with a suitable package for this, so you might have to compile the toolchain from source. For example, the `riscv64-linux-gnu-*` packages on Arch Linux don't enable multilib support for the `RV32I` architecture and can therefore not be used. Of the toolchain, we are going to need the [riscv-gcc](https://github.com/riscv/riscv-gcc), [riscv-gdb](https://github.com/riscv/riscv-binutils-gdb), and [riscv-newlib](https://github.com/riscv/riscv-newlib) parts, but it might be easiest to use the [repository for the whole toolchain](https://github.com/riscv/riscv-gnu-toolchain).

If you are compiling the toolchain from source and if your Linux distribution uses Python 3 as the default Python version, you might need to apply the `gdb.patch` that is included here to be able to compile `gdb`. Otherwise this can be skipped.
```
$ patch -d <your riscv-gdb dir> -p1 --backup-if-mismatch < gdb.patch
```

Before compilation, make sure to pass (at least) the following options to the `configure` script. Note that compilation will take a while.
```
$ ./configure --enable-multilib --with-cmodel=medany --with-libgcc-cmodel --with-arch=rv32imac --with-abi=ilp32 --prefix=<your install dir>
$ make -j newlib
```

Next, we need [OpenOCD with RISC-V support](https://github.com/riscv/riscv-openocd) installed. This is used for flashing binaries to the board. There exists an [AUR package](https://aur.archlinux.org/packages/riscv-openocd/) for Arch users, but we are not aware of other packages.

Once the tools are installed, edit `config.mk` such that the variables point to the right binaries. If the tools can not be found in your `$PATH`, enter the full path in `config.mk`.

Finally, we use `screen` for connecting to the serial device. If that is not installed already, get it from your package manager.

### Hooking up a HiFive1 board

Connect the board to your machine using the micro-USB port. This provides it with power, and allows you to flash binaries onto the board. It should create two devices: `/dev/ttyUSB0` and `/dev/ttyUSB1`.

### Normal workflow

This repository contains two example programs. Executing `make` cross-compiles them for RISC-V and produces two `*.elf` files.

With the board connected to your machine, execute `./watch.sh` in one terminal to see whatever gets printed to stdout/stderr on the board. This is `screen`, so you can exit with `Ctrl+a`,`\`. Or detach temporarily and re-attach with `Ctrl+a`,`d` followed by `screen -r`.

In another terminal, execute `./upload.sh cyclecount.elf` to flash that binary to the board. It will execute immediately, so you should be able to see the output in the first terminal.

### Troubleshooting

At some point the boards or the software might behave differently than one would expect. Here we try to collect the most common errors that people run into. Please create an issue if this guide did not immediately work for you. This helps to expand and improve this section.

If you are running into permission errors when trying to access the serial devices as a non-root user when executing `./watch.sh`, you could consider adding your current user to the `dialout` (Debian, Ubuntu) or `uucp` (Arch) group, using something along the lines of `sudo usermod -a -G [group] [username]`.

### Acknowledgements

This repository is heavily inspired by the [STM32-getting-started](https://github.com/joostrijneveld/STM32-getting-started/) repository. It also uses parts of the [Freedom E SDK](https://github.com/sifive/freedom-e-sdk/), but we aimed to exclude any unnecessary parts and to simplify the build process. Everything in the `sdk` directory falls under their Apache 2.0 license, included in that directory. Everything else in this repository falls under the CC0 license.
