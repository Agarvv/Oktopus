
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
   mov byte [edi], 'U'       
   mov byte [edi+1], 0x07     


   mov dx, 0x3F8
   mov al, 'O'
   out dx, al
  
   ; check disk status
   jmp disk_status 

   mov dx, 0x3F8
   mov al, 'N'
   out dx, al

   mov edi, 0xB8000
   mov byte [edi+2], 'f'       
   mov byte [edi+3], 0x07 



   ; al can look like this 00000000 
   ; 00000000
   ; ^ BUSY DISK

   ; 00000000
   ;  ^ Disk ready 

   ; 00000000
   ;   ^ Device fault 

    ; 00000000
   ;     ^ seek complete  

   ; 00000000
   ;     ^ data request, if 1, then disk has data to transfer, 
         ; if 0, there is not pending data

   ; 00000000
   ;      ^  corrected error

   ; 00000000
   ;       ^  index mark

   ; 00000000
   ;        ^  operation error


   
   
   ; if disk not busy and ready, send i/o







   mov al, 0x20 ; read command. for write, i would use 0x30, or 0x21 for read ext and 0x31 for write ext 
   mov dx, 0x1F7
   out dx, al


   jmp $

   disk_status: 
          mov dx, 0x3F8
          mov al, 'N'
          out dx, al

          ; first, check if bussy bit is one 
           mov dx, 0x1F7
           in al, dx 
           mov ah, 0x00 
           
           ; 00000000
           ; ^ BUSY DISK

           ; mask: AND with 10000000 (0x80)

           and al, 0x80 
           jnz disk_status
     
           mov dx, 0x1F7
           in al, dx 

           mov dx, 0x3F8
           mov al, 'N'
           out dx, al
         
          ; if not one then not bussy, now check if ready bit is one, meaning ready 
          ; 00000000
          ;  ^ Disk ready
          ; mask to apply: AND with 01000000 (0x40)
          and al, 0x40 
          jz disk_status

          mov dx, 0x3F8
         mov al, 'N'
         out dx, al
          
         ; all conditions met, return.
         ret
         











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