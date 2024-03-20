        .globl  main

        .text
main:   
        # create an array of 128 bytes on the stack
        addi    sp, sp, -128

        # copy array's address to a0
        addi    a0, sp, 0

	# set all bytes in the buffer to 'A'
        addi    a1, x0, -1       # a1 is the index
	addi	a2, x0, 128
	addi	t2, x0, 'A'
clear:
        add     t0, a0, a1
	sb	t2, 0(t0)
        addi    a1, a1, 1
	bne	a1, a2, clear
	
        # change a1 to other numbers to test
        addi	a1, zero, 2022
	jal	ra, uint2decstr

        # print the string
        addi    a0, sp, 0
        addi    a7, x0, 4
        ecall

exit:   addi    a7, x0, 10      
        ecall

# char * uint2decstr(char *s, unsigned int v) 
# the function converts an unsigned 32-bit value to a decimal string
# Examples:
# 0:    "0"
# 2022: "2022"
# -1:   "4294967295"
# -3666:   "4294963630"

uint2decstr:
	addi sp, sp -8		# Allocate space
	sw s1, 4(sp)		# Save v
	sw ra, 0(sp)		# Store return address
	
	addi t1, x0, 10		# t1 = 10
	addi s1, a1, 0		# s1 = v
	
	bgeu a1,t1, if		# If v >= 10 go to if
	bltu a1, t1, else	# If v < 10 go to else
	 
if:
	divu a1, a1, t1		# v = v/10  
	jal ra, uint2decstr	# Recursive call 
	
else:
	remu t2, s1, t1		# r = v % 10 
	addi t2, t2, '0'	# t2 = r + '0'
	sb t2, 0(a0)		# s[0] = '0' + r
	sb x0, 1(a0)		# s[1] = 0
	
	addi a0, a0, 1		# Return address of s[1]
	
f_exit:
	lw ra, 0(sp)		# Restore return address
	lw s1, 4(sp)		# Restore v
	addi sp, sp, 8		# Pop a word from the stack
	jalr x0, ra, 0		# Return 
		
