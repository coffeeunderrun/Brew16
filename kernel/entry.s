BITS 16
CPU 286

EXTERN _gdt_init
EXTERN _data_sel
EXTERN PASCALMAIN

GROUP DGROUP _TEXT
SECTION _TEXT class=CODE group=DGROUP

GLOBAL _entry
_entry:
    cli
    cld

    mov     ax, 3                       ; Set video mode 3 (80x25 text mode)
    int     0x10

    mov     ah, 1                       ; AH = 1 Set cursor type (INT 10h)
    mov     cx, 0x2000                  ; Disable cursor
    int     0x10

    mov     ax, 0x2401                  ; AX = 2401h Enable A20 line (INT 15h)
    int     0x15

    mov     ax, 0x2402                  ; AX = 2402h Check A20 line status (INT 15h)
    int     0x15
    jc      a20_failed

    call    _gdt_init

    ; Now in protected mode.
    mov     ax, 0x18
    mov     ds, ax
    mov     es, ax
    mov     ss, ax
    mov     sp, _stack_top

    jmp     PASCALMAIN

a20_failed:

GLOBAL _halt
_halt:
    hlt
    jmp     _halt

GROUP DGROUP stack
SECTION stack class=STACK group=DGROUP

ALIGN 2
GLOBAL _stack_bottom
_stack_bottom:
    resb 1000h
GLOBAL _stack_top
_stack_top:
