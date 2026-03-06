.SUFFIXES:

include ../../vars.mk

.PHONY: all
all: kernel

.PHONY: clean
clean:
	rm -rf bin *.map

.PHONY: kernel
kernel: bin/system.a

bin/system.a: override FPCFLAGS += -Fiinc -Fii286 -Us -Sf-
bin/%.a: %.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -FE$(dir $@) -Fikernel $<

bin/%.o: %.s
	mkdir -p $(dir $@)
	$(NASM) $(NASMFLAGS) -fobj $< -o$@
