CC=gcc
AS=nasm
X=xxd
VM=qemu-system-x86_64
XSRC=src/xboot/main
KSRC=src/kernel/main
XDEPS=src/xboot/headers
KDEPS=src/kernel/headers
BUILD=build

$(BUILD)/coldOS.bin: $(BUILD)/xboot.bin $(BUILD)/kernel.bin
	cat $^ > $@
$(BUILD)/xboot.bin: $(XSRC)/xboot.asm $(BUILD)
	$(AS) -f bin -o $@ $< -i $(XDEPS)
$(BUILD)/kernel.bin: $(KSRC)/kernel.asm $(BUILD)
	$(AS) -f bin -o $@ $< -i $(KDEPS)
$(BUILD):
	if ! [ -d $@ ]; then			\
		mkdir $@;			\
	fi
run: $(BUILD)/coldOS.bin
	$(VM) -drive format=raw,file=$<
dump: $(BUILD)/coldOS.bin
	$(X) $<
clean:
	rm -rf $(BUILD)
	rm -f *.c
	rm -f *.o
	rm -f *.s
	rm -f *.asm
	rm -f *.bin
	rm -f vgcore.*
