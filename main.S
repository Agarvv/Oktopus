bits 16          
org 0x7C00       

start:
    ; Tu código aquí
    mov si, mensaje
    call imprimir
    jmp $       

imprimir:
    mov ah, 0x0E
.bucle:
    lodsb
    cmp al, 0
    je .fin
    int 0x10     
    jmp .bucle
.fin:
    ret

mensaje db "hola", 0


times 510 - ($ - $$) db 0


dw 0xAA55