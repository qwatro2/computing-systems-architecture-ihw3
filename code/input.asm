.include "macro-syscalls.m"
.global input 

.text
# params: address of filename buffer in a1
#		  size of the filename buffer in a2
#		  address of message in a3
input:
	# save registers on stack
    push(ra)             
    push(s1)             
    push(s2)             
    push(s3)  
               
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv a0 s3
    mv a1 s1
    li a2 256  # maximum size of input
    li a7 54  # syscall for InputDialogString
    ecall
    str_get(s1)  # read filename
    
    # restore registers
    pop(s3)
    pop(s2)
    pop(s1)
    pop(ra)
    
    ret
