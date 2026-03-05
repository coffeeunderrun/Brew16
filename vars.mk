DEBUG = 1
USEGDB = 0

NASM = nasm
NASMFLAGS =

FPC = fpc
FPCFLAGS =
override FPCFLAGS += -Cn -Cg-i-o-r-t- -g- -Mobjfpc -n -Pi8086 -Sacg -Tembedded

CC = cc
CCFLAGS =
override CCFLAGS += -m16 -march=i8086 -nostdlib -Wl,-Map=memory.map -Wl,--gc-sections

QEMU = qemu-system-i386
QEMUFLAGS = -M q35 -m 16M -net none -serial mon:stdio

ifeq ($(DEBUG), 1)
    override NASMFLAGS += -O0
    override FPCFLAGS += -O- -Si-
    override QEMUFLAGS += -d int -no-shutdown -no-reboot
    override CCFLAGS += -O0
else
    override NASMFLAGS += -Ox
    override FPCFLAGS += -O2 -Si -dNDEBUG
    override CCFLAGS += -O2 -s --function-sections --data-sections
endif

ifeq ($(USEGDB), 1)
    override QEMUFLAGS += -s -S
else
    override QEMUFLAGS += -enable-kvm -cpu host
endif

%.o: %.s
# Remove GROUP DGROUP to avoid NASM errors.
# Move RTTI and INIT to their own sections to be discarded by the linker.
# These are not currently needed and I found no way to prevent FPC from generating them.
	@sed -i -E $< \
		-e '/GROUP[[:space:]]+DGROUP/Id' \
		-e '/GLOBAL[[:space:]]+RTTI_/i SECTION .rtti' \
		-e '/GLOBAL[[:space:]]+INIT_/i SECTION .init' \
        -e 's/CPU[[:space:]]+8086/CPU 386/ig'
	$(NASM) $(NASMFLAGS) -w-other -w-zeroing -felf32 -o$@ $<
