; real mode bootloader for the intel x86-64 platform

bits 16
org 0x7C00

gdt:
	gdt_null:
		dq 0
	gdt_code:
		dw 0xFFFF
		dw 0
		db 0
		db 10011010b
		db 11001111b
		db 0
	gdt_data:
		dw 0xFFFF
		dw 0
		db 0
		db 10010010b
		db 11001111b
		db 0
gdt_end
gdt_desc:
	db gdt_end - gdt
	dw gdt
print_start:
	; print welcome message using UEFI/BIOS
	mov	ah, 0x0E
	mov	al, 0x57
	int	0x10
	mov	al, 0x65
	int	0x10
	mov	al, 0x6C
	int	0x10
	mov	al, 0x63
	int	0x10
	mov	al, 0x6F
	int	0x10
	mov	al, 0x6D
	int	0x10
	mov	al, 0x65
	int	0x10
	mov	al, 0x20
	int	0x10
	mov	al, 0x74
	int	0x10
	mov	al, 0x6F
	int	0x10
	mov	al, 0x20
	int	0x10
	mov	al, 0x58
	int	0x10
	mov	al, 0x42
	int	0x10
	mov	al, 0x4F
	int	0x10
	int	0x10
	mov	al, 0x54
	int	0x10
	mov	al, 0x21
	int	0x10
load_kern:
	; load first sector (512 bytes) of kernel into memory at 0x1000
	mov	ah, 0x02
	mov	al, 1
	mov	ch, 0
	mov	cl, 2
	mov	dh, 0
	mov	dl, 0x80
	mov	bx, 0x1000
	mov	es, bx
	xor	bx, bx
	int	0x13
	jc	load_kern
	call	print_boot
	; switch to 32-bit protected mode
	cli
	lgdt	[gdt_desc]
	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax
	jmp	0x08:boot_kern
boot_kern:
bits 32
	mov	ax, 0x08
	mov	ds, ax
	mov	ss, ax
	mov	esp, 0x090000
	; hand control to the kernel
	jmp	0x1000:0x0000
print_boot:
	mov	ah, 0x0E
	mov	al, 0x20
	int	0x10
	mov	al, 0x42
	int	0x10
	mov	al, 0x6F
	int	0x10
	int	0x10
	mov	al, 0x74
	int	0x10
	mov	al, 0x69
	int	0x10
	mov	al, 0x6E
	int	0x10
	mov	al, 0x67
	int	0x10
	mov	al, 0x20
	int	0x10
	mov	al, 0x6B
	int	0x10
	mov	al, 0x65
	int	0x10
	mov	al, 0x72
	int	0x10
	mov	al, 0x6E
	int	0x10
	mov	al, 0x65
	int	0x10
	mov	al, 0x6C
	int	0x10
	mov	al, 0x2E
	int	0x10
	int	0x10
	int	0x10
	ret
times 510-($-$$) db 0
db 0x55, 0xAA
