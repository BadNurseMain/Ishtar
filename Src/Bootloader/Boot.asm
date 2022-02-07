[org 0x7c00]
_start:
    ; Setting up all Segment Registers.
    xor ax, ax
    mov ss, ax
    mov ds, ax
    mov es, ax

    ; Setting up Stack Pointer.
    mov ax, 0x7c00
    mov sp, ax

    xor ax, ax
    jmp _main

_initVideo:
    push ax
    mov ax, 0x0003
    int 0x10
    pop ax
    ret

_readDisk:
    mov ax, 0x0201
    mov cx, 0x0002
    mov dh, 0x00
    mov bx, 0x9000
    int 0x13

    jc _readDisk_Error
    ret

    _readDisk_Error:
    
    ret

_printChar: ; al = Character.
    mov ah, 0x0e
    int 0x10
    ret

_printString:
    push bx
    mov bx, si

    _printString_Loop:
    mov al, byte[bx]
    call _printChar
    inc bx
   
    cmp al, 0
    jne _printString_Loop

    pop bx
    ret

%include "Bootloader/GDT.s"

_main:
    call _initVideo
    call _readDisk
    mov si, KernelText
    call _printString
    
    cli

    call createGDT

    mov eax, cr0
    xor eax, 1
    mov cr0, eax

    mov ecx, 'e'
    mov ebx, 0x0301
    push ecx
    push ebx

    jmp 0x9000
    KernelText db "Kernel Loaded", 0

    times 510 - ($ - $$) db 0
    dw 0xaa55
