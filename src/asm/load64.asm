 global load_kernel_64 
; i'll leave here some important ports that i'll use 
; 0x1F0 Data R/W 
; 0x1F2 sectors to R/W 
; 0x1F3 Logical block address Low
; 0x1F4 – Logical block addres medium 
; 0x135  Logical block addres high 
; 0x1F6 flags, drive mode, last lba bits...
; 0x1F7 Status and commands

; when read 0x1F7 returns one byte: 
; bit 7   disk is busy
; bit 6  device is ready
; bit 5  device fault
; bit 4  seek completed
; bit 3  data request ready
; bit 2  data corrected
; bit 1  index pulse
; bit 0  error occurred

; those are the commands that go in port 0x1F7 

; 0x20 read sectors (LBA28, PIO)
; 0x30 write sectors (LBA28, PIO)

; 0x24 read sectors extended (LBA48)
; 0x34 write sectors extended (LBA48)

; 0xEC identify device
; used to detect the disk and its capabilities

; 0xEF set features
; enables or disables special disk features

; 0xC6 set multiple mode
; used for multi sector transfers

; in order to load the kernel that is in disk, 
; first, it will check BSY reading port 0x1F7, if BSY is not one,
; check if device is ready
; if ready, perform disk operation starting at LBA X (where the kernel is) using ports 0x1F3–0x1F5 and 0x1F6
; read Y sectors from the disk using port 0x1F2.
; set master disk using 0x1F6
; set 0x24 in port 0x1F7, meaning, read operation.
; then bussy disk will be set to 1, and when disk is ready to transfer data, will set bit 3 of port 0x1F7 to 1
; meaning data request is ready. i'll read data from port 0x1F0 and load it into memory. 
; and so on in loop until disk isnt bussy anymore.

load_kernel_64:   
   ; check if disk can perform operations
    call disk_ok 

    ; 0x1F6 takes something like this:
    ; 00000000 
    ; ^ always one

    ; 00000000 
    ;  ^ LBA mode

    ; 00000000 
    ;   ^ reserved (always one)

    ; 00000000 
    ;    ^ drive select (0 master, 1 slave)

    ; 00000000 
    ;     ^^^^ last lba bits
    
    ; i'll use 11100000 (0xE0)
    mov al, 0xE0   
    out 0x1F6, al 

    ; load LBA
    ; LBA LOW 
    mov al, 0x21 
    out 0x1F3, al 

    ; LBA MEDIUM 
    mov al, 0x00 
    out 0x1F4, al 

    ; LBA HIGH
    out 0x1F5, al 

    ; set sectors to read
    mov al, 10 
    out 0x1F2, al 

    ; set READ comand 
    mov al, 0x20 
    out 0x1F7, al 
    
    ; now do polling and read data from port 0x1F0.
    call polling 



   

    jmp $

disk_ok: 
   .disk_bussy: 
      ; 00000000 
      ; ^ DISK BUSY 

      ; apply mask to leave only that bit, and if it is not zero it means the disk is bussy
      ; so jump until disk isnt bussy anymore. 
      in al, 0x1F7 
      and al, 0x80 
      jnz .disk_bussy 
   
   .disk_ready:
      ; 00000000 
      ;  ^ DISK READY 
      in al, 0x1F7 
      and al, 0x40 
      jz .disk_ready 
      ret


polling:
    ; loop until there isnt any data to transfer anymore and disk is not busy anymore
    ; read busy status
    in al, 0x1F7 
    ; mask the busy bit
    and al, 0x80 

    ; save the status so we can work here with conditional stuff
    pushf
    
    ; read the DRQ bit
    in al, 0x1F7 
    ; mask the drq bit
    and al, 0x08 

    jz .notread 

    .read:
      in ax, 0x1F0
    
    
    .notread:
      ; restore the status 
      popf

      ; if that bit is not zero it means it is busy so loop until it isnt bussy anymore
     jnz polling
   
   ret  