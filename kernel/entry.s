bits 16

extern _main
extern ___stacktop

section .text.entry

entry:
    ; Kernel assumes it was loaded at 0000:8000h and all segments are zero.
    mov     sp, ___stacktop
    jmp     _main
