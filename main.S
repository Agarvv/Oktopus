bits 16          
org 0x7C00       

start:
    ; disable interrupts 
    PUSHF
    POP AX
    AND AX, 0xFDFF  
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
    MOV AX, 0x0010 
    MOV DS, AX
    MOV ES, AX
    MOV FS, AX 
    MOV GS, AX 
    

     ; turn on protected mode 
   MOV EAX, CR0     
     OR EAX, 0x00000001    
   MOV CR0, EAX      
    
    JMP 0x0008:kern

bits 32 
kern: 
   MOV SS, ax
   MOV ESP, 0x9FC00
   JMP $ 
   
    

TIMES 510 - ($ - $$) DB 0
DW 0xAA55
