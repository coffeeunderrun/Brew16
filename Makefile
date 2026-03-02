.SUFFIXES:

include vars.mk

OSNAME = brew16

.PHONY: all
all: img

.PHONY: clean
clean:
	rm -rf *.bin *.img kernel/bin kernel/*.o

.PHONY: run
run: $(OSNAME).img
	$(QEMU) $(QEMUFLAGS) -boot a -drive file="$<",format=raw,if=floppy

.PHONY: img
img: $(OSNAME).img

$(OSNAME).img: stage1.bin kernel.bin
	dd if=/dev/zero of=$@ bs=512 count=2880 \
		&& mformat -i $@ -f 1440 -B stage1.bin :: \
		&& mcopy -i $@ kernel.bin ::

stage1.bin: boot/stage1.s
	$(NASM) $(NASMFLAGS) -fbin -o $@ $<

kernel.bin: kernel/linker.lds kernel/entry.o kernel/bin/system.o kernel/bin/kernel.o
	$(CC) $(CCFLAGS) -Tkernel/linker.lds -o$@ $(filter-out $<, $^)

%.o: %.s
# Remove GROUP DGROUP to avoid NASM errors.
# Move RTTI and INIT to their own sections to be discarded by the linker.
# These are not currently needed and I found no way to prevent FPC from generating them.
	sed -i -E $< \
		-e '/GROUP[[:space:]]+DGROUP/Id' \
		-e '/GLOBAL[[:space:]]+RTTI_/i SECTION .rtti' \
		-e '/GLOBAL[[:space:]]+INIT_/i SECTION .init'
	$(NASM) $(NASMFLAGS) -w-other -w-zeroing -felf32 -o $@ $<

kernel/bin/kernel.s: kernel/kernel.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -a -Anasm -FEkernel/bin -Fukernel/bin $<

kernel/bin/system.s: kernel/system.pas
	mkdir -p $(dir $@)
	$(FPC) $(FPCFLAGS) -a -Anasm -FEkernel/bin -Us -Sf- $<
