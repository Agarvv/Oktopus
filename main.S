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
    MOV EAX, 0x0010 
    MOV DS, EAX
    MOV SS, EAX
    MOV ES, EAX
    MOV FS, EAX 
    MOV GS, EAX 

    ; turn on protected mode 
    MOV EAX, CR0 
    OR EAX, 0x00000080
    MOV CR0, EAX 
    
    JMP 0x0008:kern

kern: 
   JMP $ 
  
   

TIMES 510 - ($ - $$) DB 0
DW 0xAA55s
