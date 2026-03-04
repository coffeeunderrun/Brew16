.SUFFIXES:

include vars.mk

OSNAME = brew16

BINDIR = $(CURDIR)/bin

.PHONY: all
all: img

.PHONY: clean
clean:
	$(MAKE) -Cboot clean
	$(MAKE) -Crtl clean
	$(MAKE) -Ckernel clean
	$(MAKE) -Capplications clean
	rm -rf $(BINDIR) *.img

.PHONY: run
run: $(OSNAME).img
	$(QEMU) $(QEMUFLAGS) -boot a -drive file="$<",format=raw,if=floppy

.PHONY: img
img: $(OSNAME).img

$(OSNAME).img: boot kernel applications
	dd if=/dev/zero of=$@ bs=512 count=2880 \
		&& mformat -i $@ -f 1440 -B $(BINDIR)/boot/bootsect.bin :: \
		&& mcopy -i $@ $(BINDIR)/kernel/* :: \
		&& mcopy -i $@ $(BINDIR)/applications/* ::

.PHONY: boot
boot:
	mkdir -p $(BINDIR)/boot
	$(MAKE) -Cboot BINDIR=$(BINDIR)/boot

.PHONY: kernel
kernel: kernel-rtl
	mkdir -p $(BINDIR)/kernel
	$(MAKE) -Ckernel BINDIR=$(BINDIR)/kernel

.PHONY: kernel-rtl
kernel-rtl:
	$(MAKE) -Crtl kernel

.PHONY: applications
applications: applications-rtl
	mkdir -p $(BINDIR)/applications
	$(MAKE) -Capplications BINDIR=$(BINDIR)/applications

.PHONY: applications-rtl
applications-rtl:
	$(MAKE) -Crtl applications
