.include "macro-syscalls.m"
.include "macrolib.m"
.global run_user

.eqv NAME_SIZE 256	
.eqv TEXT_SIZE 512	

.data
file: .space NAME_SIZE  # filename buffer
descriptor: .word 0  # file descriptor
buffer: .word 0  # buffer for reading
answer: .space 0  # buffer for answer.
answer_length: .word 0  # N

.text
run_user:
	push(ra)
	
  	input_n(a0, "Enter N")  # input N
  	
  	beqz a0 n_eq_zero  # N = 0 - not interesting
  	
  	mv s0 a0
  	la t0 answer_length
  	sw a0 (t0)
    allocate_reg(a0, a0)  # allocate memory for answer
    sw a0 answer t0
    
    input_path(file, NAME_SIZE, "Enter file name to read:")
    read(file, TEXT_SIZE)
	
    la	t0 descriptor
    sw  a0 (t0)
    la	t0 buffer
    sw  a1 (t0)
	
    solve(buffer, answer, s0)
	beqz a0 not_exists  # if not_exists, go to branch
	
    input_path(file, NAME_SIZE, "Input file name for writing:")
    write(file, answer, s0)
	
    # answer in a0, N in a1
	console_output(answer, s0)  # choice print result to console or no
	
	pop(ra)
    ret

	not_exists:
		show("Not exists", INFO)
		pop(ra)
		ret
		
	n_eq_zero:
		show("There is always a sequence of length 0", INFO)
		pop(ra)
		ret
