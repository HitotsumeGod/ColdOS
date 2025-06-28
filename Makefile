CC=gcc
AS=nasm
X=xxd
VM=qemu-system-x86_64
XSRC=src/xboot/main
KSRC=src/kernel/main
XDEPS=src/xboot/headers
KDEPS=src/kernel/headers
BUILD=build
OPTS=-w-orphan-labels

$(BUILD)/coldOS.bin: $(BUILD)/xboot.bin $(BUILD)/kernel.bin
	cat $^ > $@
$(BUILD)/xboot.bin: $(XSRC)/stage1.asm $(XSRC)/stage2.asm $(BUILD)
	$(AS) -f bin -o $(BUILD)/stage1.bin $(XSRC)/stage1.asm -i $(XDEPS) $(OPTS)
	$(AS) -f bin -o $(BUILD)/stage2.bin $(XSRC)/stage2.asm -i $(XDEPS) $(OPTS)
	cat $(BUILD)/stage1.bin $(BUILD)/stage2.bin > $@
$(BUILD)/kernel.bin: $(KSRC)/kernel.asm $(BUILD)
	$(AS) -f bin -o $@ $< -i $(KDEPS) $(OPTS)
$(BUILD):
	if ! [ -d $@ ]; then			\
		mkdir $@;			\
	fi
run: $(BUILD)/coldOS.bin
	$(VM) -drive format=raw,file=$< -d int,cpu_reset -no-reboot
dump: $(BUILD)/coldOS.bin
	$(X) $<
bdump: $(BUILD)/coldOS.bin
	$(X) -b $< 
clean:
	rm -rf $(BUILD)
	rm -f *.c
	rm -f *.o
	rm -f *.s
	rm -f *.asm
	rm -f vgcore.*
