
OUTPUT_FORMAT("binary")
ENTRY(_start)

SECTIONS {
        . = 0x10000;  /* Dirección de carga */
            
                .text : {
                            *(.text)
                }
                    
                        .data : {
                                    *(.data)
                        }
                            
                                .bss : {
                                            *(.bss)
                                }
}
                                }
                        }
                }
}