

ENTRY(_start)

SECTIONS {
    . = 0x10000;  
    
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

