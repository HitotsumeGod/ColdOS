; real mode bootloader for the intel x86-64 platform

;
; --------------------------------------------------------------------------
; |BOOTLOADER + KERNEL MAPPED TO MEMORY                                    |
; |------------------------------------------------------------------------|
; |Sector 1 (0x7C00)|Sector 2 (0x1000)|Sector 3 (0x1200)|Sector 4+ (0x1400)|
; |-----------------|-----------------|-----------------|----------------- |
; |XBOOT Stage 1    |XBOOT data       |XBOOT Stage 2    |ColdOS Kernel     |
; |	            |section	      |		        |                  |
; |	            |	     	      |		        |                  |
; |	            |	     	      |		        |                  |
; | 	            |	     	      |	                |                  |
; |	            |	     	      |		        |                  |
; |	            |	     	      |		        |                  |
; |	            |	     	      |		        |                  |
; --------------------------------------------------------------------------
;

bits 16
org 0x7C00

load	equ 0x1000

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
load_sectors:
	; load remainder of bootloader + kernel into memory starting at 0x0000:0x1000
	mov	ah, 0x02
	mov	al, 3
	mov	ch, 0
	mov	cl, 2
	mov	dh, 0
	mov	dl, 0x80
	mov	bx, 0x0000
	mov	es, bx
	mov	bx, load
	int	0x13
	jc	load_sectors
	call	print_boot
	; jump to XBOOT Stage 2
	jmp	0x0000:0x1200
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
