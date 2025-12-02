bits 16
org 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Serial: Real mode start
    mov dx, 0x3F8
    mov al, 'R'
    out dx, al

    ; Print 'H' via BIOS teletype (real mode)
    mov ah, 0x0E
    mov al, 'H'
    int 0x10

    ; Load GDT
    lgdt [gdt_descriptor]
    mov dx, 0x3F8
    mov al, 'G'    ; serial: G
    out dx, al

    ; Enable protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    mov dx, 0x3F8
    mov al, 'C'    ; serial: C
    out dx, al

    ; Far jump to protected mode code
    jmp 0x08:protected_mode_start

; -------- GDT ----------
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

; ------- Protected Mode -------
bits 32
protected_mode_start:
    ; setup segments (selector 0x10 is data descriptor)
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9FC00

    ; serial: we entered protected mode
    mov dx, 0x3F8
    mov al, 'P'
    out dx, al

    ; write "PMOK" into VGA text buffer (each char + attribute)
    ; address 0xB8000 = first cell; we'll write words (char|attr<<8)
    mov edi, 0xB8000

    ; Write 'P' with attr 0x0F
    mov eax, 'P'          ; lower byte = 'P'
    and eax, 0xFF
    mov ah, 0x0F          ; AH = attr
    shl eax, 8
    or eax, 'P'
    ; Alternatively simpler: write byte pairs using mov [edi], ax
    mov ax, 'P'           ; AX = char in low byte
    mov bx, 0x0F00
    or ax, bx             ; AX = attr<<8 | char
    mov [edi], ax
    add edi, 2

    mov ax, 'M'
    or ax, bx
    mov [edi], ax
    add edi, 2

    mov ax, 'O'
    or ax, bx
    mov [edi], ax
    add edi, 2

    mov ax, 'K'
    or ax, bx
    mov [edi], ax
    add edi, 2

    ; Ahora leemos de vuelta los 4 caracteres y los enviamos por serial.
    ; Leer desde 0xB8000 y enviar el carácter (low byte) por serial 4 veces.
    mov esi, 0xB8000
    mov ecx, 4
.readloop:
    mov ax, [esi]       ; AX = attr<<8 | char
    mov bl, al          ; BL = char
    mov dx, 0x3F8
    mov al, bl
    out dx, al
    add esi, 2
    loop .readloop

.hang:
    hlt
    jmp .hang

times 510 - ($-$$) db 0
dw 0xAA55
