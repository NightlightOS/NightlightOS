bits 16
org 0x1000

jmp kernel

%include "global/functions.asm"

bootMsg:
	db "Welcome to NightlightOS", 0

kernel:
	; switch to text mode
	mov ah, 0x00
	mov al, 0x03
	int 0x10

	mov si, bootMsg
	call printString

	jmp $

times 4096-($-$$) db 0
dw 0xAA55
