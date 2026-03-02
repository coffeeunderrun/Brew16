OUTPUT_FORMAT(binary)

MEMORY {
    ram (rwx) : ORIGIN = 0x8000, LENGTH = 32K
}

SECTIONS {
    . = 0x8000;

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
        *(fpc)
        *(.rtti*)
        *(.init*)
        *(.note*)
        *(.debug*)
    }
}
