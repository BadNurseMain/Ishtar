[bits 16]

; Setting up Data and Stack Segment Registers,
; Stack Segment comes after Data Segment.
_setup:
	mov ax, 0x07C0		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 0x07C0		; Set data segment to where we're loaded
	mov ds, ax

	jmp _start

; Function Declarations.

printString: ; SI = String
	push bx
	push ax
	mov bx, 0
	mov ah, 0x0e	

	printString_CMP:
		mov al, byte[si+bx] 	; Offsetting from Start of String.
		int 0x10		; Interrupt for Character
		
		inc bx			; Incrementing BX to Change Offset.

		cmp bl, 16		; Making sure String is no Longer than 16 Characters.
		je printString_CLEANUP

		cmp al, 0		; Proceeding unless NULL-Determined Character is Present.
		jne printString_CMP			


	mov al, 0x0D		; To present a new line.
	int 0x10
	mov al, 0x0a
	int 0x10

	printString_CLEANUP:
		pop ax
		pop bx
ret

findDisk: 				; DL = Drive
	mov ah, 0x15		; Disk Checking Interrupt.
	int 0x13

	cmp ah, 0			; If AH is 0, there is no drive present.
	je findDisk_END

	mov al, dl			; Returns the Drive Number.	
ret

	findDisk_END:
	mov al, -1
ret						; Returns the Drive Number or 0 if there is no Drive Present.

readDisk: 				; DL = Drive, CL = Sector, AL = Sectors to Read, ES:BX Pointer.
	mov ah, 0x02
	mov ch, 0
	mov dh, 0
	int 0x13
ret

; Define Declarations.
BOOTMESSAGE db 'Started Ishtar', 0
FAILED db 'Failed', 0
FOUND db 'Found Drive', 0

_start:
	mov si, BOOTMESSAGE
	call printString

	mov dx, 0
	_driveSearchLoop:
		call findDisk
		cmp al, -1
		jne _driveFound
		
		inc dx

		cmp dx, 10
		jne _driveSearchLoop

	mov si, FAILED
	call printString

_driveFound:
	mov si, FOUND
	call printString

	mov dl, al
	mov cl, 2
	mov al, 1

	mov bx, 0xa000
	mov es, bx
	mov bx, 0x1234

	call readDisk
	jc _driveError
	jmp _finish

_driveError:
	mov si, FAILED
	call printString

_finish:
	times 510 - ($ - $$) db 0
	dw 0xaa55
