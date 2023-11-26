.include "macro-syscalls.m"
.include "macrolib.m"
.global console_output 

.text
# params: begin of result in a0
#		  length of result in a1
console_output:
	mv t5 a0
	mv t6 a1
    li t1 1  # No
while:
    confirm_dialog("Print result to console? ", t0)
if_no:
    beq t0 t1 continue   
if_yes:
    beqz t0 end_while
else:  # cancel
    show("You should press Yes or No", WARNING)
    j while

end_while:
    for: beqz t6 end_for
    	lbu t0 (t5)
    	beqz t0 end_for
    	print_char_reg(t0)
    	inc t5
    	dec t6
    	j for
	end_for:  
		newline            	
continue:
    ret
