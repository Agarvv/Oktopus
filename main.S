bits 16
org 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7C00

   
    mov dx, 0x3F8
    mov al, 'R'
    out dx, al


    mov ah, 0x0E
    mov al, 'H'
    int 0x10

    
    lgdt [gdt_descriptor]

    
    mov dx, 0x3F8
    mov al, 'G'
    out dx, al

    
    mov eax, cr0
    or eax, 1
    mov cr0, eax

   
    mov dx, 0x3F8
    mov al, 'C'
    out dx, al

   
    jmp 0x08:protected_mode_start


gdt_start:
    dq 0x0000000000000000       

 
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x9A
    db 0xCF
    db 0x00

   
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x92
    db 0xCF
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start


bits 32
protected_mode_start:
 
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9FC00


    mov dx, 0x3F8
    mov al, 'P'
    out dx, al


    mov edi, 0xB8000
    mov byte [edi], 'X'
    mov byte [edi+1], 0x0F

.hang:
    hlt
    jmp .hang

times 510 - ($-$$) db 0
dw 0xAA55
