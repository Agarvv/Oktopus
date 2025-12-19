global isr_stub 
extern isr_handler 

isr_stub:
    popa 
    call isr_handler 
    pusha 
    iret 
