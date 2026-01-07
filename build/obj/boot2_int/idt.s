	.file	"idt.c"
	.intel_syntax noprefix
	.comm	idt,2048,32
	.text
	.globl	add_idt_handler
	.type	add_idt_handler, @function
add_idt_handler:
.LFB0:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	ebx
	sub	esp, 32
	.cfi_offset 3, -12
	mov	ecx, DWORD PTR [ebp+12]
	mov	ebx, DWORD PTR [ebp+16]
	mov	edx, DWORD PTR [ebp+20]
	mov	eax, DWORD PTR [ebp+24]
	mov	WORD PTR [ebp-24], cx
	mov	BYTE PTR [ebp-28], bl
	mov	WORD PTR [ebp-32], dx
	mov	WORD PTR [ebp-36], ax
	mov	eax, DWORD PTR [ebp-32]
	mov	WORD PTR [ebp-12], ax
	mov	eax, DWORD PTR [ebp-24]
	mov	WORD PTR [ebp-10], ax
	mov	BYTE PTR [ebp-8], 0
	mov	al, BYTE PTR [ebp-28]
	mov	BYTE PTR [ebp-7], al
	mov	eax, DWORD PTR [ebp-36]
	mov	WORD PTR [ebp-6], ax
	mov	ecx, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [ebp-12]
	mov	edx, DWORD PTR [ebp-8]
	mov	DWORD PTR idt[0+ecx*8], eax
	mov	DWORD PTR idt[4+ecx*8], edx
	nop
	add	esp, 32
	pop	ebx
	.cfi_restore 3
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	add_idt_handler, .-add_idt_handler
	.globl	isr_divide_by_zero
	.type	isr_divide_by_zero, @function
isr_divide_by_zero:
.LFB1:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 8
	push	31
	push	69
	push	6
	push	1
	call	printg
	add	esp, 16
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	isr_divide_by_zero, .-isr_divide_by_zero
	.globl	isr_invalid_opcode
	.type	isr_invalid_opcode, @function
isr_invalid_opcode:
.LFB2:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 8
	push	31
	push	73
	push	6
	push	1
	call	printg
	add	esp, 16
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	isr_invalid_opcode, .-isr_invalid_opcode
	.globl	idt_start
	.type	idt_start, @function
idt_start:
.LFB3:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 16
	mov	WORD PTR [ebp-6], 2047
	mov	DWORD PTR [ebp-4], OFFSET FLAT:idt
	mov	eax, OFFSET FLAT:isr_dbz_stub
	shr	eax, 16
	mov	edx, eax
	mov	eax, OFFSET FLAT:isr_dbz_stub
	movzx	eax, ax
	push	edx
	push	eax
	push	142
	push	8
	push	0
	call	add_idt_handler
	add	esp, 20
	mov	eax, OFFSET FLAT:isr_ioe_stub
	shr	eax, 16
	mov	edx, eax
	mov	eax, OFFSET FLAT:isr_ioe_stub
	movzx	eax, ax
	push	edx
	push	eax
	push	142
	push	8
	push	6
	call	add_idt_handler
	add	esp, 20
	lea	eax, [ebp-6]
/APP
/  50 "src/bootloader/stage2/int/idt.c" 1
	lidt (eax)
/  0 "" 2
/NO_APP
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	idt_start, .-idt_start
	.globl	printg
	.type	printg, @function
printg:
.LFB4:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 24
	mov	edx, DWORD PTR [ebp+16]
	mov	eax, DWORD PTR [ebp+20]
	mov	BYTE PTR [ebp-20], dl
	mov	BYTE PTR [ebp-24], al
	mov	edx, DWORD PTR [ebp+8]
	mov	eax, edx
	sal	eax, 2
	add	eax, edx
	lea	edx, [0+eax*4]
	add	edx, eax
	mov	eax, DWORD PTR [ebp+12]
	add	eax, edx
	mov	DWORD PTR [ebp-4], eax
	mov	eax, DWORD PTR [ebp-4]
	add	eax, eax
	add	eax, 753664
	mov	DWORD PTR [ebp-8], eax
	movsx	eax, BYTE PTR [ebp-24]
	sal	eax, 8
	mov	edx, eax
	movsx	ax, BYTE PTR [ebp-20]
	or	eax, edx
	mov	edx, DWORD PTR [ebp-8]
	mov	WORD PTR [edx], ax
	mov	eax, 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	printg, .-printg
	.ident	"GCC: (GNU) 5.2.0"
