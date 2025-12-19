extern isr_handler 

isr_stub:
   pusha 
   call isr_handler 
   popa
   iret 
