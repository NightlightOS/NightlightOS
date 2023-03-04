interrupt_test:
	push ax
	
	mov al, 'P'
	mov ah, 0x0E
	int 0x10

	pop ax
	iret

interrupt_print_string:
	push ax
	push si

	mov ah, 0x0E

	.loop:
		lodsb
		cmp al, 0
		je .done
		int 0x10
		jmp .loop
	.done:
		pop si
		pop ax

		iret

interrupt_handler:
	cmp ax, 0x00
	je interrupt_test

	cmp ax, 0x01
	je interrupt_print_string
	
	iret
