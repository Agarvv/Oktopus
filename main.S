
org 0x7C00       



start:
   mov dx, 0x3F8
   mov al, 'D'
   out dx, al
   
   mov ax, 2401h
   int 15h


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
   call disk_status 



   ; load kernel 
   mov ecx, 8185 
   call load_kern 



   mov dx, 0x3F8
   mov al, 'l'
   out dx, al

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
         mov al, 'J'
         out dx, al
          
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

           mov dx, 0x3F8
           mov al, 'N'
           out dx, al

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

   
   read_data: 
          mov dx, 0x1F0 
          in ax, dx ; receive data 
           
           
           
           mov WORD [ebx + ebp], ax  
           
           
           add ebp, 2
           dec si 
           jnz read_data
           
           mov dx, 0x3F8
            mov al, 'b'
            out dx, al
         ret 

         
     
   load_kern: 
         mov dx, 0x3F8
         mov al, 'x'
         out dx, al
         ; kernel is 4mb big, so we have to read from sector one to sector 8185 aprox.
         
         
         mov edi, 0x00000000 ; lba addr 
         mov ebx, edi 
         
         ; 00000000000000000000000000000000
         ;                         ^^^^^^^^ 
         
         ; ^^^ 
         ; MASK: 
         ; 00000000000000000000000011111111
         ;                         ^^^^^^^^ 
         ; 0x000000FF 
         
         
         
         
         
         
         
         ; 00000000000000000000000000000000
         ;                 ^^^^^^^^
         
         
         ; ^^^
         ; MASK:
         ; 00000000000000001111111100000000
         ;                 ^^^^^^^^
         ; 0x0000FF00 
         
         
         
         
         
         ; 00000000000000000000000000000000
         ;         ^^^^^^^^
         ; ^^^
         ; MASK 
         ; 0000000011111111 0000000000000000
         ;         ^^^^^^^^
         ; 0x00FF0000
         
         
         
         
         
         ; 00000000000000000000000000000000
         ;     ^^^^
         ; MASK: 
         ; 00001111 000000000000000000000000
         ;     ^^^^
         ; 0x0F000000
           
         
         
         
         mov dx, 0x3F8
         mov al, 'y'
         out dx, al

         
         ; low LBA adress
         mov dx, 0x1F3
         AND ebx, 0x000000FF 
         
         
         mov al, bl
         
         
         out dx, al 
         mov ebx, edi 
         
         
         ; medium LBA adress
         mov dx, 0x1F4
         AND ebx, 0x0000FF00 
         
         mov al, bl 
         
         shr ebx, 8 
         
         out dx, al
         mov ebx, edi 

         ; High LBA adress
         mov dx, 0x1F5
         AND ebx, 0x00FF0000 
         shr ebx, 16
         
         mov al, bl
         out dx, al
         
         
         mov ebx, edi 
         AND ebx, 0x0F000000 
         shr ebx, 24 
        
         ; last 3 bits of lba adress and aditional flags 
         ; we use 11100000 (0xE0)
         ; 1111 0000 
         ; 1111 
         mov dx, 0x1F6
         mov al, 0xE0
         or al, bl
         out dx, al 
         ; 00000000
         ; ^ always one in lba

         ; 00000000
         ;  ^ 0 one for lba, zero for chs 


         ; 00000000
         ;   ^ always one too

         ; 00000000
         ;    ^ zero for master one for slave 

          ; 00000000
         ;      ^^^^ last bits of lba address

      
         ; sectors to read (one)
         mov dx, 0x1F2
         mov al, 0x01
         out dx, al 


         ; read command 
         mov dx, 0x1F7 
         mov al, 0x20 ; 0x20 for read, 0x30 for write, 0x21 for read ext, 0x31 for write ext 
         out dx, al 

         mov dx, 0x3F8
         mov al, 'z'
         out dx, al 
        
        mov ebx, 0x1000 ; base kernel addr 
         mov ebp, 0x00 ; increment to kernel mem addr 
         mov si, 256 ; 512/2 bytes 
         call read_data ; read data and put it somewhere well known on memory so we can jump there. 
        
         inc edi 
         dec ecx 
    
         jnz load_kern 

         mov dx, 0x3F8
         mov al, 'v'
         out dx, al

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