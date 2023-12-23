.text
.global _main


_main:

	li a0, 0					# File descriptor
	
	la, a0, prompter			# Load address of the prompter to a0	
	jal ra, ecall_print_str			# print the prompter
	
	jal ra, ecall_get_integer			# get number of numbers from the user
							# a0 has the user input
	mv a1, a0				# set arguments of get_array_elements
	jal ra, get_array_elements	# get elements from the user as many as the input

	jal ra, ecall_exit				# Exit the program
	
	


get_array_elements: #( input [a1], )
	mv t1, a1
	la, a2, array								# a2 == 0(array)
	get_element:							
		beqz t1, get_array_exit					# if t1 == 0 exit the function
	
		addi sp, sp, -4	
		sw ra, 0(sp)							# store return address to stack
	
		jal ra, ecall_get_integer 						# a0 = integer entered by user
	
		lw ra, 0(sp)							# load back return address of the caller from stack
		addi sp, sp, 4
	
		addi sp, sp, -4	
		sw ra, 0(sp)							# store return address to stack
	
		jal ra, add_element_to_the_array 		# add a0 to array
	
		lw ra, 0(sp)							# load back return address of the caller from stack
		addi sp, sp, 4
	
		addi t1, t1, -1							# a1--
		addi a2, a2, 4
		beq x0, x0, get_element
	
	get_array_exit:
		jalr zero, 0(ra)

	


add_element_to_the_array: # (a0 = value,  a2 = address)
		sw a0, 0(a2)
		jalr zero, 0(ra)

get_element_from_the_array:  # (a0 = value,  a2 = address)
		lw a0, 0(a2)
		jalr zero, 0(ra)

print_array: # (a1 = the number of elements to print)

	la a2, array							# a2 has the adress of the array[0]
	mv t1, a1								#t1 is the number of elements to print				
	print_element:
		beqz t1, print_array_exit			 # if t1 == 0 stop printing
		
		addi sp, sp, -4	
		sw ra, 0(sp)						# store return address to stack
		
		jal ra,  get_element_from_the_array	# the element is in a0
		
		jal ra, ecall_print_int				# print the element in a0
		

		
	print_array_exit:
		jalr zero, 0(ra)

# Helper Functions			
ecall_exit:
	li a7, 93
	ecall
	jalr x0 0(x1)
	
ecall_print_str: 
	li a7, 4
	ecall
	jalr x0 0(x1)

ecall_print_int: #(a0 = integer)
	li a7, 1
	ecall
	jalr zero, 0(ra)

ecall_get_integer:
	li a7, 5
	ecall	
	jalr zero 0(ra) 
				
.data
	next_line: .asciz " \n"
	prompter: .asciz "How many integers are you going to enter?: "
	prompter_2: .asciz "Printing the array:\n"
	.align 4
	array: .word 


							