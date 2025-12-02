bits 16          
org 0x7C00       

start:
    jmp bt

align 4
gdt_start:
    ; Null descriptor
    dd 0x00000000
    dd 0x00000000
    
    ; Code descriptor (0x08)
    dw 0xFFFF           ; Limit low
    dw 0x0000           ; Base low
    db 0x00             ; Base mid
    db 10011010b        ; Access byte (code, readable)
    db 11001111b        ; Granularity (4KB, 32-bit)
    db 0x00             ; Base high

    ; Data descriptor (0x10)
    dw 0xFFFF           ; Limit low
    dw 0x0000           ; Base low
    db 0x00             ; Base mid
    db 10010010b        ; Access byte (data, writable)
    db 11001111b        ; Granularity (4KB, 32-bit)
    db 0x00             ; Base high
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start 

kboard_in_handler:
    PUSHA 
    MOV BYTE [0xB8000], 'O'
    POPA
    IRET

align 4
idt_st: 
    ; First IDT entry (interrupt 0)
    dw 0x0000              ; offset low
    dw 0x08                ; selector
    db 0x00                ; zero
    db 0x8E                ; type/attributes (32-bit interrupt gate, present)
    dw 0x0000              ; offset high
    
    times (32*8)-8 db 0    ; Fill rest of IDT

idt_en:

idtr:
    dw idt_en - idt_st - 1 
    dd idt_st


bits 16
bt:
    cli                    ; Disable interrupts
    LGDT [gdt_descriptor]

    ; Enable protected mode
    MOV EAX, CR0     
    OR EAX, 0x00000001    
    MOV CR0, EAX      
    
    ; Far jump to flush pipeline and load code segment
    JMP 0x08:protect_mode

bits 32
protect_mode:





protect_mode:
    ; Load data segment selector
    MOV AX, 0x10
    MOV DS, AX
    MOV ES, AX
    MOV FS, AX
    MOV GS, AX
    MOV SS, AX

    ; Setup stack
    MOV ESP, 0x9FC00

    ; Load IDT
    lidt [idtr]

    ; Enable interrupts
    sti

    ; Write 'K' to video memory at 0xB8000
    MOV BYTE [0xB8000], 'K'
    MOV BYTE [0xB8001], 0x0F  ; White on black

    MOV DWORD [0x9000], 0x12345678
    
    JMP $
    
    
TIMES 510 - ($ - $$) DB 0
DW 0xAA55