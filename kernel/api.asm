interrupt_test:
	push ax
	
	mov al, 'P'
	mov ah, 0x0E
	int 0x10

	pop ax
	iret

interrupt_print_string:
	; Parameters
	; si = string

	push ax
	push si

	mov ah, 0x0E

	.loop:
		lodsb
		cmp al, 0
		je .done
		cmp al, 10
		je .newLine
		int 0x10
		jmp .loop
	.newLine:
		mov al, 13
		int 0x10
		mov al, 10
		int 0x10
		jmp .loop
	.done:
		pop si
		pop ax

		iret

interrupt_string_length:
	; Parameters
	; si = string

	push ax
	push si
	xor bx, bx ; counter

	.loop:
		lodsb
		cmp al, 0
		je .done
		inc bx
		jmp .loop
	.done:
		pop si
		pop ax
	
		mov ax, bx
		iret
		
interrupt_handler:
	cmp ax, 0x00
	je interrupt_test

	cmp ax, 0x01
	je interrupt_print_string

	cmp ax, 0x02
	je interrupt_string_length
	
	iret
