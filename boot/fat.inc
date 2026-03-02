struc PB
    .disklabel: resb 8                  ; Disk label
    .sectsize:  resw 1                  ; Bytes per sector
    .clstsects: resb 1                  ; Sectors per cluster
    .rsvdsects: resw 1                  ; Reserved sectors
    .fatcnt:    resb 1                  ; FAT count
    .entrycnt:  resw 1                  ; Root directory entry count
    .sectcnt:   resw 1                  ; Logical sector count
    .mediadesc: resb 1                  ; Media descriptor
    .fatsects:  resw 1                  ; Sectors per FAT
    .cylsects:  resw 1                  ; Sectors per cylinder
    .headcnt:   resw 1                  ; Head count
    .hdnsects:  resd 1                  ; Hidden sector count
    .lrgsects:  resd 1                  ; Large sector count
    .drivenum:  resb 1                  ; Drive number
    .reserved:  resb 1                  ; Reserved
    .drivesig:  resb 1                  ; Drive signature
    .volid:     resd 1                  ; Volume ID
    .vollabel:  resb 11                 ; Volume label
    .fstype:    resb 8                  ; File system type
endstruc
