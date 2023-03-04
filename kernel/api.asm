interrupt_test:
	push ax
	
	mov al, 'P'
	mov ah, 0x0E
	int 0x10

	pop ax
	iret

interrupt_handler:
	cmp ax, 0x00
	jmp interrupt_test
	ret