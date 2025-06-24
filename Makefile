CC=i686-elf-gcc
AS=nasm
ISO=grub-mkrescue
VM=qemu-system-i386
SRC=src/main
DEPS=src/headers
BUILD=build
ISODIR=isodir
MNT=mnt

$(BUILD)/coldOS.iso: $(BUILD)/coldOS.bin $(BUILD)/grub.cfg $(ISODIR)
	cp $< $(ISODIR)/boot
	cp $(BUILD)/grub.cfg $(ISODIR)/boot/grub
	$(ISO) -o $@ $(ISODIR)
$(BUILD)/coldOS.bin: $(SRC)/linker.ld $(BUILD)/boot.o $(BUILD)/kernel.o
	$(CC) -T $< -o $@ -ffreestanding -O2 -nostdlib $(BUILD)/boot.o $(BUILD)/kernel.o -lgcc
$(BUILD)/boot.o: $(SRC)/boot.asm $(BUILD)
	$(AS) -f elf32 $< -o $@
$(BUILD)/kernel.o: $(SRC)/kernel.c $(BUILD)
	$(CC) -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra
$(BUILD)/grub.cfg: $(BUILD)
	printf "menuentry \"coldOS\" {\n\tmultiboot /boot/coldOS.bin\n}" > $@
$(BUILD):
	if ! [ -d $@ ]; then			\
		mkdir $@;			\
	fi
$(MNT):
	if ! [ -d $@ ]; then			\
		mkdir $@;			\
	fi
$(ISODIR):
	if ! [ -d $@ ]; then			\
		mkdir -pv $@/boot/grub;		\
	fi
run: $(BUILD)/coldOS.iso
	$(VM) $<
mount: $(BUILD)/coldOS.iso $(MNT)
	sudo mount $< $(MNT)
clean:
	- sudo umount $(MNT)
	rm -rf $(BUILD)
	rm -rf $(ISODIR)
	rm -rf $(MNT)
	rm -f *.c
	rm -f *.o
	rm -f *.s
	rm -f *.asm
	rm -f *.bin
	rm -f vgcore.*
