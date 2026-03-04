.SUFFIXES:

include ../vars.mk

.PHONY: all
all: kernel applications

.PHONY: clean
clean:
	rm -rf kernel/bin applications/bin

.PHONY: kernel
kernel: kernel/bin/system.o kernel/bin/objpas.o

.PHONY: applications
applications: applications/bin/system.o applications/bin/objpas.o

%/bin/system.s: %/system.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -a -s -Anasm -FE$(dir $@) -Us -Sf- $<

%/bin/objpas.s: objpas/objpas.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -a -s -Anasm -FE$(dir $@) -Fu$(dir $@) $<
