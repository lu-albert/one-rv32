SECTIONS
{
    . = 0x00000000;
    .data : { *(.data) }
    .text : { *(.text) }
}
