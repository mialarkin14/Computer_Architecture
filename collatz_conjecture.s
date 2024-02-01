# Program that reads a positive integer number n and prints out the total stopping time 
# using the Collatz Conjecture to get the number down to 1

# FAILS PAST 8,400,511 DUE TO OVERFLOW

	# Read the positive integer and save it in s0
	addi a7, x0, 5		# system call to read an integer and save in a0
	ecall 
	addi s0, a0, 0		# saves integer into s0
	
	# Set up variables
	addi s1, s1, 0		# use s1 to keep track of the number of function runs s1 = 0
	addi s2, s2, 1		# use s2 to check loop condition (if s0 == 1 exit loop)
	
	# Start loop by going into the test condition 
	beq x0, x0, test	# go test the loop condition first
	
loop: 
	# Check if number is even or odd 
	addi t0, s0, 0		# create a copy of the inputted integer 
	slli t0, t0, 31		# shift 31 bits to the left to extract the leastsignificant bit 
				# if t0 > 0 it will be an odd number
				# if t0 = 0 it will be an even number
	
	beq t0, x0, even	# go to even if t0 = 0
	
	# Integer is odd. Multiply by 3, add 1, and increase stopping time counter
	# Multiply by 3 shifting left one bit and adding the original integer
	addi t1, s0, 0		# create a copy of the integer
	slli s0, s0, 1		# shift integer left by 1 bit to multiply by 2
	add  s0, s0, t1		# add original value to multiplied integer
	addi s0, s0, 1		# add 1 to the integer that was multiplied by 3
	addi s1, s1, 1		# increase stopping time counter 
	
	# skip over even case and head to test 
	beq x0, x0, test
	
	
even: 
	# Divide the integer by 2 and increase stopping time counter
	srli s0, s0, 1		# shift integer right by 1 bit to divide by 2
	addi s1, s1, 1		# increase stopping time counter 
	
test: 
	bne s0, s2, loop 	# if s0 is not equal to 1 continue the loop
	
	# Out of loop so print the stopping time
	addi a7, x0, 1 		# system call to print an integer
	addi a0, s1, 0		# saves stopping time into a0 to print out
	ecall    

