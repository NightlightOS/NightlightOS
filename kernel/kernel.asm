bits 16
org 0x1000

jmp kernel

%include "kernel/api.asm"

initPath: db "/init.nl", 0

kernel:
	; switch to text mode
	mov ah, 0x00
	mov al, 0x03
	int 0x10

	; load API
	xor ax, ax
	mov es, ax
	mov si, 0xC0 ; 0x30's interrupt
	mov [es:si], word interrupt_handler
	mov si, 0xC2
	mov [es:si], cs

	; load init program
	mov ax, 0x03     ; load file
	mov bx, 0x0012
	mov es, bx       ; init sector
	xor di, di       ; 0x0000
	mov si, initPath
	int 0x30

	jmp 0x0012:0x0000

	jmp $

times 4096-($-$$) db 0
