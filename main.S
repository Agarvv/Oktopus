bits 16
org 0x7C00

pepe:
 mov AH, 0x0E
 mov AL, 'A'
 int 0x10

 jmp start_code  


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


start_code:
cli
 lgdt [gdt_descriptor]
 mov AH, 0x0E
 mov AL, 'E'
 int 0x10
 mov AH, 0x0E
 mov AL, 'E'
 int 0x10
 mov AH, 0x0E
 mov AL, 'E'
 int 0x10

times 510-($-$$) db 0
dw 0xAA55
