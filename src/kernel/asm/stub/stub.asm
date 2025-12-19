global isr_dbz_stub  
global isr_ioe_stub


extern isr_divide_by_zero
extern isr_invalid_opcode

isr_dbz_stub:
    pusha
    call isr_divide_by_zero
    popa
    iret  

isr_ioe_stub: 
    pusha
    call isr_invalid_opcode
    popa 
    iret 
    
