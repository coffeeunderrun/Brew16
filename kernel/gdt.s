BITS 16
CPU 286

GDT_START equ 0x500

GROUP DGROUP _TEXT
SECTION _TEXT class=CODE group=DGROUP

GLOBAL _gdt_init
_gdt_init:
    mov     ax, GDT_START >> 4          ; Segment = GDT start / 16 (50:0000h)
    mov     es, ax

    ; Zero out GDT.
    xor     ax, ax
    xor     di, di
    mov     cx, 0xFFFF - GDT_START
    rep stosb

    ; Null descriptor (also GDT pointer)
    xor     di, di
    xor     ax, ax
    xor     bx, bx
    mov     cx, GDT_START
    mov     dx, 0xFFFF - GDT_START
    call    set_gdt_entry

    ; GDT segment descriptor (base=500h, limit=FAFFh, type=92h)
    mov     di, [_gdt_sel]
    mov     ax, 0x92
    ; BX, CX, and DX are the same as null descriptor
    call    set_gdt_entry

    ; Code segment descriptor (base=10000h, limit=FFFFh, type=9Ah)
    mov     di, [_code_sel]
    mov     ax, 0x9A
    mov     bx, 0x1
    xor     cx, cx
    mov     dx, 0xFFFF
    call    set_gdt_entry

    ; Data segment descriptor (base=10000h, limit=FFFFh, type=92h)
    mov     di, [_data_sel]
    mov     ax, 0x92
    ; BX, CX, and DX are the same as code segment descriptor.
    call    set_gdt_entry

    ; Video memory segment descriptor (base=B8000h, limit=FFFFh, type=92h)
    mov     di, [_vmem_sel]
    ; AX and DX are the same as data segment descriptor.
    mov     bx, 0xB
    mov     cx, 0x8000
    call    set_gdt_entry

    lgdt    [es:0]                      ; GDT null descriptor is also GDT pointer

    smsw    ax
    or      ax, 1                       ; Set protection enable bit
    lmsw    ax

    pop     ax                          ; Save caller return address
    push    word [_code_sel]            ; Set new CS on far return
    push    ax
    retf                                ; Far return to protected mode

; Populate a GDT entry.
; Input:    DI - Segment selector
;           AX - Access byte
;           BX - Base (upper 8 bits)
;           CX - Base (lower 16 bits)
;           DX - Limit
; Return:   None
set_gdt_entry:
    mov     [es:di], dx                 ; Limit
    mov     [es:di + 2], cx             ; Base (lower 16 bits)
    mov     [es:di + 4], bx             ; Base (upper 8 bits)
    mov     [es:di + 5], ax             ; Access byte
    ret

GROUP DGROUP bss
SECTION bss class=BSS group=DGROUP

GLOBAL _gdt_sel
_gdt_sel:
    dw 0

GLOBAL _code_sel
_code_sel:
    dw 0x10

GLOBAL _data_sel
_data_sel:
    dw 0x18

GLOBAL _vmem_sel
_vmem_sel:
    dw 0x20
