DEBUG = 1
USEGDB = 0

NASM = nasm
NASMFLAGS =

FPC = fpc
FPCFLAGS =
override FPCFLAGS += -Cn -Cg-i-o-r-t- -g- -n -Pi8086 -Sacg -Tembedded

CC = cc
CCFLAGS =
override CCFLAGS += -m16 -march=i8086 -nostdlib -Wl,-Map=memory.map

QEMU = qemu-system-i386
QEMUFLAGS = -M q35 -m 16M -net none -serial mon:stdio

ifeq ($(DEBUG), 1)
  override NASMFLAGS += -O0
  override FPCFLAGS += -O- -Si-
  override QEMUFLAGS += -d int -no-shutdown -no-reboot
else
  override NASMFLAGS += -Ox
  override FPCFLAGS += -O2 -Si -dNDEBUG
  override CCFLAGS += -s --function-sections --data-sections
endif

ifeq ($(USEGDB), 1)
  override QEMUFLAGS += -s -S
else
  override QEMUFLAGS += -enable-kvm -cpu host
endif
