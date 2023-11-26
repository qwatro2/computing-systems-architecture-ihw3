.include "macro-syscalls.m"
.include "macrolib.m"
.global run_test

.eqv NAME_SIZE 256	
.eqv TEXT_SIZE 512	

.data
file: .space NAME_SIZE  # filename buffer
descriptor: .word 0  # file descriptor
buffer: .word 0  # buffer for reading
answer: .space 0  # buffer for answer.
answer_length: .word 0  # N

# test data
tf1: .asciz "../data/test_1.txt"
tn1: .word 6
tr1: .asciz "../data/result_1.txt"
ta1: .asciz "987654"

tf2: .asciz "../data/test_2.txt"
tn2: .word 6
tr2: .asciz "../data/result_2.txt"
ta2: .asciz "xvmc62"

tf3: .asciz "../data/test_3.txt"
tn3: .word 4
tr3: .asciz "../data/result_3.txt"
ta3: .asciz "mf10"

tf4: .asciz "../data/test_4.txt"
tn4: .word 3
tr4: .asciz "../data/result_4.txt"
ta4: .asciz "zyx"

tf5: .asciz "../data/test_5.txt"
tn5: .word 5
tr5: .asciz "../data/result_5.txt"
ta5: .asciz "nmhc4"

tf6: .asciz "../data/test_6.txt"
tn6: .word 6
tr6: .asciz "../data/result_6.txt"
ta6: .asciz "not exists"

.text
run_test:
	push(ra)
	
TEST1:
	la t0 tn1
	lw s0 (t0)
  	la t0 answer_length
  	sw a0 (t0)
    allocate_reg(a0, a0)  # allocate memory for answer
    sw a0 answer t0

    read(tf1, TEXT_SIZE)
	
    la	t0 descriptor
    sw  a0 (t0)
    la	t0 buffer
    sw  a1 (t0)
	
    solve(buffer, answer, s0)
	beqz a0 not_exists  # if not_exists, go to branch
	
    write(tr1, answer, s0)

TEST2:
    la t0 tn2
    lw s0 (t0)
    la t0 answer_length
    sw a0 (t0)
    allocate_reg(a0, a0)  # allocate memory for answer
    sw a0 answer t0

    read(tf2, TEXT_SIZE)

    la  t0 descriptor
    sw  a0 (t0)
    la  t0 buffer
    sw  a1 (t0)

    solve(buffer, answer, s0)
    beqz a0 not_exists  # if not_exists, go to branch

    write(tr2, answer, s0)


TEST3:
    la t0 tn3
    lw s0 (t0)
    la t0 answer_length
    sw a0 (t0)
    allocate_reg(a0, a0)  # allocate memory for answer
    sw a0 answer t0

    read(tf3, TEXT_SIZE)

    la  t0 descriptor
    sw  a0 (t0)
    la  t0 buffer
    sw  a1 (t0)

    solve(buffer, answer, s0)
    beqz a0 not_exists  # if not_exists, go to branch

    write(tr3, answer, s0)

	TEST4:
    la t0 tn4
    lw s0 (t0)
    la t0 answer_length
    sw a0 (t0)
    allocate_reg(a0, a0)  # allocate memory for answer
    sw a0 answer t0

    read(tf4, TEXT_SIZE)

    la  t0 descriptor
    sw  a0 (t0)
    la  t0 buffer
    sw  a1 (t0)

    solve(buffer, answer, s0)
    beqz a0 not_exists  # if not_exists, go to branch

    write(tr4, answer, s0)


TEST5:
    la t0 tn5
    lw s0 (t0)
    la t0 answer_length
    sw a0 (t0)
    allocate_reg(a0, a0)  # allocate memory for answer
    sw a0 answer t0

    read(tf5, TEXT_SIZE)

    la  t0 descriptor
    sw  a0 (t0)
    la  t0 buffer
    sw  a1 (t0)

    solve(buffer, answer, s0)
    beqz a0 not_exists  # if not_exists, go to branch

    write(tr5, answer, s0)
    
TEST6:
    la t0 tn6
    lw s0 (t0)
    la t0 answer_length
    sw a0 (t0)
    allocate_reg(a0, a0)  # allocate memory for answer
    sw a0 answer t0

    read(tf6, TEXT_SIZE)

    la  t0 descriptor
    sw  a0 (t0)
    la  t0 buffer
    sw  a1 (t0)

    solve(buffer, answer, s0)
    beqz a0 not_exists  # if not_exists, go to branch

    write(tr6, answer, s0)

TEST_RESULTS:	
	beqz s9 test_failed
	show("All tests passed!", INFO)
	pop(ra)
	ret
	
	test_failed: show("Some tests failed", WARNING)
	
	pop(ra)
	ret

not_exists:
	show("Not exists", WARNING)
	pop(ra)
	ret
