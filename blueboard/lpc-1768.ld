MEMORY
{
    FLASH (rx) : ORIGIN = 0x0 LENGTH = 0x80000
    SRAM (rwx) : ORIGIN = 0x10000000 LENGTH = 0x8000
    AHBRAM0 : ORIGIN = 0x2007C000 LENGTH = 0x4000
    AHBRAM1 : ORIGIN = 0x20080000 LENGTH = 0x4000
}

ENTRY(reset_handler)

SECTIONS
{
    __ram_top = ORIGIN(SRAM) + LENGTH(SRAM);
    __initial_sp = __ram_top - 16;

    . = ALIGN(4);
    .text :
    {
        . = 0x0;
        LONG(__initial_sp)
        *(.isr_vector_first_six)

        /* vector table checksum */
        LONG(
            -(
                __initial_sp
                + reset_handler
                + nmi_handler
                + hard_fault_handler
                + memory_management_fault_handler
                + bus_fault_handler
                + usage_fault_handler
                + 6
            )
        )

        . = 0x2c;
        *(.isr_sv_call)
        . = 0x3c;
        *(.isr_vector_rest)
        . = 0x400;
        *(.text*)
        *(.init*)
        *(.fini*)
        *(.rodata*)
        *(.ARM.extab* .gnu.linkonce.armextab.*)
        *(.eh_frame)
        /*
                 *(.ARM.exidx* .gnu.linkonce.armexidx.*)
        */
    } > FLASH

    . = ALIGN(4);
    __exidx_start = .;
    PROVIDE(__exidx_start = __exidx_start);

    .ARM.exidx :
    {
        *(.ARM.exidx* .gnu.linkonce.armexidx.*);
        __end_of_flash = .;
    } > FLASH AT > FLASH /* index entries for section unwinding */

    . = ALIGN(4);
    __exidx_end = .;
    PROVIDE(__exidx_end = __exidx_end);


    .bss :
    {
        __bss_start__ = .;
        *(.bss*)
        __bss_end__ = .;
    } > SRAM

    .data : AT (__end_of_flash)
    {
        __data_start = .;
        *(vtable)
        *(.data*)
        __data_end = .;
    } > SRAM

    __stack_size = 8192;
    __heap_start = .;
    __heap_end = __heap_start + (0x8000 - __stack_size);

    /* Why, oh why does newlib use such a generic name for a global?!? */
    PROVIDE(end = __heap_end);
    PROVIDE(__end__ = __heap_end);

    /DISCARD/ :
    {
        *(.comment)
    }
}
