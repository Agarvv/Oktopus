
BITS 32             
GLOBAL _start

section .text

_start:
    mov edi, 0xB8000 
     mov byte [edi], ':'  
    
     .inf:
    hlt           
    jmp .inf     

    

