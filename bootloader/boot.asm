bits 16
org 0x7C00

jmp bootloader

times 9-($-$$) db 0

db "YSFS" ; Disk name
db "NightlightOS", 0, 0, 0, 0

bootloader:
	; Set up the stack
	mov ax, 0x9000
	mov ss, ax
	mov sp, 0xFFFF

	; Load kernel from first sector of drive
	mov bx, 0x1000    ; Destination address for kernel
	mov dh, 12        ; Number of sectors to read (4 kiB)
	mov dl, 0         ; Drive number (0 = first drive)
	call diskLoad

	; Jump to the kernel
	jmp 0x1000

diskLoad:
    pusha
    push dx
    mov ah, 0x02    ; BIOS read function
    mov al, dh      ; Number of sectors to read
    mov cl, 0x02    ; Starting sector (2 since sector 1 is boot sector)
    mov ch, 0x00    ; Starting cylinder (0)
    mov dh, 0x00    ; Starting head (0)
    int 0x13        ; BIOS interrupt to read from disk
    
    jc diskError    ; Check carry flag for error
    pop dx          ; Restore original number of sectors to read
    cmp al, dh      ; Compare number of sectors read to original value
    jne sectorsError
    popa
    ret

diskError:
    mov si, diskErrorMsg
    call printString
    jmp $

sectorsError:
    mov si, sectorsErrorMsg
    call printString
    jmp $

printString:
    mov ah, 0x0E
	.loop:
	    lodsb
	    cmp al, 0
	    je .done
	    int 0x10
	    jmp .loop
	.done:
	    ret

diskErrorMsg:    db "Disk error", 0
sectorsErrorMsg: db "Sectors read error", 0

times 510-($-$$) db 0
dw 0xAA55
