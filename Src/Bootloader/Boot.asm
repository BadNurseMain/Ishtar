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

%include "Bootloader/GDT.s"

_main:
    call _initVideo
    call _readDisk
    
    cli

    call createGDT

    mov eax, cr0
    xor eax, 1
    mov cr0, eax

    jmp 0x9000

    times 510 - ($ - $$) db 0
    dw 0xaa55
