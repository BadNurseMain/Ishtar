 [bits 16]
createGDT:
    lgdt [.GDT]
    ret

.GDT:
    dq 0x00 ; NULL Pointer
.code: equ $ - .GDT
    dq (1<<44) | (1<<47) | (1<<41) | (1<<43) | (1<<53)    
.data: equ $ - .GDT
    dq (1<<44) | (1<<47) | (1<<41)
.pointer:
    dw .pointer - .GDT - 1
    dq .GDT
