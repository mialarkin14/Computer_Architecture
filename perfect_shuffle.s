# A loop to shuffle n words
# the address of the source array src is in s1
# the address of the destination array dst is in s3
# register s2 will store the address of the second half of src
  
  
# In c:
# for(i = 0; i < n/2; i +=1){
#	dst[i+i] = left[i]
#	dst[i+i+1] = right[i]	
# }

        
        .data                   #data segment
        .align 2

src:   .word   
  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,
 10,  11,  12,  13,  14,  15,  16,  17,  18,  19,
 20,  21,  22,  23,  24,  25,  26,  27,  28,  29,
 30,  31,  32,  33,  34,  35,  36,  37,  38,  39,
 40,  41,  42,  43,  44,  45,  46,  47,  48,  49,
 50,  51,  52,  53,  54,  55,  56,  57,  58,  59,
 60,  61,  62,  63,  64,  65,  66,  67,  68,  69,
 70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
 80,  81,  82,  83,  84,  85,  86,  87,  88,  89,
 90,  91,  92,  93,  94,  95,  96,  97,  98,  99,
100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
120, 121, 122, 123, 124, 125, 126, 127

dst:    .space  1024

        .text
        .globl  main

main: 
        lui     s1, 0x10010     # hard-coded src address
        addi    s3, s1, 512     # s3 is the destination array

        # read n, the number of words to shuffle
        # n is even and 2 <= n <= 128
        addi    a7, x0, 5
        ecall

        # n is in a0
        addi t0, a0, 0		# Save "n" in t0


        
        addi a1, x0, 0		# Set i = 0 and save in a1
        srli t0, t0, 1		# Divide n by 2 and save it in t0
        
        # Calculate the starting address of right side of array
        slli a4, t0, 2 		# Multiply n/2 by 4 and save in a4
        add s2, s1, a4		# Set the starting address of s2
        
        
        # Go to the test 
        beq x0, x0, test
      
loop: 
	
	# The following takes care of dst[i + i] = left[i]
	slli t1, a1, 2		# t1 = i * 4
	add t2, a1, a1		# Add i together (i + i)
	
	add a2, s1, t1		# Compute the address of left[i] and save in a2
	lw t4, 0(a2)		# Load the word at left[i] in t4
	
	slli t3, t2, 2		# t3 = (i + i) * 4
	add a3, s3, t3		# Compute the address of dst[i + i] and save in a3 
	sw t4, 0(a3)		# Store the word at left[i] (saved in t4) into the address of dst[i + i] (saved in a3)
	
	
	# The following takes care of dst[i + i + 1] = right[i]
	add a5, s2, t1		# Compute the address of right[i] and save in a5
	lw t6, 0(a5)		# Load the word at right[i] in t6
	
	addi a6, a3, 4		# Compute the address of dst[i + i + 1] and save in a6
	sw t6, 0(a6)		# Store the word at right[i] (saved in t6) into the address of dst[i + i + 1] (saved in a6)
	
	# Increment counter
	addi a1, a1, 1
	
	
	# Check the condition 
test: 
	blt a1, t0, loop
	
	

exit:   addi    a7, x0, 10      # syscall to exit
        ecall   
