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

	push bx
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
		pop bx
		iret

interrupt_read_file:
	; Parameters
	; si = filename
	; es = segment to load at
	; di = address to load at
	pusha

	xor bl, bl ; cylinder
	mov bh, 14 ; sector (first 13 sectors are bootloader + kernel)

	.loop:
		push es
		mov ax, 16
		mov es, ax
		mov ah, 0x02 ; read disk function
		mov al, 1    ; number of sectors
		mov ch, bl   ; cylinder number
		mov cl, bh   ; sector number
		xor dh, dh   ; head number (only 720k floppy support rn)
		xor dl, dl   ; drive number (first floppy)
		
		push bx
		mov bx, 0x0000

		int 0x13

		pop es
		pop bx

		; check for errors
		jc .diskError
		cmp al, 1
		je .sectorError

		push di

		; check if this sector contains magic bytes
		cmp byte [di],     'Y'
		jne .continue
		cmp byte [di + 1], 'S'
		jne .continue
		cmp byte [di + 2], 'F'
		jne .continue
		cmp byte [di + 3], 'S'
		jne .continue

		; check filename length
		add di, 4

		push si
		mov ax, 0x02
		mov si, di
		int 0x30
		mov bx, ax ; fragment file name

		mov ax, 0x02
		pop si
		int 0x30 ; parameter file name

		cmp ax, bx
		jne .continue ; filenames aren't the same length

		; check filename contents
		mov cx, ax ; string length
		repne cmpsb
		jne .continue

		; we have that file
		pop di
		push di
		mov ax, 360
		mul byte [di + 0x85] ; place fragment in the correct place
		add di, ax
		push si
		xor si, si
		mov cx, 360
		rep movsb
		pop si
		pop di

	.continue:
		inc bh
		cmp bh, 18
		jge .incCylinder
		jmp .loop
		
	.incCylinder:
		xor bh, bh
		inc bl
		cmp bl, 79
		jge .done
		jmp .loop

	.done:
		popa
		iret

	.diskError:
		mov ax, 0x01
		mov si, .diskErrorMsg
		int 0x30
		jmp $
	.diskErrorMsg: db "FATAL: Disk Error", 10, 0

	.sectorError:
		mov ax, 0x01
		mov si, .sectorErrorMsg
		int 0x30
		jmp $
	.sectorErrorMsg: db "FATAL: Sector Error", 10, 0

interrupt_handler:
	cmp ax, 0x00
	je interrupt_test

	cmp ax, 0x01
	je interrupt_print_string

	cmp ax, 0x02
	je interrupt_print_string

	cmp ax, 0x03
	je interrupt_read_file
	
	iret
