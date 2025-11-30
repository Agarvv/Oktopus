bits 16          
org 0x7C00       

.data:
   num db 0
   

start:
    ; disable interrupts 
    PUSHF
    POP AX
    AND AX, 0xFDFF  
    PUSH AX
    POPF
    

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

    LGDT [gdt_descriptor]
    MOV AX, 0x0010 
    MOV DS, AX
    MOV ES, AX
    MOV FS, AX 
    MOV GS, AX 
    

     ; turn on protected mode 
   MOV EAX, CR0     
     OR EAX, 0x00000001    
   MOV CR0, EAX      
    
    JMP 0x0008:kern

bits 32 

kboard_in_handler:
    PUSHA 
    
    MOV BYTE [0xB8000], 'O'
    POPA
    IRET

idt_st: 
dw 0x0000 ; first offset 
dw 0x00000008 ; code selector on GDT 
db 0x0000 ; zero 

; type atrributes:
; 1 00 0 0000
; ^ present


; 1 00 0 0000
;   ^^ privilege level (0 == kernel, 3 == user)


; type atrributes:
; 1 00 0 0000
;      ^ storage segment



; type atrributes:
; 1 00 0 0000
;        ^^^^ interrupt type 

; 5 = task gate  (16 bits)
; 6 = Interrupt gate (16 bits)
; 7 = trap gate (16 bits)
; 0xE = interrupt gate (32 bits)
; 0xf (32 bits)

; normally we want type attributes in 0x8E or 10001110 on interruptions
db 0x8E

dw 0x0000; second offset 

times 32*8 db 0 
idt_en

idtr:
    dw idt_en - idt_st - 1 
    dd idt_st

lidt [idtr]

kern: 
   MOV BYTE [0xB8000], 'O' 
   ; stack config 
   MOV SS, AX 
   MOV ESP, 0x9FC00


   
 
 
 
   mov eax, kboard_in_handler 
   mov ebx, idt_st 
   
   mov word [ebx], ax 
   shr eax, 16
   mov word [ebx+6], ax 
   
   

   
   ; enable interrupts 
   PUSHF
   POP AX
   AND AX, 0x0200
   PUSH AX
   POPF 
   

   MOV BYTE [0xB8000], 'O'


   JMP $
   
    
TIMES 510 - ($ - $$) DB 0
DW 0xAA55
