.include "macro-syscalls.m"
.global read 

.text
# params:	address of the file name in a1
#			size of the buffer for reading in a2
# return:	file descriptor in a0
#			start of buffer in a1
read:
	# save registers on stack
    push(ra)
    push(s0)
    push(s1)
    push(s2)
    push(s4)
    
    mv s1 a1
    mv s2 a2
    open(s1, READ_ONLY)
    li t0 -1  # check for correct file opening
    beq a0 t0 er_name  # error during opening file
    mv s0 a0
    allocate(s2)  # allocate memory of size s2
    mv s3 a0
    mv t1 a0
    mv s4 zero  # length of read text
while:
    read_addr_reg(s0, t1, s2)  # read into block address from register
    beq a0 t0 er_read  # error during reading file
    add s4 s4 a0
    bne a0 s2 end_while  # if read less than buffer size, break
    allocate(s2)
    add t1 t1 s2
    j while  # continue reading
end_while:
    close(s0)  # close file
    add t0 s3 s4
    addi t0 t0 1
    sb   zero (t0)  # write \0
    mv a0 s0
    mv a1 s3
    
    # restore registers
    pop(s4)
    pop(s3)
    pop(s1)
    pop(s0)
    pop(ra)
    ret

er_name:
    show("File opening error: wrong filename", ERROR)
    exit_code(-1)

er_read:
    show("File reading error", ERROR)
    exit_code(-1)
