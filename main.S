bits 16          
org 0x7C00       

.data:
   num db 0
   

start:

    
TIMES 510 - ($ - $$) DB 0
DW 0xAA55