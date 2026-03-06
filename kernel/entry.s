BITS 16
CPU 8086

EXTERN PASCALMAIN

GROUP DGROUP _TEXT
SECTION _TEXT class=CODE group=DGROUP

GLOBAL _entry
_entry:
    mov     ax, cs
    mov     ds, ax
    mov     es, ax
    mov     ss, ax
    mov     sp, __stktop

    jmp     PASCALMAIN

GLOBAL _halt
_halt:
    hlt
    jmp     _halt

GROUP DGROUP stack
SECTION stack class=STACK group=DGROUP

ALIGN 2
GLOBAL __stkbottom
__stkbottom:
    resb 1000h
GLOBAL __stktop
__stktop:
