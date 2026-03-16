.SUFFIXES:

include ../vars.mk

RTLBIN := ../rtl/kernel/bin

LIBS := $(RTLBIN)/system.a
LIBS += bin/kernel.a bin/interrupts.a bin/device/pic.a
OBJS := bin/entry.o bin/cpu/gdt.o

.PHONY: all
all: $(BINDIR)/kernel.bin

.PHONY: clean
clean:
	rm -rf bin *.map

$(BINDIR)/%.bin: %.lnk $(OBJS) $(LIBS)
	$(WLINK) $(WLINKFLAGS) @$< file { $(OBJS) } library { $(LIBS) } name $@

bin/%.a: %.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -FE$(dir $@) -Fu$(RTLBIN) -Fudevice $<

bin/%.o: %.s
	mkdir -p $(dir $@)
	$(NASM) $(NASMFLAGS) -fobj $< -o$@
