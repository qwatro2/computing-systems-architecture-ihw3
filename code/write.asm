.include "macro-syscalls.m"
.global write 

.text
# params:	address of the file in a0
#			address of result in a1
#			N in a2
# return:	address of answer in a0
write:
	# save registers on stack
    push(s0)
    push(s1)
    push(s2)
    push(s3)
    
    mv s0 a0
    mv s1 a1
    mv s2 a2
    open(s0, WRITE_ONLY)
    li t0 -1  # ñheck for correct file opening
    beq a0 t0 er_name # error during opening file
    mv s0 a0
    li a7 64  # syscall for file write
    mv a0 s0
    mv a1 s1
    mv a2 s2
    ecall
    close(s0)
    
    # restore registers
    pop(s3)
    pop(s2)
    pop(s1)
    pop(s0)
    
    ret

er_name:
    show("File opening error: wrong filename", ERROR)
    exit_code(-1)
