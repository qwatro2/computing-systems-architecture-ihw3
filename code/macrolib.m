# macro-wrapper for preparing and calling function read
.macro read(%file %TEXT_SIZE)
    la a1 %file
    li a2 %TEXT_SIZE
    jal read
.end_macro

# macro for increment (trying ++%reg, but not works :(   )
.macro inc %reg
	addi %reg %reg 1
.end_macro

# macro for decrement
.macro dec %reg
	addi %reg %reg -1
.end_macro

# macro for save move 
.macro smv %reg1 %reg2
	push(%reg2)
	pop(%reg1)
.end_macro

# macro for printing char from register %reg
.macro print_char_reg(%reg)
	li a7 11 # syscall for printing character
    smv a0 %reg
    ecall
.end_macro

# macro for allocate memory of size from register %size_reg
# return begining of allocated memory in register %return_reg
.macro allocate_reg(%size_reg, %return_reg)
	li a7 9
	smv a0 %size_reg
	ecall
	smv %return_reg a0
.end_macro

# macro-wrapper for preparing and calling function solve
.macro solve(%buffer, %answer, %answer_length_reg)
	lw a0 %buffer
	lw a1 %answer
	mv a2 %answer_length_reg
	jal solve
.end_macro

# macro for input integer from dialog window
.macro input_n(%reg, %msg)
	.data
		msg: .asciz %msg  # promt
	.text
		la a0 msg
		li a7 51
		ecall
		smv %reg a0
.end_macro

# macro-wrapper for preparing and calling function write
.macro write(%file %answer %answer_length_reg)
    la a0 %file
    lw a1 %answer
    mv a2 %answer_length_reg
    jal write
.end_macro

# macro-wrapper for preparing and calling function input_path
.macro input_path(%file %NAME_SIZE %msg)
.data 
 	message: .asciz %msg # prompt
.text
    la a1 %file
    li a2 %NAME_SIZE
    la a3 message
    jal input
.end_macro

# macro-wrapper for preparing and calling function console_output
.macro console_output(%str, %N_reg)
    lw a0 %str
    smv a1 %N_reg
    jal console_output
.end_macro
