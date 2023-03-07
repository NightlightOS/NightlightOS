org 0x0000
bits 16

jmp init

bootMsg: db "Welcome to NightlightOS", 10, 0

init:
	mov ax, 0x01
	mov si, bootMsg
	int 0x30

	jmp $
