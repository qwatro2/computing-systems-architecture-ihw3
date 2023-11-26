.include "macrolib.m"
.include "macro-syscalls.m"

.global solve

# params:	buffer in a0, answer in a1, answer_length in a2
# return 	0 if sequance not exists else 1 in a0
solve:		
	mv t0 a0  # current char in buffer pointer
	mv t1 a1  # current char in answer pointer
	add t6 t1 a2  # end of answer
	
	lbu t2 (t0)
	sb t2 (t1)
	
	li t3 1
	beq a2 t3 found
	
	inc t0
	inc t1
	
	while: beqz t2 end_while
		lbu t2 (t0)  # buffer[t0]
		addi t3 t0 -1
		lbu t3 (t3)  # buffer[t0 - 1]
		
		blt t2 t3 less_case
		
		# greater or equal case
		mv t1 a1
		sb t2 (t1)
		inc t1
		inc t0
		j while
					
		less_case:
			sb t2 (t1)
			inc t1
			inc t0
			beq t1 t6 found  # if len(answer) == N break
			j while  # else new iteration
			
	end_while:
		mv a0 zero
		ret
	
	found:
		li a0 1
		ret	
