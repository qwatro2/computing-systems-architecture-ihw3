.include "macrolib.m"
.include "macro-syscalls.m"

.macro print_str (%x)  # macro for printing screen in-place
   .data
		str: .asciz %x
   .text
   		li a7, 4
   		la a0, str
   		ecall
.end_macro
   
.macro input_int(%reg)  # macro for reading int and writing to register %reg
	li a7 5
	ecall
	mv %reg a0
.end_macro

.text
	.globl main
    main:
        li t0 1
        li t1 2
		confirm_dialog("Press Yes to run the program, No to run tests or Cancel for exit", t2)
        beqz t2 jal_user  # if t2 == 0 => Yes => run program
        beq t2 t0 jal_test  # if t2 == 1 => No => run tests
        beq t2 t1 jal_exit  # if t2 == 2 => Cancel => exit

        j main  # repeat solution

    jal_exit:
        j exit  # go to exit

    jal_user:
        jal run_user  # call function for user input
        j main  # repeat solution

    jal_test:
        jal run_test  # call function for running tests
        j main  # repeat solution

    exit:  # exit
        li a7 10
        ecall
