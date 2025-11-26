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
     cmp al, 0x0E
     je backspace 

     cmp al, 0x20 
     je space 

     cmp al, 0x1C 
     je enter


     mov ah, 0x0E  
     int 0x10 
     jmp kread 

backspace:
    mov si, backsp 
    call print 
space:
  mov si, spc 
  call print 
  jmp kread
enter: 
   mov si, ent 
   call print 
   jmp kread

mensaje db "Oktopus Running", 0
backsp db "BACKSPACE", 0
spc db "SPACE", 0
ent db "ENTER", 0



times 510 - ($ - $$) db 0


dw 0xAA55
