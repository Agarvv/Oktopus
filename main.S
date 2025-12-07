bits 16
org 0x7C00       

start:
  ; mov dx, 0x3F8
  ; mov al, 'D'
  ; out dx, al
   
   mov ax, 2401h
   int 15h


   cli
   xor ax, ax
   mov ds, ax          
   lgdt [gdt_des]

   mov ah, 0x0E   
   mov al, 'H'     
   int 0x10    
    
   mov eax, cr0          
   or eax, 1
   mov cr0, eax




   jmp 0x08:protected_mode_start


bits 32
protected_mode_start:

   mov ax, 0x10
   mov ds, ax
   mov es, ax
   mov fs, ax
   mov gs, ax

 
   mov ss, ax
   mov esp, 0x90000    

   mov edi, 0xB8000
   mov byte [edi], 'U'       
   mov byte [edi+1], 0x07     


  
  

   ; check disk status
   call disk_status 



   ; load kernel 
   mov edi, 0x00000001    ; initial lba 
   mov ecx, 2             ; sectors to read 
   call load_kern 



  

   mov edi, 0xB8000
   mov byte [edi+2], 'f'       
   mov byte [edi+3], 0x07  
   
   jmp 0x08:0x1000



  



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

         
         
          ; if not one then not bussy, now check if ready bit is one, meaning ready 
          ; 00000000
          ;  ^ Disk ready
          ; mask to apply: AND with 01000000 (0x40)
          and al, 0x40 
          jz disk_status

       
          
         ; all conditions met, return.
         ret
   
   data_ready: 
           
           mov dx, 0x1F7
           in al, dx 
           mov ah, 0x00 
           
           ; 00000000
           ; ^ BUSY DISK

           ; mask: AND with 10000000 (0x80)

           and al, 0x80 
           ; if bussy it means disk is working on our request so loop until it is not busssy anymore 
           jnz data_ready

           ; now if we are here it mean disk is not bussy anymore so 
           ; we'll check if disk has data ready, if yes, return.

          

           ; 00000000
           ;     ^ data request, if 1, then disk has data to transfer, 
           ; if 0, there is not pending data

           ; we need to check if that bit is one and if it is one it means that we have pending data 
           ; so, we can put it into a well known memory address so we can jump there later.

           ; we have to apply mask AND 00001000 
           and al, 0x08 
           jz data_ready 
           
           jmp read_data
            
          ret 



print_nibble:
    cmp al, 10
    jl .num
    add al, 'A' - 10
    jmp .done
.num:
    add al, '0'
.done:
    mov dx, 0x3F8      
    out dx, al
    ret


print_byte:
    push ax           
    mov ah, al         
    shr al, 4         
    call print_nibble
    mov al, ah
    and al, 0x0F      
    call print_nibble
    pop ax
    ret



   
   read_data: 
        
         mov dx, 0x1F0 
         
         in ax, dx 
         
         ret 

         
     
   load_kern: 
       
        
        pushad                 
        
      
        mov     eax, 0x00001000
        mov     esi, eax       
        
.read_sector_loop:
   
        ; ebx = edi (LBA)
        mov     ebx, edi
        ; byte 0 (low)
        mov     dx, 0x1F3
        mov     al, bl
        out     dx, al

        ; byte 1
        mov     dx, 0x1F4
        mov     al, bh
        out     dx, al

        ; byte 2
        mov     ebx, edi
        shr     ebx, 16
        mov     al, bl
        mov     dx, 0x1F5
        out     dx, al

        ; byte 3 + flags (0xE0 | (LBA >> 24 & 0x0F))
        mov     ebx, edi
        shr     ebx, 24
        and     bl, 0x0F
        or      bl, 0xE0
        mov     al, bl
        mov     dx, 0x1F6
        out     dx, al

        ; sectors to read = 1
        mov     dx, 0x1F2
        mov     al, 0x01
        out     dx, al

        ; send read command 0x20
        mov     dx, 0x1F7
        mov     al, 0x20
        out     dx, al

      
.wait_drq:
        mov     dx, 0x1F7
        in      al, dx
        test    al, 0x80       
        jnz     .wait_drq
  
        in      al, dx
        test    al, 0x08     
        jz      .wait_drq

        
        mov     cx, 256       
        mov     dx, 0x1F0
.read_words:
        in      ax, dx          
        mov     [esi], ax      
        add     esi, 2
        loop    .read_words

       
        inc     edi
        dec     ecx
        jnz     .read_sector_loop

       
        mov     dx, 0x3F8
        mov     al, 'Z'
        out     dx, al

        popad
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
