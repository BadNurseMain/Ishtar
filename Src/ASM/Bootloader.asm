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

	mov ax, 0x1000		; Set up Extra Segment
	mov es, ax

	jmp _start

; Function Declarations.

printString: ; SI = String
	push bx
	push ax
	mov bx, 0
	mov ah, 0x0e	

	printString_CMP:
		mov al, byte [si+bx] 	; Offsetting from Start of String.
		int 0x10		; Interrupt for Character
		
		inc bx			; Incrementing BX to Change Offset.

		cmp bl, 16		; Making sure String is no Longer than 16 Characters.
		je printString_CLEANUP

		cmp al, 0		; Proceeding unless NULL-Determined Character is Present.
		jne printString_CMP			

	printString_CLEANUP:
		pop ax
		pop bx
	ret

verifyCD:
	push ax
	push dx
	push si
	mov si, 0
	
	mov ah, 0x44
	mov dl, 0xe0
	int 0x13
	
	mov si, FAILED
	call printString
	
	cmp cf, 0
	je verifyCD_CLEANUP
	
	
	
	verifyCD_CLEANUP:
		pop si
		pop dx
		pop ax
	ret

; Define Declarations.
MSG db 'Howdy x', 0
FAILED db 'Failed...', 0
_start:
	mov si, MSG
	call printString

	times 510 - ($ - $$) db 0
	dw 0xaa55
