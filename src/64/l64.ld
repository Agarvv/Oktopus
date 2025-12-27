ENTRY(_start)

SECTIONS {
    . = 0x100000;  
    
    .text : { 
	*(.text.boot)
        *(.text)
    }
    
    .data : {
        *(.data)
    }
    
    .bss : {
        *(.bss)
    }
}
