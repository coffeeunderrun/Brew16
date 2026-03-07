BITS 16
CPU 286

GDT_START equ 0x1000
GDT_SIZE  equ 0x1000

GROUP DGROUP _TEXT
SECTION _TEXT class=CODE group=DGROUP

GLOBAL _gdt_init
_gdt_init:
    mov     ax, GDT_START >> 4          ; Segment = GDT_START / 16, i.e., 100:0000h
    mov     es, ax

    ; Zero out GDT.
    xor     ax, ax
    xor     di, di
    mov     cx, GDT_SIZE
    rep stosb

    ; TODO: these could be rearranged to reduce MOVs

    ; Null descriptor (also GDT pointer)
    xor     di, di
    xor     ax, ax
    xor     bx, bx
    mov     cx, GDT_START
    mov     dx, GDT_SIZE - 1
    call    set_gdt_entry

    ; System segment descriptor (base=0h, limit=FFFFh, type=92h)
    ; This segment is for accessing IDT, GDT, TSS, LDT, and supporting structures.
    mov     di, 1
    mov     ax, 0x92
    ; BX is the same as null descriptor
    xor     cx, cx
    mov     dx, 0xFFFF
    call    set_gdt_entry

    ; Code segment descriptor (base=10000h, limit=FFFFh, type=9Ah)
    mov     di, 2
    mov     ax, 0x9A
    mov     bx, 0x1
    ; CX and DX are the same as system segment descriptor.
    call    set_gdt_entry

    ; Data segment descriptor (base=10000h, limit=FFFFh, type=92h)
    mov     di, 3
    mov     ax, 0x92
    ; BX, CX, and DX are the same as code segment descriptor.
    call    set_gdt_entry

    ; Video memory segment descriptor (base=B8000h, limit=FFFFh, type=92h)
    mov     di, 4
    ; AX and DX are the same as data segment descriptor.
    mov     bx, 0xB
    mov     cx, 0x8000
    call    set_gdt_entry

    lgdt    [es:0]                      ; GDT null descriptor is also GDT pointer

    smsw    ax
    or      ax, 1                       ; Set protection enable bit
    lmsw    ax

    pop     ax                          ; Save caller return address
    push    word 0x10                   ; Set new CS on far return
    push    ax
    retf                                ; Far return to protected mode

; Populate a GDT entry.
; Input:    DI - Entry index
;           AX - Access byte
;           BX - Base (upper 8 bits)
;           CX - Base (lower 16 bits)
;           DX - Limit
; Return:   None
set_gdt_entry:
    shl     di, 3                       ; Entry index * 8
    mov     [es:di], dx                 ; Limit
    mov     [es:di + 2], cx             ; Base (lower 16 bits)
    mov     [es:di + 4], bx             ; Base (upper 8 bits)
    mov     [es:di + 5], ax             ; Access byte
    ret
