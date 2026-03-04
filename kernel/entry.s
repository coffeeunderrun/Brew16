bits 16

extern _main

section .text.entry

entry:
    ; Kernel assumes it was loaded at CS:8000h and all segments match CS.
    mov     sp, stack_top
    jmp     _main

section .bss

align 2
stack_bottom:
    resb    $1000
stack_top:
