bits 16
org 0x7C00

start:
   mov dword [0x9000], 0x12345678

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


    jmp 0x08:protected_start

bits 32
protected_start:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov dword [0x9000], 0x12345678

   
.loop:
    jmp .loop             

times 510-($-$$) db 0
dw 0xAA55
