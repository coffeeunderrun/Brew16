.SUFFIXES:

include ../../vars.mk

RTLBIN := ../../rtl/applications/bin

LIBS := $(RTLBIN)/system.a
LIBS += bin/shell.a
OBJS := $(RTLBIN)/prt0.o

.PHONY: all
all: $(BINDIR)/shell.bin

.PHONY: clean
clean:
	rm -rf bin *.map

$(BINDIR)/%.bin: %.lnk $(OBJS) $(LIBS)
	$(WLINK) $(WLINKFLAGS) @$< file { $(OBJS) } library { $(LIBS) } name $@

bin/%.a: %.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -FE$(dir $@) -Fu$(RTLBIN) $<
