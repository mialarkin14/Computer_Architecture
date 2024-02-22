# Code that will search through a pre-made array of words
# Implements through recursion, saving and restoring variables to the stack

	.data
	.align	2	
word_array:     .word
        0,   10,   20,  30,  40,  50,  60,  70,  80,  90, 
        100, 110, 120, 130, 140, 150, 160, 170, 180, 190,
        200, 210, 220, 230, 240, 250, 260, 270, 280, 290,
        300, 310, 320, 330, 340, 350, 360, 370, 380, 390,
        400, 410, 420, 430, 440, 450, 460, 470, 480, 490,
        500, 510, 520, 530, 540, 550, 560, 570, 580, 590,
        600, 610, 620, 630, 640, 650, 660, 670, 680, 690,
        700, 710, 720, 730, 740, 750, 760, 770, 780, 790,
        800, 810, 820, 830, 840, 850, 860, 870, 880, 890,
        900, 910, 920, 930, 940, 950, 960, 970, 980, 990

        # code
        .text
        .globl  main
main:   
	addi	s0, x0, -1
	addi	s4, x0, -1
	addi	s5, x0, -1
	addi	s6, x0, -1
	addi	s7, x0, -1

	# help to check if any saved registers are changed during the function call
	# could add more...

        # la      s1, word_array
        lui     s1, 0x10010      # starting addr of word_array in standard memory config
        addi    s2, x0, 100      # 100 elements in the array

        # read an integer from the console
        addi    a7, x0, 5
        ecall

        addi    s3, a0, 0       # keep a copy of v in s3
        
        # call binary search
        addi	a0, s1, 0
        addi	a1, s2, 0
        addi	a2, s3, 0
        jal	ra, binary_search

exit:   addi    a7, x0, 10      
        ecall

binary_search:
        
        
        # Adjust the stack so it can hold 4 items, the return address and its arguements
        addi sp, sp, -8 	# Stack can now hold 2 words
        sw ra, 4(sp)		# Save the return address
        sw s1, 0(sp)		# Save the address of the array
        
        
        # Check if our array holds nothing 
        bne a1, x0, calculate 	# If n != 0 then go to calculate
        addi a0, x0, -1		# Otherwise set the return value to -1
        beq x0, x0, f_exit	# Exit our function
        

# Calculate half (n/2) and half_v (a[half])
calculate:
	# Divide by 2 
	srli t0, a1, 1		# Shift right once to t0 = a1/2 or half = n/2; HALF = t0
	
	# Calculates half_v --> a[half] and saves in t2
	slli t1, t0, 2		# Shift left 2 to multiply by 4 to get the correct offset and save in t1
	add t1, t1, a0		# Get the address of a[half]; t1 = address of a[half]
	lw t2, 0(t1)		# Get the value at a[half] and save in t2; t2 = half_v

# Go through branches 
	beq a2, t2, EQUAL	# If a2 == t2 go to equal
	blt a2, t2, ELSE_IF	# If a2 < t2 go to else_if
	beq x0, x0, ELSE	# If we got here then a2 > a4 so go to else 
	
	
EQUAL:
	addi a0, t0, 0		# Set the return value to half
	beq x0, x0, f_exit	# Exit

ELSE_IF:
	add a1, x0, t0		# Set a1 (n) to be half 
	jal ra, binary_search	# Recursive call on binary search; binary_search(a, half, v)
	beq x0, x0, f_exit	# Exit

ELSE:
	addi s1, t0, 1		# s1 = t0 + 1 --> left = half + 1
	slli t4, s1, 2		# Calculate the address offset and save in t4
	add t4, t4, a0		# Compute the address of &a[left] 
	
	sub a1, a1, s1		# n = n - left
	add a0, x0, t4		# Set a0 to be the &a[left]
	jal ra, binary_search 	# Recursive call on binary search; binary_search(&a[left], n - left, v)
	
	# Check if return value is greater or equal to 0
	bge a0, x0, add_left
	
	# Otherwise we go to exit
	beq x0, x0, f_exit	# Exit
	
add_left:
	add a0, a0, s1		# rv = rv + left
	beq x0, x0, f_exit	# Exit






# Exit our function
f_exit:
	lw ra, 4(sp)		# Restore return address
	lw s1, 0(sp)
	addi sp, sp, 8 		# Pop 2 words from the stack
	jalr x0, ra, 0		# Return 
        
        
        
        
        
        
        
       
        
      
