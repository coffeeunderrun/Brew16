.SUFFIXES:

include ../vars.mk

.PHONY: all
all: $(BINDIR)/bootsect.bin

.PHONY: clean
clean:

$(BINDIR)/%.bin: %.s
	$(NASM) $(NASMFLAGS) -fbin -o$@ $<
