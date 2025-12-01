bits 16
org 0x7C00

start:
    cli

   
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

    lgdt [gdt_descriptor]

  
    mov eax, cr0
    or eax, 1
    mov cr0, eax

 
    jmp 0x08:dword protected_start

times 510-($-$$) db 0
dw 0xAA55

bits 32
protected_start:

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

  
    mov dword [0xB8000], 0x0F4B004B   

.loop:
    jmp .loop
