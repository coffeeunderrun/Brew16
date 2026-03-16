.SUFFIXES:

include ../../vars.mk

.PHONY: all
all: kernel

.PHONY: clean
clean:
	rm -rf bin *.map

.PHONY: kernel
kernel: bin/system.a

bin/system.a: override FPCFLAGS += -Fi../inc -Fi../i8086 -Us -Sf- \
	-SfTEXTIO -SfFILEIO -SfHEAP	-SfOBJECTS -SfEXCEPTIONS -SfCLASSES -SfRTTI
bin/%.a: %.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -FE$(dir $@) $<

bin/%.o: %.s
	mkdir -p $(dir $@)
	$(NASM) $(NASMFLAGS) -fobj $< -o$@
