# Addition of decimal strings

# strings are stored in global data section 
        .data   
dst:    .space  128
str1:   .space  128
str2:   .space  128

# instructions are in text section
        .text
main: 
        # load adresses of strings into s1, s2, and s3
        # s3 is dst, where we store the result 

        lui     s3, 0x10010 
        addi    s1, s3, 128
        addi    s2, s1, 128

        # read the first number as a string
        addi    a0, s1, 0
        addi    a1, x0, 100
        addi    a7, x0, 8
        ecall

        # read the second number as a string
        addi    a0, s2, 0
        addi    a1, x0, 100
        addi    a7, x0, 8
        ecall

        # constants
        addi    a4, x0, '0'
        addi    a5, x0, 10

        # Note it is assumed str1, str2, and dst have the same number of 
        # decimal digits. 
        
        
        
        
        # The following code takes care of finding the length of the strings
        
        # Create an incrementor (offset to get to the next char) and create a counter to count the digits
        addi t0, t0, 0		# t0 = 0
        
        # start our loop
loop1:
	
	add t2, s1, t0		# Get the address and save in t2
	lb t1, 1(t2)		# Get the chracter and save in t1
	addi t0, t0, 1		# Increment our counter
	bne t1, x0, loop1   	# If the character we are at is not equal to 0, which tells us it is the end of the string,
				# continue the loop
	# t0 now holds the number of digits in the string PLUS the termination at the end 
	# Ex: 12345 	t0 = 6
	addi t0, t0, -1		# Remove the addition of the null 0
	
	
	
	
	
	
	
	
	
	
	
	
	# The following code takes care of adding str1 and str2 and saving the result in dst
	
	# Create a counter for our loop and a carry for our loop
	addi t3, t0, 0		# t3 = t0
	addi s8, s8, 0		# s8 = 0
	
loop2:
	# Get the correct position of the strings
	add t4, s1, t3		# Get the address of str1 and save in t4
	add t5, s2, t3		# Get the address of str2 and save in t5
	add t6, s3, t3		# Get the address of dst and save in t6
	
	# Get the characters at str1[i], str2[i], and dst[i]
	lb s4, -1(t4)		# Load the byte at str1[i] into s4
	lb s5, -1(t5)		# Load the byte at str2[i] into s5

	
	 # Convert the ascii into integers  
	addi s4, s4, -48
	addi s5, s5, -48
	
	# Add them together and check if the sum is greater or equal to 10
	add s6, s4, s5		# Add together
	add s6, s6, s8		# Also add in our carry
	
	# Get the remainder 
	addi s7, s6, -10	# Compute s6 - 10
	
	# If s7 is less than zero, our remainder should be s6
	blt s7, x0, no_remain
	
	# Otherwise, our remainder should be s7 and should be stored in dst[i]
	addi s7, s7, 48		# Convert back to ascii
	sb s7, 0(t6)		# Store in dst[i]
	addi s8, x0, 1		# Update our carry
	beq x0, x0, continue	# Jump to continue

no_remain:
	# Our reaminder should be s6
	addi s6, s6, 48		# Convert back to ascii
	
	# Store in dst[i]
	sb s6, 0(t6)
	
	# Our carry should be 0 again
	addi s8, x0, 0
	
continue:
	# Decrement counter
	addi t3, t3, -1
	
	# Check condition
	bge t3, x0, loop2
	










	# The followng code will take care of the dst length being greater than the string length
	
	# Get length of dst
	# Create an incrementor (offset to get to the next char) and create a counter to count the digits
        addi s9, s9, 0		# t0 = 0
        
        # start our loop
loop3:
	
	add t2, s3, s9		# Get the address and save in t2
	lb t1, 1(t2)		# Get the chracter and save in t1
	addi s9, s9, 1		# Increment our counter
	bne t1, x0, loop3   	# If the character we are at is not equal to 0, which tells us it is the end of the string,
				# continue the loop

	
	# If the length of dst is the same as the length of the strings, then we are fine and can print
        beq s9, t0, print
        
        
       	# If we got here, then the length of dst is proabbly greater than the length of the str so we need to shift so that the excess byte is removed
        addi a2, a2, 0	# counter
loop4:
	# Get address of dst
	add a3, a2, s3
	lb a4, 1(a3)	# a4 = dst[i+1]
	sb a4, 0(a3)	# dst[i] = dst[i + 1]
	addi a2, a2, 1	# Increment counter
	bne a2, t0, loop4	# Keep looping if need to
	
	# Set last char to be 10
	add a6, t0, s3
	sb a5, 0(a6)
        
        
        






print:
        addi    a0, s3, 0
        addi    a7, x0, 4
        ecall

        # exit
        addi    a7, x0, 10
        ecall
