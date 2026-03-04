.SUFFIXES:

include ../../vars.mk

RTLDIR := ../../rtl/applications/bin

OBJS := $(RTLDIR)/system.o entry.o bin/shell.o

.PHONY: all
all: $(BINDIR)/shell.bin

.PHONY: clean
clean:
	rm -rf bin *.o *.map

$(BINDIR)/shell.bin: linker.lds $(OBJS)
	$(CC) $(CCFLAGS) -T$< -o$@ $(OBJS)

bin/shell.s: shell.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -a -s -Anasm -FE$(dir $@) -Fu$(RTLDIR) $<
