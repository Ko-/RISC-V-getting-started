#include <stdio.h>

// This exports the getcycles function.
#include "utils.h"

static void do_something()
{
    for (int i = 0; i < 1000; ++i) {
        __asm__("NOP");
    }
}

int main(void)
{
    // Instruction cache misses are relatively expensive, so for more
    // consistent benchmarks that depend less on the relative speed of
    // the QSPI flash, you might want to fill the instruction cache first.
    // Note that it can hold 16 KiB of instructions on the HiFive1.
    do_something();
    getcycles();
    uint64_t oldcount = getcycles();
    do_something();
    uint64_t newcount = getcycles();

    printf("That took %d cycles.\n", (unsigned int)(newcount-oldcount));

    return 0;
}
