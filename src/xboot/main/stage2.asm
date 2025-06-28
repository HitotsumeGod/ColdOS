bits 16
org 0x1000

kern_start	equ 0x1400
stack_bottom	equ 0x090000
CODE		equ 0x08
DATA		equ 0x10

; 
; XBOOT data section (aligned to both hard disk sector boundaries).
; Remember to jump over this to the next sector when loading with XBOOT Stage 1.
;

gdt:
	gdt_null:
		dd 0
		dd 0
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
	dw gdt_end - gdt - 1
	dd gdt
times 512 - ($ - $$) db 0
endata

;
; XBOOT Stage 2 code.
; Proceeds directly after data section; aligned to both hard disk sector boundaries.
; After loading disk sectors, Stage 1 should execute a jump to this location.
;

prep_prot:
	; move the cpu into 32-bit protected mode
	cli
	xor	ax, ax
	mov	ds, ax
	lgdt	[gdt_desc]
	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax
	jmp	CODE:prot_mode
prot_mode:
bits 32
	mov	ax, CODE
	mov	ds, ax
	mov	ax, DATA
	mov	ss, ax
	mov	esp, stack_bottom
	; pass control to the kernel
	jmp	CODE:kern_start
times 512 - ($ - endata) db 0
