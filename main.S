
org 0x7C00       



start:
   mov dx, 0x3F8
mov al, 'D'
out dx, al

   cli
   lgdt [gdt_des]

   mov ah, 0x0E   
   mov al, 'H'     
   int 0x10    
    
   mov eax, cr0          
   or eax, 1
   mov cr0, eax

   mov dx, 0x3F8
mov al, 'C'
out dx, al


   jmp 0x08:protected_mode_start


bits 32
protected_mode_start:
   mov ax, 0x10
   mov ds, ax
   mov es, ax
   mov fs, ax
   mov gs, ax
   mov ss, ax
   mov esp, 0x80000
   
   mov edi, 0xB8000
   mov byte [edi], 'X'       
   mov byte [edi+1], 0x07     


   mov dx, 0x3F8
   mov al, 'O'
   out dx, al
   


   jmp $











; formar of an entry:
; upper base (eight bits): 00000000 






; Granularity, 32 bit, 64, avaibable and upper limit(eight bits): 00000000 could look like this:
; 00000000
; ^ granularity 

; 00000000
;  ^ 32 bit segment 

; 00000000
;   ^ 64 bit segment 

; 00000000
;    ^ avaibable

; 00000000
;     ^^^^  last four bits of limit







;access bits (eight bits): 00000000 could look like this:
; 00000000
; ^ present bit 

; 00000000
;  ^^ privilege bits (0 = kernel, 3 = user, 2 = drivers/services)

; 00000000
;    ^ type bit (1 = code/data segment, 0 = system segment)

; 00000000
;     ^ executable 

; 00000000
;      ^ conforming or non-conforming

; 00000000
;       ^ readable  

; 00000000
;        ^ accesed (managed by cpu)  





; medium base (eight bits): 00000000

; low base (sixteen bits): 0000000000000000

; low limit (sixteen bits): 0000000000000000

gdt_start:
    dq 0                    

    ; code 
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b    
    db 11001111b    
    db 0x00
  
      ; data
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b    
    db 11001111b   
    db 0x00
gdt_end:


gdt_des:
   dw gdt_end - gdt_start - 1 
   dd gdt_start          

times 510 - ($-$$) db 0       

dw 0xAA55