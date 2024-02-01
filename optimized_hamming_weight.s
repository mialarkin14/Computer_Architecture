# Code that computes the Hamming weight and saves an instruction by checking the 2s complement 
# of the number 

	addi s1, x0, 0 	# s1 = 0
	add t0, x0, s0	# make a copy so s0 is not changed

	# check if the number is greater than 0. If the number is greater than zero then
	# it is a positive number that means in 2s complement, the leftmost bit is 0 
	# if it is less than zero, the number is negative, that means the leftmost bit is 1
	
loop: 
	bge t0, x0, skip	# check if the number is greater than zero  
	addi s1, s1, 1		# otherwise the number is negative so the most significant bit is 1 
				# increase counter 


skip:
	slli t0, t0, 1		# shift copy of number 1 to the left
	bne t0, x0, loop	# continue the loop only if t0 is not 0


