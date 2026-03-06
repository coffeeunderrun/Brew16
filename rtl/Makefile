.SUFFIXES:

include ../vars.mk

.PHONY: all
all: kernel applications

.PHONY: clean
clean:
	rm -rf kernel/bin kernel/*.map
	rm -rf applications/bin applications/*.map

.PHONY: kernel
kernel: kernel/bin/system.a kernel/bin/prt0.o

.PHONY: applications
applications: applications/bin/system.a applications/bin/prt0.o

kernel/bin/system.a: override FPCFLAGS += -Fiinc -Fii8086 -Us -Sf- -SfCLASSES -SfRTTI -SfHEAP -SfEXCEPTIONS -SfTEXTIO -SfFILEIO
kernel/bin/%.a: kernel/%.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -FE$(dir $@) -Fikernel $<

applications/bin/system.a: override FPCFLAGS += -Fiinc -Fii8086 -Us -Sf- -SfCLASSES -SfRTTI -SfHEAP -SfEXCEPTIONS -SfTEXTIO -SfFILEIO
applications/bin/%.a: applications/%.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -FE$(dir $@) -Fiapplications $<

kernel/bin/%.o: kernel/%.s
	$(NASM) $(NASMFLAGS) -fobj $< -o$@

applications/bin/%.o: applications/%.s
	$(NASM) $(NASMFLAGS) -fobj $< -o$@
