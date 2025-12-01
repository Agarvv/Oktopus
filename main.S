bits 16
org 0x7C00

start:
    cli

; ---------------------------
; GDT FLAT REAL Y FUNCIONAL
; ---------------------------
gdt_start:
    dq 0x0000000000000000        ; null

    ; code segment: base=0, limit=4GB
    dq 0x00CF9A000000FFFF

    ; data segment: base=0, limit=4GB
    dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

    lgdt [gdt_descriptor]

    ; activar modo protegido
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:protected_mode     ; salto lejano correcto


; ============================================================
; ===============  MODO PROTEGIDO A PARTIR DE AQUÍ ===========
; ============================================================

bits 32
protected_mode:
    ; Cargar segmentos
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax

    ; Stack VÁLIDO (importantísimo)
    mov esp, 0x90000

; ---------------------------
; Escribir texto en pantalla
; ---------------------------
    mov edi, 0xB8000

    mov byte [edi], 'H'
    mov byte [edi+1], 0x0F

    mov byte [edi+2], 'O'
    mov byte [edi+3], 0x0F

    mov byte [edi+4], 'L'
    mov byte [edi+5], 0x0F

    mov byte [edi+6], 'A'
    mov byte [edi+7], 0x0F

halt:
    jmp halt


; ---------------------------
; Boot signature
; ---------------------------
times 510-($-$$) db 0
dw 0xAA55
