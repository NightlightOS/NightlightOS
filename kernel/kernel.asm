bits 16
org 0x1000

jmp kernel

%include "global/functions.asm"
%include "kernel/api.asm"

bootMsg:
	db "Welcome to NightlightOS", 0

kernel:
	; switch to text mode
	mov ah, 0x00
	mov al, 0x03
	int 0x10

	mov si, bootMsg
	call printString

	; load API
	xor ax, ax
	mov es, ax
	mov si, 0xC0 ; 0x30's interrupt
	mov [es:si], word interrupt_handler
	mov si, 0xC2
	mov [es:si], cs

	mov ax, 0x00
	int 0x30

	jmp $

times 4096-($-$$) db 0
dw 0xAA55
