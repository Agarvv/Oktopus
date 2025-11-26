bits 16          
org 0x7C00       

start:
    
    mov si, mensaje
    call print
    call kread 
    jmp $

print:
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .end
    int 0x10     
    jmp .loop
.end:
    ret
    
kread:
     mov ah, 0x00 
     int 0x16 
     
     mov ah, 0x0E 
     int 0x10 

mensaje db "Oktopus Running", 0


times 510 - ($ - $$) db 0


dw 0xAA55
