OUTPUT_FORMAT(binary)

MEMORY {
    ram (rwx) : ORIGIN = 0x500, LENGTH = 32K - 0x500
}

SECTIONS {
    . = 0x500;

    .text BLOCK(2) : {
        *(.text.entry)
        *(.text _TEXT)
    } > ram

    .rodata BLOCK(2) : {
        *(.rodata rodata)
    } > ram

    .data BLOCK(2) : {
        *(.data data)
    } > ram

    .bss BLOCK(2) (NOLOAD) : {
        *(.bss bss stack heap)
    } > ram

    /DISCARD/ : {
        *(fpc)      /* Discard the FPC version information. */
        *(.rtti*)   /* Discard unused RTTI information. */
        *(.init*)   /* Discard unused initialization functions. */
        *(.note*)
        *(.debug*)
    }
}
