This folder contains the build files for the riscv-tests that were obtained from: https://github.com/regymm/quasiSoC
Thank you so much! It was a lot easier using this code. There are some modifications I made to the addresses and also I left out some tests that were not applicable to
this CPU.

The linked repository contains the code to build the riscv-tests that were originally from: https://github.com/riscv-software-src/riscv-tests

To build, just run:

1. "make"
2. To obtain the hex dump, use the command (inside the firmware folder): "od -An -t x4 -w4 -v --endian=little firmware.bin > firmware_hex.dump"

The hex file contains the data region starting at the top and is up until the first "00000093". Afterwards, the rest is the code region (instruction memory).
So, if the CPU is based on separate instruction and data memories, make sure to split it accordingly.