bits 16
org 0x7C00

BUFFER      equ 0x500
KSTART      equ 0x8000

    jmp     short start
    nop

%include "fat.inc"

; Boot Parameter Block
bpb:
istruc PB
    at .oemname, db "BREW16  "
iend

start:
    cli
    cld
    jmp     0:load_cs

; BIOS could have jumped to 07C0:0000h or 0000:7C00h.
load_cs:
    xor     ax, ax
    mov     ds, ax
    mov     ss, ax
    mov     sp, KSTART                  ; Set stack top to bottom of kernel

get_drive_params:
    xor     di, di
    mov     ah, 8                       ; Read Drive Parameters (INT 13h)
    mov     [bpb + PB.drivenum], dl     ; BIOS loads DL with drive number at boot
    int     0x13
    xor     ax, ax                      ; BIOS could change ES
    mov     es, ax
    jnc     .ready

    mov     si, badboot
    call    print_string
    jmp     reboot_wait

.ready:
    and     cx, 0x3F                    ; Bits 0..5 are sectors per cylinder
    mov     [bpb + PB.cylsects], cx
    inc     dh                          ; BIOS returns head count - 1
    mov     [bpb + PB.headcnt], dh

calc_root_dir_start:
    xor     ax, ax
    mov     al, [bpb + PB.fatcnt]       ;   FAT count
    mul     word [bpb + PB.fatsects]    ; * Sectors per FAT
    add     ax, [bpb + PB.rsvdsects]    ; + Reserved sectors
    mov     [rootsect], ax              ; = Root directory start sector

calc_data_region_start:
    mov     ax, 32                      ;   32 bytes per root directory entry
    mul     word [bpb + PB.entrycnt]    ; * Root directory entry count
    add     ax, [bpb + PB.sectsize]     ; + Bytes per sector
    dec     ax                          ; - 1 (ceiling)
    xor     dx, dx
    div     word [bpb + PB.sectsize]    ; / Bytes per sector
    mov     [rootsize], al              ; = Root directory size in sectors
    add     ax, [rootsect]              ; + Root directory start sector
    mov     [datasect], ax              ; = Data region start sector

load_root:
    mov     ax, [rootsect]
    call    calc_chs

    mov     al, [rootsize]              ; Root directory sector count to read
    mov     ah, 2                       ; Read Sectors (INT 13h)
    mov     bx, BUFFER                  ; Load root directory into buffer (ES:BX)

.load:
    int     0x13
    jnc     .done

    call    reset_drive
    jmp     .load

.done:

find_kernel:
    mov     cx, [bpb + PB.entrycnt]     ; Check all root entries until kernel is found
    mov     di, BUFFER                  ; Root directory is currently in buffer

.check_entry:
    mov     si, filename
    push    di                          ; Save current buffer position
    push    cx                          ; Save entry counter
    mov     cx, 11                      ; Filenames are 11 bytes long
    rep     cmpsb                       ; Compare all 11 bytes of filename
    je      .found

    pop     cx                          ; Restore entry counter
    pop     di                          ; Get saved buffer position
    add     di, 32                      ; Move to next root entry
    loop    .check_entry

    mov     si, notfound
    call    print_string
    jmp     reboot_wait

.found:
    mov     si, [di + 15]               ; Cluster chain starts at bytes 26..27 (offset of 15 after filename)

load_fat:
    mov     ax, [bpb + PB.rsvdsects]    ; First FAT starts after reserved sectors
    call    calc_chs

    mov     al, [bpb + PB.fatsects]     ; FAT sector count to read
    mov     ah, 2                       ; AH = 2 for Read Sectors (INT 13h)
    mov     bx, BUFFER                  ; Load first FAT into buffer (ES:BX)

.load:
    int     0x13
    jnc     .done

    call    reset_drive
    jmp     .load

.done:

; Expects SI to contain the start cluster from find_kernel.
load_kernel:
    mov     di, KSTART                  ; Kernel load destination

.calc_data_sector:
    mov     ax, si                      ;   Current cluster
    sub     ax, 2                       ; - 2
    mov     bl, [bpb + PB.clstsects]
    xor     bh, bh
    mul     bx                          ; * Sectors per cluster
    add     ax, [datasect]              ; + Data region start sector

.load_cluster:
    call    calc_chs                    ; Calculate CHS for data sector

    mov     bx, di                      ; Kernel destination pointer
    mov     al, [bpb + PB.clstsects]    ; Cluster size in sectors to read
    mov     ah, 2                       ; AH = 2 for Read Sectors (INT 13h)
    int     0x13

    jnc     .advance_dest_pointer

    call    reset_drive
    jmp     .calc_data_sector

.advance_dest_pointer:
    xor     ah, ah                      ;   Number of sectors read (AL)
    mul     byte [bpb + PB.clstsects]   ; * Sectors per cluster
    mul     word [bpb + PB.sectsize]    ; * Bytes per sector
    add     di, ax                      ; + Current destination pointer

.calc_next_cluster:
    mov     bx, si                      ;   Current cluster
    shr     bx, 1                       ; / 2
    add     bx, si                      ; + Current cluster
    mov     dx, [BUFFER + bx]           ; = Offset into FAT
    test    si, 1
    jz      .even_cluster

    shr     dx, 4                       ; Odd cluster; lower 4 bits belong to even cluster

.even_cluster:
    and     dx, 0xFFF

    cmp     dx, 0xFF7                   ; FF7 is a bad cluster
    je      .error

    cmp     dx, 0xFF8                   ; FF8 through FFF is the last cluster
    jae     .done

    mov     si, dx                      ; Next cluster
    jmp     .calc_data_sector

.error:
    mov     si, badboot
    call    print_string
    jmp     reboot_wait

.done:
    jmp     0:KSTART                    ; Jump to kernel entry point

; Print string to screen.
; Input:  SI - pointer to string
; Return: none
print_string:
    pusha
    mov     ah, 0xE                     ; AH = Eh for Teletype Output (INT 10h)

.next_char:
    lodsb
    cmp     al, 0                       ; Strings are null-terminated
    je      .done

    int     0x10
    jmp     .next_char

.done:
    popa
    ret

; Reset boot drive.
; Input:  none
; Return: none
; Flags:  CF - set if error occured
reset_drive:
    pusha
    xor     ax, ax                      ; AH = 0 for Reset Disk Drive (INT 13h)
    mov     dl, [bpb + PB.drivenum]
    int     0x13
    popa
    ret

; Wait for keypress then reboot.
; Input:  none
; Return: none
reboot_wait:
    mov     si, presskey
    call    print_string
    xor     ax, ax                      ; AH = 0 for Read Keypress (INT 16h)
    int     0x16
    int     0x19                        ; Reboot (INT 19h)

; Calculate cylinder, head, and sector from logical sector.
; Input:  AX - logical sector number
; Return: CL - drive sector
;         CH - drive cylinder
;         DL - drive number
;         DH - drive head
calc_chs:
    xor     dx, dx
    div     word [bpb + PB.cylsects]    ;   Logical sector % Sectors per cylinder
    inc     dl                          ; + 1 (sectors are 1-indexed)
    mov     cl, dl                      ; = Drive sector
    xor     dx, dx
    div     word [bpb + PB.headcnt]     ; (Logical sector / Sectors per cylinder) % Number of heads
    mov     dh, dl                      ; = Drive head
    mov     ch, al                      ; = Drive cylinder
    mov     dl, [bpb + PB.drivenum]
    ret

rootsect:   dw 0                        ; Root dir start sector
rootsize:   db 0                        ; Root dir sector count
datasect:   dw 0                        ; Data start sector

filename:   db "KERNEL  BIN", 0
badboot:    db "Disk error.", 0
notfound:   db "Kernel not found.", 0
presskey:   db 13, 10, "Press a key to reboot...", 13, 10, 0

times 510 - ($ - $$) db 0

bootsig:    dw 0xAA55                   ; Boot sector signature
