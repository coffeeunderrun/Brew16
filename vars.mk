NASM = nasm
NASMFLAGS = -Ox

FPC = fpc
FPCFLAGS = -O3
override FPCFLAGS += -CnX -Cp80286 -Cg-i-o-r-t- -n -Pi8086 -Scgi -Tembedded -Wmsmall -XdsX

WLINK = wlink
WLINKFLAGS =

QEMU = qemu-system-i386
QEMUFLAGS = -M q35 -m 16M -net none -serial mon:stdio -enable-kvm -cpu host -d int -no-shutdown -no-reboot
