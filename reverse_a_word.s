# Code that reverses the order of bytes contained in s2 and saves it in s4
# Ex: s2 contains 0x12345678 then s4 contains 0x78563412

# Manually change what s2 contains
lui s2, 0x789AC		# Load upper 20 bits into s2 
addi s2, s2, 0xFFFFFCDE 	# Add the remaining 12 bits into s2 
# Because of overflow we have to increase the last hex digit by one and add 5 F's because of 
# because of sign extension. In reality the number we have above is 789ABCDE


# Shift left to send the least significant byte to the most signficant byte  
slli, t0, s2, 24		#Shift left 24 bits or 6 nibbles		Ex: 0x12345678 		t0 = 0x78000000

# Shift right to send the most significant byte to the least signficant byte
srli, t1, s2, 24		#Shift right 24 bits or 6 nibbles 		Ex: 0x12345678		t1 = 0x00000012

# Get the middle right byte and shift 
srli, t2, s2, 8			#Shift right 8 bits or 2 nibbles		Ex: 0x12345678 		t2 = 0x00123456
slli, t2, t2, 24		#Shift left 24 bits or 6 nibbles 		Ex: 0x00123456		t2 = 0x56000000
srli, t2, t2, 8			#Shift right 8 bits or 2 nibbles		Ex: 0x56000000		t2 = 0x00560000

# Get the middle left byte and shift 
srli, t3, s2, 16		#Shift right 16 bits or 4 nibbles 		Ex: 0x12345678		t3 = 0x00001234
slli, t3, t3, 24		#Shift left 24 bits or 6 nibbles		Ex: 0x00001234		t3 = 0x34000000
srli, t3, t3, 16		#Shift right 16 bits or 4 nibbles		Ex: 0x34000000		t3 = 0x00003400

# Add all temporaries together and save in s4
add s4, t0, t1 			#Add values in t0 and t1 together and save in s4	Ex: s4 = 0x78000012
add s4, s4, t2			#Add value in t2 to s4 and save in s4			Ex: s4 = 0x78560012
add s4, s4, t3			#Add value in t3 to s4 and save in s4			Ex: s4 = 0x78563412


# Print out the reversed word
addi a7, x0, 34
addi a0, s4, 0
ecall
