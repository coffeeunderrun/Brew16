.SUFFIXES:

include ../vars.mk

RTLBIN := ../rtl/kernel/bin

LIBS := $(RTLBIN)/system.a
LIBS += bin/kernel.a bin/video.a bin/fs.fat.a
OBJS := $(RTLBIN)/prt0.o

.PHONY: all
all: $(BINDIR)/kernel.bin

.PHONY: clean
clean:
	rm -rf bin *.map

$(BINDIR)/%.bin: %.lnk $(OBJS) $(LIBS)
	$(WLINK) $(WLINKFLAGS) @$< file { $(OBJS) } library { $(LIBS) } name $@

bin/%.a: %.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -FE$(dir $@) -Fu$(RTLBIN) $<
