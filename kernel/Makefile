.SUFFIXES:

include ../vars.mk

RTLDIR := ../rtl/kernel/bin

OBJS := $(RTLDIR)/system.o entry.o bin/kernel.o bin/fs.fat.o bin/video.o

.PHONY: all
all: $(BINDIR)/kernel.bin

.PHONY: clean
clean:
	rm -rf bin *.o *.map

$(BINDIR)/kernel.bin: linker.lds $(OBJS)
	$(CC) $(CCFLAGS) -T$< -o$@ $(OBJS)

bin/%.s: %.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -a -s -Anasm -FE$(dir $@) -Fu$(RTLDIR) $<
