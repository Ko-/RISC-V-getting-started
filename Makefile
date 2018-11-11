TARGETS       := asmwrapper.elf cyclecount.elf

.PHONY: all
all: $(TARGETS)

include config.mk
include sdk/libwrap/libwrap.mk

# common files
COMM_ASM_SRCS := sdk/entry.S sdk/start.S
COMM_C_SRCS   := sdk/init.c
COMM_OBJS     := $(COMM_ASM_SRCS:.S=.o) $(COMM_C_SRCS:.c=.o)

# asmwrapper.elf
ASMW_ASM_SRCS := asmfunction.S
ASMW_C_SRCS   := asmwrapper.c
ASMW_OBJS     := $(COMM_OBJS) $(ASMW_ASM_SRCS:.S=.o) $(ASMW_C_SRCS:.c=.o)

# cyclecount.elf
CYCC_ASM_SRCS := utils/getcycles.S
CYCC_C_SRCS   := cyclecount.c
CYCC_OBJS     := $(COMM_OBJS) $(CYCC_ASM_SRCS:.S=.o) $(CYCC_C_SRCS:.c=.o)

ALL_ASM_OBJS  := $(COMM_ASM_SRCS:.S=.o) $(ASMW_ASM_SRCS:.S=.o) $(CYCC_ASM_SRCS:.S=.o)
ALL_C_OBJS    := $(COMM_C_SRCS:.c=.o) $(ASMW_C_SRCS:.c=.o) $(CYCC_C_SRCS:.c=.o)
ALL_OBJS      := $(ALL_ASM_OBJS) $(ALL_C_OBJS)

LDSCRIPT      := sdk/flash.lds
INCLUDES      := -Isdk/include -Iutils
ARCH_FLAGS    := -march=rv32imac -mabi=ilp32 -mcmodel=medany
CFLAGS        += -O3 -fno-builtin-printf \
				-Wall -Wextra -Wredundant-decls \
				-Wundef -Wshadow \
				-fno-common $(ARCH_FLAGS)
LDFLAGS       += -static -T$(LDSCRIPT) -nostartfiles \
				-Lsdk --specs=nano.specs -Wl,--gc-sections

asmwrapper.elf: $(ASMW_OBJS) $(LDSCRIPT) $(LIBWRAP)
	$(CC) $(CFLAGS) $(INCLUDES) $(ASMW_OBJS) -o $@ $(LDFLAGS)

cyclecount.elf: $(CYCC_OBJS) $(LDSCRIPT) $(LIBWRAP)
	$(CC) $(CFLAGS) $(INCLUDES) $(CYCC_OBJS) -o $@ $(LDFLAGS)

$(ALL_ASM_OBJS): %.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

$(ALL_C_OBJS): %.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -include sys/cdefs.h -c -o $@ $<

.PHONY: clean
clean:
	-rm -f $(LIBWRAP_OBJS) $(LIBWRAP) $(ALL_OBJS) $(TARGETS)
