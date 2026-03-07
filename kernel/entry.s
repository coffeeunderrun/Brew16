BITS 16
CPU 286

EXTERN PASCALMAIN

GROUP DGROUP _TEXT
SECTION _TEXT class=CODE group=DGROUP

GLOBAL _entry
_entry:
    cli

    mov     ax, 0x2401                  ; AX = 2401h Enable A20 line (INT 15h)
    int     0x15

    mov     ax, 0x2402                  ; AX = 2402h Check A20 line status (INT 15h)
    int     0x15
    jc      a20_failed

    lgdt    [gdt.ptr]

    smsw    ax
    or      ax, 1                       ; Set protection enable bit
    lmsw    ax

    jmp     gdt.code:start

start:
    mov     ax, gdt.data
    mov     ds, ax
    mov     es, ax
    mov     ss, ax
    mov     sp, __stktop

    jmp     PASCALMAIN

a20_failed:

GLOBAL _halt
_halt:
    hlt
    jmp     _halt

GROUP DGROUP rodata
SECTION rodata class=DATA group=DGROUP

ALIGN 8
gdt:
.null:
    dq 0

.code: equ $ - gdt                      ; Code segment descriptor (base=10000h, limit=FFFFh, type=9Ah)
    dw 0xFFFF
    dw 0
    db 0x01
    db 0x9A
    dw 0

.data: equ $ - gdt                      ; Data segment descriptor (base=10000h, limit=FFFFh, type=92h)
    dw 0xFFFF
    dw 0
    db 0x01
    db 0x92
    dw 0

.vmem: equ $ - gdt                      ; Video memory segment descriptor (base=B8000h, limit=7FFFh, type=92h)
    dw 0x7FFF
    dw 0x8000
    db 0x0B
    db 0x92
    dw 0

.ptr:
    dw $ - gdt - 1
    dw gdt                              ; Symbol `gdt` will only have the offset in a 64K segment
    dw 1                                ; but it exists at 10000h in the linear address space

GLOBAL _code_sel
_code_sel:
    dw gdt.code

GLOBAL _data_sel
_data_sel:
    dw gdt.data

GLOBAL _vmem_sel
_vmem_sel:
    dw gdt.vmem

GROUP DGROUP stack
SECTION stack class=STACK group=DGROUP

ALIGN 2
GLOBAL __stkbottom
__stkbottom:
    resb 1000h
GLOBAL __stktop
__stktop:
