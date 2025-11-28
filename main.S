bits 16          
org 0x7C00       

start:
    ; disable interrupts 
    PUSHF
    POP AX 
    AND AX, 0xFFFFFDFF
    PUSH AX 
    POPF 
    

gdt_start:

    dd 0x00000000
    dd 0x00000000
    
    dw 0xFFFF     
    dw 0x0000      
    db 0x00        
    db 10011010b  
    db 11001111b  
    db 0x00        
    

    dw 0xFFFF      
    dw 0x0000      
    db 0x00        
    db 10010010b   
    db 11001111b   
    db 0x00       
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

    LGDT [gdt_descriptor]



    JMP $

TIMES 510 - ($ - $$) DB 0
DW 0xAA55s
